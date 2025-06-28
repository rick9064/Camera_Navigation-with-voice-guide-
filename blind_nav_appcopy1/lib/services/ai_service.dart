import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class AIService {
  final ObjectDetector _detector;

  AIService()
      : _detector = ObjectDetector(
          options: ObjectDetectorOptions(
            mode: DetectionMode.single,
            classifyObjects: true,
            multipleObjects: true,
          ),
        );

  Future<List<DetectedObject>> detectObstacles(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final objects = await _detector.processImage(inputImage);
      return objects;
    } catch (e) {
      print("AIService error: $e");
      return [];
    }
  }
}