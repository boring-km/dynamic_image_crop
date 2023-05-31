import 'dart:ui' as ui;

import 'package:dynamic_image_crop/colors.dart';
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = guideColor
      ..strokeWidth = 1.0
      ..filterQuality = FilterQuality.high;

    canvas
      ..drawLine(rect.topLeft, rect.topRight, linePaint)
      ..drawLine(rect.topLeft, rect.bottomLeft, linePaint)
      ..drawLine(rect.bottomLeft, rect.bottomRight, linePaint)
      ..drawLine(rect.bottomRight, rect.topRight, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class RectanglePainterForCrop extends CustomPainter {
  RectanglePainterForCrop(this.rect, this.center, this.image);

  final Rect rect;
  final Offset center;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addRect(rect);

    canvas
      ..clipPath(path)
      ..drawImageRect(
        image,
        Rect.fromCenter(
          center: center,
          width: rect.width,
          height: rect.height,
        ),
        Rect.fromLTWH(0, 0, rect.width, rect.height),
        Paint()..filterQuality = FilterQuality.high,
      );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
