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
      ..strokeWidth = 1.0;

    canvas.drawLine(rect.bottomLeft, rect.topCenter, linePaint);
    canvas.drawLine(rect.topCenter, rect.bottomRight, linePaint);
    canvas.drawLine(rect.bottomRight, rect.bottomLeft, linePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TrianglePainterForCrop extends CustomPainter {
  TrianglePainterForCrop(this.rect, this.image);

  final Rect rect;
  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {

    var path = Path()
      ..moveTo(rect.bottomLeft.dx, rect.bottomLeft.dy)
      ..lineTo(rect.topCenter.dx, rect.topCenter.dy)
      ..lineTo(rect.bottomRight.dx, rect.bottomRight.dy)
      ..lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);

    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

