import 'package:dynamic_image_crop/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class TrianglePainter extends CustomPainter {
  TrianglePainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = guideColor
      ..strokeWidth = 1.0
      ..filterQuality = FilterQuality.high;

    canvas
      ..drawLine(rect.bottomLeft, rect.topCenter, linePaint)
      ..drawLine(rect.topCenter, rect.bottomRight, linePaint)
      ..drawLine(rect.bottomRight, rect.bottomLeft, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TrianglePainterForCrop extends CustomPainter {
  TrianglePainterForCrop(this.rect, this.center, this.image);

  final Rect rect;
  final Offset center;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..lineTo(rect.topCenter.dx, rect.topCenter.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);

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
