import 'dart:math';

import 'package:dynamic_image_crop/src/crop/crop_area.dart';
import 'package:dynamic_image_crop/src/shape_painter/drawing_painter.dart';
import 'package:flutter/material.dart';

class DrawingView extends StatefulWidget {
  const DrawingView({
    required this.painterWidth,
    required this.painterHeight,
    required this.lineColor,
    required this.strokeWidth,
    super.key,
  });

  final double painterWidth;
  final double painterHeight;
  final Color lineColor;
  final double strokeWidth;

  @override
  State<DrawingView> createState() => DrawingViewState();
}

class DrawingViewState extends State<DrawingView> {
  late final painterWidth = widget.painterWidth;
  late final painterHeight = widget.painterHeight;
  late final lineColor = widget.lineColor;
  late final strokeWidth = widget.strokeWidth;

  final List<Offset?> points = <Offset?>[];
  bool isFirst = true;
  Offset? first;

  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: painterWidth,
      height: painterHeight,
      child: GestureDetector(
        onPanDown: (details) {
          setState(() {
            final position = details.localPosition;
            points.add(position);
          });
        },
        onPanStart: (details) {
          setState(() {
            final position = details.localPosition;
            if (isFirst) {
              first = position;
              isFirst = false;
            }
            points.add(position);
          });
        },
        onPanUpdate: (details) {
          final localPosition = details.localPosition;
          final dx = localPosition.dx;
          final dy = localPosition.dy;

          if (0 <= dx && dx <= painterWidth && 0 <= dy && dy <= painterHeight) {
            setState(() {
              points.add(localPosition);
            });
          }
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: RepaintBoundary(
          key: globalKey,
          child: CustomPaint(
            painter: DrawingPainter(points, first, lineColor, strokeWidth),
            child: Container(),
          ),
        ),
      ),
    );
  }

  CropArea getDrawingArea() {
    var start = points[0]!.dx;
    var top = points[0]!.dy;
    var end = start;
    var bottom = top;

    for (final point in points) {
      if (point == null) continue;
      start = min(start, point.dx);
      end = max(end, point.dx);
      top = min(top, point.dy);
      bottom = max(bottom, point.dy);
    }

    final width = end - start;
    final height = bottom - top;
    return CropArea(start, top, width, height);
  }
}
