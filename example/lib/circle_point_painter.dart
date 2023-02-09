import 'package:flutter/material.dart';

class CirclePointPainter extends CustomPainter {
  CirclePointPainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, Paint()..color = Colors.transparent);

    final realCircle =
    Rect.fromCircle(center: rect.center, radius: rect.width / 4);
    canvas.drawOval(realCircle, Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
