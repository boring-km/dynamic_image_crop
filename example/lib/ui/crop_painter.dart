import 'dart:ui' as ui;

import 'package:flutter/material.dart';

const _kCropOverlayActiveOpacity = 0;
const _kCropOverlayInactiveOpacity = 0;
const _kCropHandleColor = Colors.deepOrangeAccent;
const _kCropHandleSize = 10.0;

class MyCropPainter extends CustomPainter {
  MyCropPainter({
    this.image,
    required this.view,
    required this.ratio,
    required this.area,
    required this.scale,
    required this.active,
  });

  final ui.Image? image;
  final Rect view;
  final double ratio;
  final Rect area;
  final double scale;
  final double active;

  @override
  bool shouldRepaint(MyCropPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.view != view ||
        oldDelegate.ratio != ratio ||
        oldDelegate.area != area ||
        oldDelegate.active != active ||
        oldDelegate.scale != scale;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      _kCropHandleSize / 2,
      _kCropHandleSize / 2,
      size.width - _kCropHandleSize,
      size.height - _kCropHandleSize,
    );

    canvas
      ..save()
      ..translate(rect.left, rect.top);

    final paint = Paint()..isAntiAlias = false;

    final image = this.image;
    if (image != null) {
      final src = Rect.fromLTWH(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      final dst = Rect.fromLTWH(
        view.left * image.width * scale * ratio,
        view.top * image.height * scale * ratio,
        image.width * scale * ratio,
        image.height * scale * ratio,
      );

      canvas
        ..save()
        ..clipRect(Rect.fromLTWH(0, 0, rect.width, rect.height))
        ..drawImageRect(image, src, dst, paint)
        ..restore();
    }

    paint.color = Color.fromRGBO(
      0x0,
      0x0,
      0x0,
      _kCropOverlayActiveOpacity * active +
          _kCropOverlayInactiveOpacity * (1.0 - active),
    );
    final boundaries = Rect.fromLTWH(
      rect.width * area.left,
      rect.height * area.top,
      rect.width * area.width,
      rect.height * area.height,
    );
    canvas
      ..drawRect(Rect.fromLTRB(0, 0, rect.width, boundaries.top), paint)
      ..drawRect(
        Rect.fromLTRB(0, boundaries.bottom, rect.width, rect.height),
        paint,
      )
      ..drawRect(
        Rect.fromLTRB(
          0,
          boundaries.top,
          boundaries.left,
          boundaries.bottom,
        ),
        paint,
      )
      ..drawRect(
        Rect.fromLTRB(
          boundaries.right,
          boundaries.top,
          rect.width,
          boundaries.bottom,
        ),
        paint,
      );

    if (boundaries.isEmpty == false) {
      _drawHandles(canvas, boundaries);
    }

    canvas.restore();
  }

  void _drawHandles(Canvas canvas, Rect boundaries) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = _kCropHandleColor;

    final linePaint = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final linePath = Path()
      ..moveTo(boundaries.left, boundaries.top)
      ..lineTo(boundaries.left, boundaries.bottom)
      ..moveTo(boundaries.right, boundaries.top)
      ..lineTo(boundaries.right, boundaries.bottom)
      ..moveTo(boundaries.left, boundaries.top)
      ..lineTo(boundaries.right, boundaries.top)
      ..moveTo(boundaries.left, boundaries.bottom)
      ..lineTo(boundaries.right, boundaries.bottom);

    canvas
      ..drawPath(linePath, linePaint)
      ..drawOval(
        Rect.fromLTWH(
          boundaries.left - _kCropHandleSize / 2,
          boundaries.top - _kCropHandleSize / 2,
          _kCropHandleSize,
          _kCropHandleSize,
        ),
        paint,
      )
      ..drawOval(
        Rect.fromLTWH(
          boundaries.right - _kCropHandleSize / 2,
          boundaries.top - _kCropHandleSize / 2,
          _kCropHandleSize,
          _kCropHandleSize,
        ),
        paint,
      )
      ..drawOval(
        Rect.fromLTWH(
          boundaries.right - _kCropHandleSize / 2,
          boundaries.bottom - _kCropHandleSize / 2,
          _kCropHandleSize,
          _kCropHandleSize,
        ),
        paint,
      )
      ..drawOval(
        Rect.fromLTWH(
          boundaries.left - _kCropHandleSize / 2,
          boundaries.bottom - _kCropHandleSize / 2,
          _kCropHandleSize,
          _kCropHandleSize,
        ),
        paint,
      );
  }
}
