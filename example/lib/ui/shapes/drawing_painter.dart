import 'package:dynamic_image_crop_example/const/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.points, this.first, this.image);

  final List<Offset?> points;
  final Offset? first;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawImage(image, const Offset(0, 0), Paint());

    final paint = Paint()
      ..color = guideColor
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
