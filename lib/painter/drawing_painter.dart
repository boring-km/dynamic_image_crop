import 'package:dynamic_image_crop/colors.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.points, this.first);

  final List<Offset?> points;
  final Offset? first;

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = guideColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]!.dx, points[0]!.dy);
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
          path.lineTo(points[i + 1]!.dx, points[i + 1]!.dy);
        } else if (points[i] != null && points[i + 1] == null) {
          path.lineTo(first!.dx, first!.dy);
        }
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DrawingCropPainter extends CustomPainter {
  DrawingCropPainter(this.points, this.first, this.image, this.left, this.top);

  final List<Offset?> points;
  final Offset? first;
  final ui.Image image;
  final double left;
  final double top;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (points.isNotEmpty) {
      var firstDx = first!.dx - left;
      var firstDy = first!.dy - top;

      path.moveTo(firstDx, firstDy);
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
          var nextDx = points[i + 1]!.dx - left;
          var nextDy = points[i + 1]!.dy - top;
          path.lineTo(nextDx, nextDy);
        } else if (points[i] != null && points[i + 1] == null) {
          path.lineTo(firstDx, firstDy);
        }
      }
    }
    canvas.clipPath(path);
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
