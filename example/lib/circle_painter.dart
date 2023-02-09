import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CirclePainter extends CustomPainter {
  CirclePainter(this.rect, this.image, this.imageOffset);

  final Rect rect;
  final ui.Image image;
  final Offset imageOffset;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawImage(image, imageOffset, Paint());

    canvas.drawOval(rect, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
