// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

// Map<String, dynamic> decideDirection(
//     List<DetectedObject> objects, double imageWidth, double imageHeight) {
//   bool leftClear = true;
//   bool centerClear = true;
//   bool rightClear = true;

//   List<String> leftLabels = [], centerLabels = [], rightLabels = [];

//   for (final obj in objects) {
//     if (obj.labels.isEmpty) continue;

//     final rawLabel = obj.labels.first.text.toLowerCase();
//     final label = _mapLabel(rawLabel);
//     if (label == null) continue;

//     final box = obj.boundingBox;
//     final area = box.width * box.height;
//     final yBottom = box.top + box.height;

//     // Skip small or far obstacles
//     if (area < 2500 || yBottom < imageHeight * 0.6) continue;

//     final xStart = box.left;
//     final xEnd = box.left + box.width;

//     // Mark areas as blocked and collect labels
//     if (xStart < imageWidth * 0.33) {
//       leftClear = false;
//       leftLabels.add(label);
//     }

//     if (xEnd > imageWidth * 0.66) {
//       rightClear = false;
//       rightLabels.add(label);
//     }

//     if (xStart < imageWidth * 0.66 && xEnd > imageWidth * 0.33) {
//       centerClear = false;
//       centerLabels.add(label);
//     }
//   }

//   // Decide path direction
//   String dir;
//   if (centerClear) {
//     dir = "forward";
//   } else if (leftClear) {
//     dir = "left";
//   } else if (rightClear) {
//     dir = "right";
//   } else {
//     dir = "stop";
//   }

//   // Build guiding message
//   String message = "";

//   if (!centerClear && centerLabels.isNotEmpty) {
//     message += "There is ${_formatList(centerLabels)} ahead. ";
//     if (leftClear) {
//       message += "Please move slightly left. ";
//     } else if (rightClear) {
//       message += "Please move slightly right. ";
//     }
//   }

//   if (!leftClear && leftLabels.isNotEmpty && dir != "left") {
//     message += "On your left: ${_formatList(leftLabels)}. ";
//   }

//   if (!rightClear && rightLabels.isNotEmpty && dir != "right") {
//     message += "On your right: ${_formatList(rightLabels)}. ";
//   }

//   if (leftClear && centerClear && rightClear) {
//     message = "Path is clear. You can walk forward.";
//   }

//   if (!leftClear && !centerClear && !rightClear) {
//     message = "You are surrounded by obstacles. Please stop and scan your surroundings.";
//   }

//   return {
//     "message": message.trim(),
//     "direction": dir,
//   };
// }

// String? _mapLabel(String label) {
//   switch (label) {
//     case 'chair':
//     case 'table':
//     case 'person':
//     case 'laptop':
//     case 'bottle':
//     case 'tv':
//     case 'door':
//     case 'bed':
//     case 'sofa':
//     case 'screen':
//     case 'monitor':
//     case 'keyboard':
//       return label;
//     case 'home good':
//     case 'product':
//     case 'electronic device':
//       return 'object';
//     default:
//       return null;
//   }
// }

// String _formatList(List<String> items) {
//   final unique = items.toSet().toList();
//   if (unique.isEmpty) return '';
//   if (unique.length == 1) return "a ${unique[0]}";
//   if (unique.length == 2) return "a ${unique[0]} and a ${unique[1]}";
//   return unique.map((e) => "a $e").join(", ");
// }
