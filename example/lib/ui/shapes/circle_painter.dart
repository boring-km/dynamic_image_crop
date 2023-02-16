import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CirclePainter extends CustomPainter {
  CirclePainter(this.rect, this.image);

  final Rect rect;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawImage(image, const Offset(0, 0), Paint());
    canvas.drawOval(rect, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CirclePainterForCrop extends CustomPainter {
  CirclePainterForCrop(this.rect, this.image);

  final Rect rect;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addOval(rect);

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
