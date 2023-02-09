import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect, this.image, this.imageOffset);

  final Rect rect;
  final ui.Image image;
  final Offset imageOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1.0;

    canvas.drawImage(image, imageOffset, Paint());
    canvas.drawLine(rect.topLeft, rect.topRight, linePaint);
    canvas.drawLine(rect.topLeft, rect.bottomLeft, linePaint);
    canvas.drawLine(rect.bottomLeft, rect.bottomRight, linePaint);
    canvas.drawLine(rect.bottomRight, rect.topRight, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

