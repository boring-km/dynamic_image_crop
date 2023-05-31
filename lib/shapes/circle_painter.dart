import 'dart:ui' as ui;

import 'package:dynamic_image_crop/colors.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = guideColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..filterQuality = FilterQuality.high;

    canvas.drawOval(rect, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CirclePainterForCrop extends CustomPainter {
  CirclePainterForCrop(this.rect, this.center, this.image);

  final Rect rect;
  final Offset center;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()..addOval(rect);

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
