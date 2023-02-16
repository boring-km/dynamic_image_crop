import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect, this.image);

  final Rect rect;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.orange
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

class RectanglePainterForCrop extends CustomPainter {
  RectanglePainterForCrop(this.rect, this.image);

  final Rect rect;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(rect.topLeft.dx, rect.topLeft.dy)
      ..lineTo(rect.topRight.dx, rect.topRight.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..lineTo(rect.topLeft.dx, rect.topLeft.dy);

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

