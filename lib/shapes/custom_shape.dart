import 'dart:math';

import 'package:dynamic_image_crop/painter/drawing_area.dart';
import 'package:dynamic_image_crop/painter/drawing_painter.dart';
import 'package:flutter/material.dart';

class CustomShape extends StatefulWidget {
  const CustomShape({
    required this.painterWidth,
    required this.painterHeight,
    super.key,
  });

  final double painterWidth;
  final double painterHeight;

  @override
  State<CustomShape> createState() => CustomShapeState();
}

class CustomShapeState extends State<CustomShape> {
  late final painterWidth = widget.painterWidth;
  late final painterHeight = widget.painterHeight;

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
        onPanStart: (details) {
          setState(() {
            final renderBox = context.findRenderObject() as RenderBox?;
            if (renderBox != null) {
              final position = renderBox.globalToLocal(details.globalPosition);
              if (isFirst) {
                first = position;
                isFirst = false;
              }
              points.add(position);
            }
          });
        },
        onPanUpdate: (details) {
          final localPosition = details.localPosition;
          final dx = localPosition.dx;
          final dy = localPosition.dy;

          if (0 <= dx && dx <= painterWidth && 0 <= dy && dy <= painterHeight) {
            setState(() {
              final renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                points.add(renderBox.globalToLocal(details.globalPosition));
              }
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
            painter: DrawingPainter(points, first),
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
