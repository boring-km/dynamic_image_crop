import 'package:dynamic_image_crop/colors.dart';
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = guideColor
      ..strokeWidth = 1.0;

    canvas.drawLine(rect.topLeft, rect.topRight, linePaint);
    canvas.drawLine(rect.topLeft, rect.bottomLeft, linePaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, linePaint);
    canvas.drawLine(rect.bottomRight, rect.topRight, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
