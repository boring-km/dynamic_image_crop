import 'package:dynamic_image_crop/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect, this.image);

  final Rect rect;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = guideColor
      ..strokeWidth = 1.0;

    canvas.drawImage(image, const Offset(0, 0), Paint());
    canvas.drawLine(rect.topLeft, rect.topRight, linePaint);
    canvas.drawLine(rect.topLeft, rect.bottomLeft, linePaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, linePaint);
    canvas.drawLine(rect.bottomRight, rect.topRight, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
