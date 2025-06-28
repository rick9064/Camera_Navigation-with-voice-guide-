import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../services/tts_service.dart';

class CameraLiveScreen extends StatefulWidget {
  const CameraLiveScreen({super.key});

  @override
  _CameraLiveScreenState createState() => _CameraLiveScreenState();
}

class _CameraLiveScreenState extends State<CameraLiveScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  String? _apiResponse;
  String _arrowDirection = 'stop';
  bool _isProcessing = false;
  bool _isSpeaking = false;
  Timer? _timer;
  late TTSService _ttsService;
  late AnimationController _animationController;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ttsService = TTSService();
    _ttsService.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
          ..repeat(reverse: true);
    _progress = Tween<double>(begin: 0, end: 1).animate(_animationController);
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(cameras![0], ResolutionPreset.medium);
    await _controller!.initialize();
    if (mounted) {
      setState(() {});
      _startPeriodicCapture();
    }
  }

  void _startPeriodicCapture() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _captureAndSend());
  }

  Future<void> _captureAndSend() async {
    if (_controller == null || _isProcessing || _isSpeaking) return;

    try {
      _isProcessing = true;
      final directory = await getTemporaryDirectory();
      final filePath = path.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
      await _controller!.takePicture().then((image) async {
        final imageFile = File(image.path);
        await _sendToAPI(imageFile);
      });
    } catch (e) {
      print("Error capturing image: $e");
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _sendToAPI(File file) async {
    final url = Uri.parse("https://live-nav-aws.onrender.com/detect/");
    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (!mounted) return;

      final decoded = jsonDecode(respStr);
      final formattedInstruction = _formatInstruction(decoded);

      setState(() {
        _apiResponse = formattedInstruction;
        _isSpeaking = true;
        _arrowDirection = _getDirectionFromZones(decoded['safe_zones'] ?? []);
      });

      await _ttsService.speak(formattedInstruction);
    } catch (e) {
      final error = "Failed to connect to the server.";
      setState(() {
        _apiResponse = error;
        _arrowDirection = 'stop';
        _isSpeaking = true;
      });
      await _ttsService.speak(error);
    }
  }

  String _formatInstruction(Map<String, dynamic> json) {
    final objects = (json['objects_within_2m'] as List<dynamic>? ?? []).cast<String>();
    final zones = (json['safe_zones'] as List<dynamic>? ?? []).cast<String>();

    final buffer = StringBuffer();

    if (objects.isNotEmpty) {
      for (final o in objects) {
        buffer.writeln("$o.");
      }
    }

    if (zones.isNotEmpty) {
      final zoneText = zones.join(" and ");
      buffer.writeln("Path is safe on your $zoneText.");
    }

    if (zones.contains("left") && zones.contains("right")) {
      buffer.writeln("You may proceed forward.");
    } else if (zones.contains("left")) {
      buffer.writeln("Please go slightly left.");
    } else if (zones.contains("right")) {
      buffer.writeln("Please go slightly right.");
    } else {
      buffer.writeln("Please stop and scan surroundings.");
    }

    return buffer.toString().trim();
  }

  String _getDirectionFromZones(List<dynamic> zones) {
    if (zones.contains("left") && zones.contains("right")) return "forward";
    if (zones.contains("left")) return "left";
    if (zones.contains("right")) return "right";
    return "stop";
  }

  @override
  void dispose() {
    _ttsService.dispose();
    _controller?.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screenSize = MediaQuery.of(context).size;
    final previewSize = _controller!.value.previewSize!;
    final previewAspectRatio = previewSize.height / previewSize.width;
    final screenAspectRatio = screenSize.width / screenSize.height;

    return Scaffold(
      appBar: AppBar(title: const Text("Live Camera Navigation")),
      body: Stack(
        children: [
          Column(
            children: [
              AspectRatio(
                aspectRatio: previewAspectRatio,
                child: OverflowBox(
                  maxHeight: screenAspectRatio > previewAspectRatio
                      ? screenSize.width / previewAspectRatio
                      : screenSize.height,
                  maxWidth: screenAspectRatio > previewAspectRatio
                      ? screenSize.width
                      : screenSize.height * previewAspectRatio,
                  child: CameraPreview(_controller!),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Navigation Output:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _apiResponse ?? "Waiting for data...",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _progress,
            builder: (_, __) {
              return CustomPaint(
                painter: DirectionArrowPainter(_arrowDirection, _progress.value),
                child: Container(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DirectionArrowPainter extends CustomPainter {
  final String direction;
  final double progress;

  DirectionArrowPainter(this.direction, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = direction == "stop" ? Colors.red : Colors.green
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height * 0.75);
    final path = Path();

    switch (direction) {
      case "left":
        path.moveTo(center.dx + 30, center.dy);
        path.quadraticBezierTo(
          center.dx - 100 * progress,
          center.dy - 100 * progress,
          center.dx - 120 * progress,
          center.dy - 200 * progress,
        );
        canvas.drawPath(path, paint);
        break;
      case "right":
        path.moveTo(center.dx - 30, center.dy);
        path.quadraticBezierTo(
          center.dx + 100 * progress,
          center.dy - 100 * progress,
          center.dx + 120 * progress,
          center.dy - 200 * progress,
        );
        canvas.drawPath(path, paint);
        break;
      case "forward":
        path.moveTo(center.dx, center.dy);
        path.lineTo(center.dx, center.dy - 200 * progress);
        canvas.drawPath(path, paint);
        break;
      case "stop":
        final stopPaint = Paint()..color = Colors.red;
        canvas.drawCircle(center, 30 + 5 * progress, stopPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant DirectionArrowPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.direction != direction;
}
