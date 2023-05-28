import 'dart:math';

import 'package:dynamic_image_crop/painter/drawing_area.dart';
import 'package:dynamic_image_crop/painter/drawing_painter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomShape extends StatefulWidget {
  const CustomShape(
    this.uiImage, {
    required this.top,
    required this.left,
    required this.painterWidth,
    required this.painterHeight,
    Key? key,
  }) : super(key: key);

  final ui.Image uiImage;
  final double top;
  final double left;
  final double painterWidth;
  final double painterHeight;

  @override
  State<CustomShape> createState() => CustomShapeState();
}

class CustomShapeState extends State<CustomShape> {
  late final top = widget.top;
  late final left = widget.left;
  late final painterWidth = widget.painterWidth;
  late final painterHeight = widget.painterHeight;

  final List<Offset?> points = <Offset?>[];
  bool isFirst = true;
  Offset? first;

  var globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            var position = renderBox.globalToLocal(details.globalPosition);
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
            RenderBox? renderBox = context.findRenderObject() as RenderBox?;
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
    );
  }

  DrawingArea getDrawingArea() {
    double start = points[0]!.dx;
    double top = points[0]!.dy;
    double end = start;
    double bottom = top;

    for (final point in points) {
      if (point == null) continue;
      start = min(start, point.dx);
      end = max(end, point.dx);
      top = min(top, point.dy);
      bottom = max(bottom, point.dy);
    }

    final width = end - start;
    final height = bottom - top;
    return DrawingArea(start, top, width, height);
  }
}
