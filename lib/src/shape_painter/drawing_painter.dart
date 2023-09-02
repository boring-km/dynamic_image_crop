import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  DrawingPainter(this.points, this.first, this.lineColor, this.strokeWidth);

  final List<Offset?> points;
  final Offset? first;
  final Color lineColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..filterQuality = FilterQuality.high;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]!.dx, points[0]!.dy);
      for (var i = 0; i < points.length - 1; i++) {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingCropPainter extends CustomPainter {
  DrawingCropPainter(
    this.points,
    this.first,
    this.cropCenter,
    this.image,
    this.ratio,
    this.crop,
  );

  final List<Offset?> points;
  final Offset? first;
  final Offset cropCenter;
  final ui.Image image;
  final Size ratio;
  final Rect crop;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    if (points.isNotEmpty) {
      final firstDx = first!.dx * ratio.width;
      final firstDy = first!.dy * ratio.height;

      path.moveTo(firstDx, firstDy);
      for (var i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
          final nextDx = points[i + 1]!.dx * ratio.width;
          final nextDy = points[i + 1]!.dy * ratio.height;
          path.lineTo(nextDx, nextDy);
        } else if (points[i] != null && points[i + 1] == null) {
          path.lineTo(firstDx, firstDy);
        }
      }
    }
    canvas
      ..clipPath(path)
      ..drawImageRect(
        image,
        Rect.fromCenter(
          center: cropCenter,
          width: size.width,
          height: size.height,
        ),
        Rect.fromLTWH(
          crop.left * image.width,
          crop.top * image.height,
          size.width,
          size.height,
        ),
        Paint()..filterQuality = FilterQuality.high,
      );
  }

  // coverage:ignore-start
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  // coverage:ignore-end
}
