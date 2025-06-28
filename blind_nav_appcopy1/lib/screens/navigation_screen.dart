// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import '../services/camera_service.dart';
// import '../services/tts_service.dart';
// import '../services/ai_service.dart';
// import '../utils/nav_logic.dart';
// import '../utils/animated_arrow.dart';
// import '../utils/enums.dart';
// import '../utils/obstacle_painter.dart';
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

// class NavigationScreen extends StatefulWidget {
//   const NavigationScreen({super.key});

//   @override
//   State<NavigationScreen> createState() => _NavigationScreenState();
// }

// class _NavigationScreenState extends State<NavigationScreen> {
//   late CameraService _cameraService;
//   late TTSService _ttsService;
//   late AIService _aiService;

//   List<DetectedObject> _currentObstacles = [];
//   String _lastSpoken = "";
//   DateTime _lastSpokenTime = DateTime.now();
//   bool _isCameraInitialized = false;
//   OverlayDirection _overlayDirection = OverlayDirection.forward;

//   @override
//   void initState() {
//     super.initState();
//     _ttsService = TTSService();
//     _aiService = AIService();
//     _cameraService = CameraService(onCapture: _processImage);
//     _initializeCamera();
//   }

//   Future<void> _initializeCamera() async {
//     await _cameraService.initialize();
//     if (mounted) {
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     }
//   }

//   Future<void> _processImage(String imagePath) async {
//     final obstacles = await _aiService.detectObstacles(imagePath);
//     if (!mounted) return;

//     final previewSize = _cameraService.controller?.value.previewSize;
//     final imageWidth = previewSize?.width ?? 360;
//     final imageHeight = previewSize?.height ?? 640;

//     final result = decideDirection(obstacles, imageWidth, imageHeight);
//     final directionText = result['message'] ?? '';
//     final dir = result['direction'] ?? 'forward';

//     setState(() {
//       _currentObstacles = obstacles;
//       _overlayDirection = _mapDirection(dir);
//     });

//     final now = DateTime.now();
//     if (directionText != _lastSpoken || now.difference(_lastSpokenTime).inSeconds > 5) {
//       _ttsService.speak(directionText);
//       _lastSpoken = directionText;
//       _lastSpokenTime = now;
//     }
//   }

//   OverlayDirection _mapDirection(String dir) {
//     switch (dir) {
//       case 'left':
//         return OverlayDirection.left;
//       case 'right':
//         return OverlayDirection.right;
//       case 'stop':
//         return OverlayDirection.stop;
//       default:
//         return OverlayDirection.forward;
//     }
//   }

//   @override
//   void dispose() {
//     _cameraService.dispose();
//     _ttsService.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _isCameraInitialized && _cameraService.controller != null
//           ? Stack(
//               children: [
//                 CameraPreview(_cameraService.controller!),
//                 CustomPaint(
//                   painter: ObstaclePainter(
//                   _currentObstacles,
//                   _cameraService.controller!.value.previewSize ?? const Size(360, 640),
//                     ),
//                   size: Size.infinite,
//                   ),

//                 AnimatedArrow(direction: _overlayDirection),
//                 const Positioned(
//                   top: 40,
//                   left: 20,
//                   child: Text(
//                     'Navigating...',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ],
//             )
//           : const Center(child: CircularProgressIndicator()),
//     );
//   }
// }
