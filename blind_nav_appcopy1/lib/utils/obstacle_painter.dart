// import 'package:flutter/material.dart';
// import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

// class ObstaclePainter extends CustomPainter {
//   final List<DetectedObject> objects;
//   final Size imageSize;

//   ObstaclePainter(this.objects, this.imageSize);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint boxPaint = Paint()
//       ..color = Colors.redAccent
//       ..strokeWidth = 2
//       ..style = PaintingStyle.stroke;

//     final textStyle = TextStyle(
//       color: Colors.white,
//       backgroundColor: Colors.redAccent,
//       fontSize: 12,
//     );

//     final double scaleX = size.width / imageSize.width;
//     final double scaleY = size.height / imageSize.height;

//     for (final obj in objects) {
//       final box = obj.boundingBox;

//       final scaledRect = Rect.fromLTRB(
//         box.left * scaleX,
//         box.top * scaleY,
//         box.right * scaleX,
//         box.bottom * scaleY,
//       );

//       canvas.drawRect(scaledRect, boxPaint);

//       if (obj.labels.isNotEmpty) {
//         final label = obj.labels.first.text;
//         final span = TextSpan(text: label, style: textStyle);
//         final painter = TextPainter(
//           text: span,
//           textDirection: TextDirection.ltr,
//         )..layout();

//         painter.paint(canvas, Offset(scaledRect.left, scaledRect.top - 15));
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(covariant ObstaclePainter oldDelegate) {
//     return oldDelegate.objects != objects || oldDelegate.imageSize != imageSize;
//   }
// }
