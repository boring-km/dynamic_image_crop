import 'package:flutter/material.dart';
import 'package:dynamic_image_crop_example/const/colors.dart';

class SizeController extends CustomPainter {
  SizeController(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, Paint()..color = Colors.transparent);

    final width = rect.width;

    final controller = Rect.fromLTWH(rect.left, rect.top, width, rect.height);

    canvas.drawRect(controller, Paint()..color = guideColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
