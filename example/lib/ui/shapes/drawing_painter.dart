import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.points, this.first);

  final List<Offset?> points;
  final Offset? first;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]!.dx, points[0]!.dy);
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
          path.lineTo(points[i + 1]!.dx, points[i + 1]!.dy);
        } else if (points[i] != null && points[i + 1] == null) {
          path.lineTo(first!.dx, first!.dy);
        }
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
