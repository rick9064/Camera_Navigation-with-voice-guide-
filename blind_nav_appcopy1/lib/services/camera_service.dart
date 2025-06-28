import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final Function(String path) onCapture;
  CameraController? controller;
  late List<CameraDescription> _cameras;
  bool _isCapturing = false;

  CameraService({required this.onCapture});

  Future<void> initialize() async {
    await Permission.camera.request();
    _cameras = await availableCameras();
    final rearCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
    );

    controller = CameraController(rearCamera, ResolutionPreset.medium, enableAudio: false);
    await controller!.initialize();
    _startCapturing();
  }

  void _startCapturing() {
    _isCapturing = true;
    Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!_isCapturing || controller == null || !controller!.value.isInitialized) return;
      try {
        final picture = await controller!.takePicture();
        onCapture(picture.path);
      } catch (e) {
        debugPrint('Camera capture failed: $e');
      }
    });
  }

  void dispose() {
    _isCapturing = false;
    controller?.dispose();
  }
}