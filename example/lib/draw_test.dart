// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop_example/circle_painter.dart';
import 'package:dynamic_image_crop_example/circle_point_painter.dart';
import 'package:dynamic_image_crop_example/rectangle_painter.dart';
import 'package:dynamic_image_crop_example/shape_type.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'dart:ui' as ui;

import 'package:image_size_getter/image_size_getter.dart' as isg;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Custom Painter',
      home: Scaffold(
        body: CustomPainterDraggable(
          movingDotSize: 20,
        ),
      ),
    );
  }
}

class CustomPainterDraggable extends StatefulWidget {
  const CustomPainterDraggable({super.key, this.movingDotSize = 30});

  final double movingDotSize;

  @override
  State<CustomPainterDraggable> createState() => _CustomPainterDraggableState();
}

class _CustomPainterDraggableState extends State<CustomPainterDraggable> {
  var xPos = 0.0;
  var yPos = 0.0;
  double shapeWidth = 200.0;
  double shapeHeight = 200.0;
  bool isShapeDragging = false;
  late double pointerSize = widget.movingDotSize;
  late double radius = widget.movingDotSize / 2;

  ui.Image? image;
  bool imageLoaded = false;
  bool isImageLoaded = false;

  ShapeType shapeType = ShapeType.rectangle;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var deviceHeight = MediaQuery.of(context).size.height;

      xPos = (MediaQuery.of(context).size.width - shapeWidth) / 2;
      yPos = (deviceHeight - shapeHeight) / 2;

      final file = await ImagePicker().pickImage(source: ImageSource.camera);
      if (file != null) {
        var fileInput = FileInput(File(file.path));
        final imageSize = isg.ImageSizeGetter.getSize(fileInput);
        image =
            await loadImage(await file.readAsBytes(), imageSize, deviceHeight);
        setState(() {});
      }
    });

    super.initState();
  }

  Future<ui.Image> loadImage(
      Uint8List img, isg.Size imageSize, double deviceHeight) async {
    var targetWidth = (imageSize.width / imageSize.height) * deviceHeight;
    final codec = await ui.instantiateImageCodec(
      img,
      targetWidth: targetWidth.toInt(),
      targetHeight: deviceHeight.toInt(),
    );
    return (await codec.getNextFrame()).image;
  }

  @override
  Widget build(BuildContext context) {
    return (image != null)
        ? Stack(
            children: [
              GestureDetector(
                onPanStart: (details) => setPointDragState(details),
                onPanEnd: (details) => resetDragState(),
                onPanUpdate: (details) => setShapeMovement(details),
                child: Container(
                  color: Colors.white,
                  child: Builder(
                    builder: (context) {
                      if (shapeType == ShapeType.rectangle) {
                        return CustomPaint(
                          painter: RectanglePainter(
                            Rect.fromLTWH(
                              xPos + radius,
                              yPos + radius,
                              shapeWidth,
                              shapeHeight,
                            ),
                            image!,
                            const Offset(0, 0),
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
                            image!,
                            const Offset(0, 0),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  ),
                ),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            shapeType = ShapeType.rectangle;
                          });
                        },
                        child: const Text('네모')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            shapeType = ShapeType.circle;
                          });
                        },
                        child: const Text('동그라미')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            shapeType = ShapeType.triangle;
                          });
                        },
                        child: const Text('세모')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            shapeType = ShapeType.custom;
                          });
                        },
                        child: const Text('직접 그리기')),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Crop'),
                ),
              ),
            ],
          )
        : Container();
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
    xPos += tx;
    yPos += ty;
    if (shapeWidth + width > 50) {
      shapeWidth += width;
    }
    if (shapeHeight + height > 50) {
      shapeHeight += height;
    }
  }

  void setPointDragState(DragStartDetails details) {
    if (isPoint1Drag(details)) {
      isPoint1Dragging = true;
    } else if (isPoint2Drag(details)) {
      isPoint2Dragging = true;
    } else if (isPoint3Drag(details)) {
      isPoint3Dragging = true;
    } else if (isPoint4Drag(details)) {
      isPoint4Dragging = true;
    } else if (isPoint6Drag(details)) {
      isPoint6Dragging = true;
    } else if (isPoint7Drag(details)) {
      isPoint7Dragging = true;
    } else if (isPoint8Drag(details)) {
      isPoint8Dragging = true;
    } else if (isPoint9Drag(details)) {
      isPoint9Dragging = true;
    } else if (isShapeDrag(details)) {
      isShapeDragging = true;
    }
  }

  bool isShapeDrag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos &&
        details.globalPosition.dx <= xPos + shapeWidth &&
        details.globalPosition.dy >= yPos &&
        details.globalPosition.dy <= yPos + shapeHeight;
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

  bool isPoint1Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos &&
        details.globalPosition.dx <= xPos + pointerSize &&
        details.globalPosition.dy >= yPos &&
        details.globalPosition.dy <= yPos + pointerSize;
  }

  bool isPoint4Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos &&
        details.globalPosition.dx <= xPos + pointerSize &&
        details.globalPosition.dy >= yPos + shapeHeight / 2 &&
        details.globalPosition.dy <= yPos + shapeHeight / 2 + pointerSize;
  }

  bool isPoint6Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + shapeWidth &&
        details.globalPosition.dx <= xPos + shapeWidth + pointerSize &&
        details.globalPosition.dy >= yPos + shapeHeight / 2 &&
        details.globalPosition.dy <= yPos + shapeHeight / 2 + pointerSize;
  }

  bool isPoint7Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos &&
        details.globalPosition.dx <= xPos + pointerSize &&
        details.globalPosition.dy >= yPos + shapeHeight &&
        details.globalPosition.dy <= yPos + shapeHeight + pointerSize;
  }

  bool isPoint8Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + shapeWidth / 2 &&
        details.globalPosition.dx <= xPos + shapeWidth / 2 + pointerSize &&
        details.globalPosition.dy >= yPos + shapeHeight &&
        details.globalPosition.dy <= yPos + shapeHeight + pointerSize;
  }

  bool isPoint9Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + shapeWidth &&
        details.globalPosition.dx <= xPos + shapeWidth + pointerSize &&
        details.globalPosition.dy >= yPos + shapeHeight &&
        details.globalPosition.dy <= yPos + shapeHeight + pointerSize;
  }

  bool isPoint2Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + shapeWidth / 2 &&
        details.globalPosition.dx <= xPos + shapeWidth / 2 + pointerSize &&
        details.globalPosition.dy >= yPos &&
        details.globalPosition.dy <= yPos + pointerSize;
  }

  bool isPoint3Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + shapeWidth &&
        details.globalPosition.dx <= xPos + shapeWidth + pointerSize &&
        details.globalPosition.dy >= yPos &&
        details.globalPosition.dy <= yPos + pointerSize;
  }

  Widget MovePoint(double xPos, double yPos) {
    return SizedBox(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
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
