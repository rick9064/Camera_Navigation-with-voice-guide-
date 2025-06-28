// import 'package:flutter/material.dart';
// import 'enums.dart';

// class AnimatedArrow extends StatefulWidget {
//   final OverlayDirection direction;

//   const AnimatedArrow({super.key, required this.direction});

//   @override
//   State<AnimatedArrow> createState() => _AnimatedArrowState();
// }

// class _AnimatedArrowState extends State<AnimatedArrow>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   OverlayDirection _currentDirection = OverlayDirection.forward;

//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
//     _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
//     _controller.repeat(reverse: true);
//   }

//   @override
//   void didUpdateWidget(covariant AnimatedArrow oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.direction != _currentDirection) {
//       _currentDirection = widget.direction;
//       _controller.forward(from: 0);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Path _buildArrowPath(Size size, double progress) {
//     final center = Offset(size.width / 2, size.height * 0.75);
//     final path = Path();

//     switch (_currentDirection) {
//       case OverlayDirection.left:
//         path.moveTo(center.dx + 30, center.dy);
//         path.quadraticBezierTo(
//           center.dx - 100 * progress,
//           center.dy - 100 * progress,
//           center.dx - 120 * progress,
//           center.dy - 200 * progress,
//         );
//         break;
//       case OverlayDirection.right:
//         path.moveTo(center.dx - 30, center.dy);
//         path.quadraticBezierTo(
//           center.dx + 100 * progress,
//           center.dy - 100 * progress,
//           center.dx + 120 * progress,
//           center.dy - 200 * progress,
//         );
//         break;
//       case OverlayDirection.forward:
//         path.moveTo(center.dx, center.dy);
//         path.lineTo(center.dx, center.dy - 200 * progress);
//         break;
//       case OverlayDirection.stop:
//         // No animated path; will draw a stop icon separately
//         break;
//     }

//     return path;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (_, __) {
//         return CustomPaint(
//           size: Size.infinite,
//           painter: _ArrowPainter(_currentDirection, _animation.value),
//         );
//       },
//     );
//   }
// }

// class _ArrowPainter extends CustomPainter {
//   final OverlayDirection direction;
//   final double progress;

//   _ArrowPainter(this.direction, this.progress);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = direction == OverlayDirection.stop ? Colors.red : Colors.green
//       ..strokeWidth = 6
//       ..style = PaintingStyle.stroke;

//     final path = Path();
//     final center = Offset(size.width / 2, size.height * 0.75);

//     switch (direction) {
//       case OverlayDirection.left:
//         path.moveTo(center.dx + 30, center.dy);
//         path.quadraticBezierTo(
//           center.dx - 100 * progress,
//           center.dy - 100 * progress,
//           center.dx - 120 * progress,
//           center.dy - 200 * progress,
//         );
//         canvas.drawPath(path, paint);
//         break;
//       case OverlayDirection.right:
//         path.moveTo(center.dx - 30, center.dy);
//         path.quadraticBezierTo(
//           center.dx + 100 * progress,
//           center.dy - 100 * progress,
//           center.dx + 120 * progress,
//           center.dy - 200 * progress,
//         );
//         canvas.drawPath(path, paint);
//         break;
//       case OverlayDirection.forward:
//         path.moveTo(center.dx, center.dy);
//         path.lineTo(center.dx, center.dy - 200 * progress);
//         canvas.drawPath(path, paint);
//         break;
//       case OverlayDirection.stop:
//         final stopPaint = Paint()..color = Colors.red;
//         canvas.drawCircle(center, 30 + 5 * progress, stopPaint);
//         break;
//     }
//   }

//   @override
//   bool shouldRepaint(covariant _ArrowPainter oldDelegate) =>
//       oldDelegate.progress != progress || oldDelegate.direction != direction;
// }
