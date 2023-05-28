// ignore_for_file: non_constant_identifier_names

import 'dart:ui' as ui;
import 'package:dynamic_image_crop/shapes/circle_painter.dart';
import 'package:dynamic_image_crop/shapes/rectangle_painter.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop/shapes/triangle_painter.dart';
import 'package:dynamic_image_crop/size_controller.dart';
import 'package:flutter/material.dart';

class FigureCropPainter extends StatefulWidget {
  const FigureCropPainter({
    super.key,
    required this.painterWidth,
    required this.painterHeight,
    required this.uiImage,
    required this.shapeType,
    required this.topMargin,
    required this.startMargin,
    this.movingDotSize = 8,
  });

  final double painterWidth;
  final double painterHeight;
  final double movingDotSize;
  final ShapeType shapeType;
  final ui.Image uiImage;
  final double topMargin;
  final double startMargin;

  @override
  State<FigureCropPainter> createState() => FigureCropPainterState();
}

class FigureCropPainterState extends State<FigureCropPainter> {
  var xPos = 0.0;
  var yPos = 0.0;
  double shapeWidth = 200.0;
  double shapeHeight = 200.0;
  bool isShapeDragging = false;
  late double pointerSize = widget.movingDotSize;
  late double radius = widget.movingDotSize / 2;

  bool imageLoaded = false;
  bool isImageLoaded = false;

  late ShapeType shapeType = widget.shapeType;
  late final image = widget.uiImage;

  @override
  void initState() {
    xPos = (widget.painterWidth - shapeWidth) / 2;
    yPos = (widget.painterHeight - shapeHeight) / 2;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.painterWidth,
      height: widget.painterHeight,
      child: Stack(
        children: [
          FutureBuilder(
            future: image.toByteData(),
            builder: (_, snapshot) {
              return Image.memory(snapshot.data!.buffer.asUint8List());
            },
          ),
          GestureDetector(
            onPanStart: (details) => setPointDragState(details, context),
            onPanEnd: (details) => resetDragState(),
            onPanUpdate: (details) => setShapeMovement(details),
            onTapDown: (details) {
              debugPrint(
                  'dx: ${details.globalPosition.dx - widget.startMargin},'
                  ' dy: ${details.globalPosition.dy - widget.topMargin}');
              debugPrint('shape dx: $xPos, dy: $yPos');
            },
            child: Builder(builder: (context) {
              if (shapeType == ShapeType.rectangle) {
                return CustomPaint(
                  painter: RectanglePainter(
                    Rect.fromLTWH(
                      xPos + radius,
                      yPos + radius,
                      shapeWidth,
                      shapeHeight,
                    ),
                    widget.uiImage,
                  ),
                  child: Container(),
                );
              } else if (shapeType == ShapeType.circle) {
                return CustomPaint(
                  painter: CirclePainter(
                    Rect.fromLTWH(
                      xPos + radius,
                      yPos + radius,
                      shapeWidth,
                      shapeHeight,
                    ),
                    widget.uiImage,
                  ),
                  child: Container(),
                );
              } else if (shapeType == ShapeType.triangle) {
                return CustomPaint(
                  painter: TrianglePainter(
                    Rect.fromLTWH(
                      xPos + radius,
                      yPos + radius,
                      shapeWidth,
                      shapeHeight,
                    ),
                    widget.uiImage,
                  ),
                  child: Container(),
                );
              } else {
                return Container();
              }
            }),
          ),
          // on point 1,3,7,9
          MovePoint(xPos, yPos),
          MovePoint(xPos + shapeWidth, yPos),
          MovePoint(xPos, yPos + shapeHeight),
          MovePoint(xPos + shapeWidth, yPos + shapeHeight),
          // on line 2,4,6,8
          MovePoint(xPos + shapeWidth / 2, yPos),
          MovePoint(xPos + shapeWidth / 2, yPos + shapeHeight),
          MovePoint(xPos, yPos + shapeHeight / 2),
          MovePoint(xPos + shapeWidth, yPos + shapeHeight / 2),
        ],
      ),
    );
  }

  bool isPoint1Dragging = false;
  bool isPoint2Dragging = false;
  bool isPoint3Dragging = false;

  bool isPoint4Dragging = false;
  bool isPoint6Dragging = false;

  bool isPoint7Dragging = false;
  bool isPoint8Dragging = false;
  bool isPoint9Dragging = false;

  void setShapeMovement(DragUpdateDetails details) {
    final tx = details.delta.dx;
    final ty = details.delta.dy;

    setState(() {
      if (isPoint1Dragging) {
        movePoint(tx: tx, ty: ty, width: -tx, height: -ty);
      } else if (isPoint2Dragging) {
        movePoint(ty: ty, height: -ty);
      } else if (isPoint3Dragging) {
        movePoint(ty: ty, width: tx, height: -ty);
      } else if (isPoint4Dragging) {
        movePoint(tx: tx, width: -tx);
      } else if (isPoint6Dragging) {
        movePoint(width: tx);
      } else if (isPoint7Dragging) {
        movePoint(tx: tx, width: -tx, height: ty);
      } else if (isPoint8Dragging) {
        movePoint(height: ty);
      } else if (isPoint9Dragging) {
        movePoint(width: tx, height: ty);
      } else if (isShapeDragging) {
        movePoint(tx: tx, ty: ty);
      }
    });
  }

  void movePoint({
    double tx = 0,
    double ty = 0,
    double width = 0,
    double height = 0,
  }) {
    if (xPos + tx >= -radius &&
        xPos + tx + shapeWidth < widget.painterWidth - radius &&
        yPos + ty >= -radius &&
        yPos + ty + shapeHeight < widget.painterHeight - radius) {
      xPos += tx;
      yPos += ty;

      if (shapeWidth + width > 50) {
        shapeWidth += width;
      }
      if (shapeHeight + height > 50) {
        shapeHeight += height;
      }
    } else {}
  }

  void setPointDragState(DragStartDetails details, BuildContext context) {
    final dx = details.globalPosition.dx - widget.startMargin;
    final dy = details.globalPosition.dy - widget.topMargin;

    print('drag: $dx, $dy');
    print('shape: $xPos, $yPos');

    if (isPoint1Drag(dx, dy)) {
      isPoint1Dragging = true;
    } else if (isPoint2Drag(dx, dy)) {
      isPoint2Dragging = true;
    } else if (isPoint3Drag(dx, dy)) {
      isPoint3Dragging = true;
    } else if (isPoint4Drag(dx, dy)) {
      isPoint4Dragging = true;
    } else if (isPoint6Drag(dx, dy)) {
      isPoint6Dragging = true;
    } else if (isPoint7Drag(dx, dy)) {
      isPoint7Dragging = true;
    } else if (isPoint8Drag(dx, dy)) {
      isPoint8Dragging = true;
    } else if (isPoint9Drag(dx, dy)) {
      isPoint9Dragging = true;
    } else if (isShapeDrag(dx, dy)) {
      isShapeDragging = true;
    }
  }

  bool isShapeDrag(double dx, double dy) {
    return dx >= xPos &&
        dx <= xPos + shapeWidth &&
        dy >= yPos &&
        dy <= yPos + shapeHeight;
  }

  void resetDragState() {
    isPoint1Dragging = false;
    isPoint2Dragging = false;
    isPoint3Dragging = false;
    isPoint4Dragging = false;
    isPoint6Dragging = false;
    isPoint7Dragging = false;
    isPoint8Dragging = false;
    isPoint9Dragging = false;
    isShapeDragging = false;
  }

  final extraDragSize = 30;

  bool isPoint1Drag(double dx, double dy) {
    return dx >= xPos - extraDragSize &&
        dx <= xPos + pointerSize + extraDragSize &&
        dy >= yPos - extraDragSize &&
        dy <= yPos + pointerSize + extraDragSize;
  }

  bool isPoint4Drag(double dx, double dy) {
    return dx >= xPos - extraDragSize &&
        dx <= xPos + pointerSize + extraDragSize &&
        dy >= yPos + shapeHeight / 2 - extraDragSize &&
        dy <= yPos + shapeHeight / 2 + pointerSize + extraDragSize;
  }

  bool isPoint6Drag(double dx, double dy) {
    return dx >= xPos + shapeWidth - extraDragSize &&
        dx <= xPos + shapeWidth + pointerSize + extraDragSize &&
        dy >= yPos + shapeHeight / 2 - extraDragSize &&
        dy <= yPos + shapeHeight / 2 + pointerSize + extraDragSize;
  }

  bool isPoint7Drag(double dx, double dy) {
    return dx >= xPos - extraDragSize &&
        dx <= xPos + pointerSize + extraDragSize &&
        dy >= yPos + shapeHeight - extraDragSize &&
        dy <= yPos + shapeHeight + pointerSize + extraDragSize;
  }

  bool isPoint8Drag(double dx, double dy) {
    return dx >= xPos + shapeWidth / 2 - extraDragSize &&
        dx <= xPos + shapeWidth / 2 + pointerSize + extraDragSize &&
        dy >= yPos + shapeHeight - extraDragSize &&
        dy <= yPos + shapeHeight + pointerSize + extraDragSize;
  }

  bool isPoint9Drag(double dx, double dy) {
    return dx >= xPos + shapeWidth - extraDragSize &&
        dx <= xPos + shapeWidth + pointerSize + extraDragSize &&
        dy >= yPos + shapeHeight - extraDragSize &&
        dy <= yPos + shapeHeight + pointerSize + extraDragSize;
  }

  bool isPoint2Drag(double dx, double dy) {
    return dx >= xPos + shapeWidth / 2 - extraDragSize &&
        dx <= xPos + shapeWidth / 2 + pointerSize + extraDragSize &&
        dy >= yPos - extraDragSize &&
        dy <= yPos + pointerSize + extraDragSize;
  }

  bool isPoint3Drag(double dx, double dy) {
    return dx >= xPos + shapeWidth - extraDragSize &&
        dx <= xPos + shapeWidth + pointerSize + extraDragSize &&
        dy >= yPos - extraDragSize &&
        dy <= yPos + pointerSize + extraDragSize;
  }

  Widget MovePoint(double xPos, double yPos) {
    return SizedBox(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: SizeController(
            Rect.fromLTWH(
              xPos,
              yPos,
              pointerSize,
              pointerSize,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }
}
