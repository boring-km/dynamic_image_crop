import 'package:dynamic_image_crop_example/ui/shapes/drawing_painter.dart';
import 'package:flutter/material.dart';

class CustomCropPainter extends StatefulWidget {
  const CustomCropPainter({Key? key}) : super(key: key);

  @override
  State<CustomCropPainter> createState() => _CustomCropPainterState();
}

class _CustomCropPainterState extends State<CustomCropPainter> {

  final List<Offset?> _points = <Offset?>[];
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
            _points.add(position);
          }
        });
      },
      onPanUpdate: (details) {
        setState(() {
          RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            _points.add(renderBox.globalToLocal(details.globalPosition));
          }
        });
      },
      onPanEnd: (details) {
        setState(() {
          _points.add(null);
        });
      },
      child: RepaintBoundary(
        key: globalKey,
        child: CustomPaint(
          painter: DrawingPainter(_points, first),
          child: Container(),
        ),
      ),
    );
  }
}
