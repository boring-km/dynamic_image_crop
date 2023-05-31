import 'package:flutter/material.dart';

class SizeController extends CustomPainter {
  SizeController(this.rect, this.lineColor);

  final Rect rect;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, Paint()..color = Colors.transparent);

    final width = rect.width;

    final controller = Rect.fromLTWH(rect.left, rect.top, width, rect.height);

    canvas.drawRect(controller, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
