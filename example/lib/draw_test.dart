// ignore_for_file: non_constant_identifier_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Draggable Custom Painter',
      home: Scaffold(
        body: CustomPainterDraggable(),
      ),
    );
  }
}

class CustomPainterDraggable extends StatefulWidget {
  const CustomPainterDraggable({super.key});

  @override
  State<CustomPainterDraggable> createState() => _CustomPainterDraggableState();
}

class _CustomPainterDraggableState extends State<CustomPainterDraggable> {
  var xPos = 0.0;
  var yPos = 0.0;
  double width = 200.0;
  double height = 200.0;
  bool isShapeDragging = false;
  final pointerSize = 30.0;
  final radius = 30.0 / 2;

  bool isPoint1Dragging = false;
  bool isPoint2Dragging = false;
  bool isPoint3Dragging = false;

  bool isPoint4Dragging = false;
  bool isPoint6Dragging = false;

  bool isPoint7Dragging = false;
  bool isPoint8Dragging = false;
  bool isPoint9Dragging = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (details) {
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
            } else {

            }
          },
          onPanEnd: (details) {
            resetDragState();
          },
          onPanUpdate: (details) {
            final tx = details.delta.dx;
            final ty = details.delta.dy;
            if (isPoint1Dragging) {
              setState(() {
                xPos += tx;
                yPos += ty;
                width -= tx;
                height -= ty;
              });
            } else if (isPoint2Dragging) {
              setState(() {
                yPos += ty;
                height -= ty;
              });
            } else if (isPoint3Dragging) {
              setState(() {
                yPos += ty;
                width += tx;
                height -= ty;
              });
            } else if (isPoint4Dragging) {
              setState(() {
                xPos += tx;
                width -= tx;
              });
            } else if (isPoint6Dragging) {
              setState(() {
                width += tx;
              });
            } else if (isPoint7Dragging) {
              setState(() {
                xPos += tx;
                width -= tx;
                height += ty;
              });
            } else if (isPoint8Dragging) {
              setState(() {
                height += ty;
              });
            } else if (isPoint9Dragging) {
              setState(() {
                width += tx;
                height += ty;
              });
            } else if (isShapeDragging) {
              setState(() {
                xPos += tx;
                yPos += ty;
              });
            }
          },
          child: Container(
            color: Colors.white,
            child: CustomPaint(
              painter: RectanglePainter(
                Rect.fromLTWH(
                  xPos + radius,
                  yPos + radius,
                  width,
                  height,
                ),
              ),
              child: Container(),
            ),
          ),
        ),
        // on point
        Point1(),
        Point3(),
        Point7(),
        Point9(),
        // on line
        Point2(),
        Point8(),
        Point4(),
        Point6(),
      ],
    );
  }

  bool isShapeDrag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos &&
              details.globalPosition.dx <= xPos + width &&
              details.globalPosition.dy >= yPos &&
              details.globalPosition.dy <= yPos + height;
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
        details.globalPosition.dy >= yPos + height / 2 &&
        details.globalPosition.dy <= yPos + height / 2 + pointerSize;
  }

  bool isPoint6Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + width &&
        details.globalPosition.dx <= xPos + width + pointerSize &&
        details.globalPosition.dy >= yPos + height / 2 &&
        details.globalPosition.dy <= yPos + height / 2 + pointerSize;
  }

  bool isPoint7Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos &&
        details.globalPosition.dx <= xPos + pointerSize &&
        details.globalPosition.dy >= yPos + height &&
        details.globalPosition.dy <= yPos + height + pointerSize;
  }

  bool isPoint8Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + width / 2 &&
        details.globalPosition.dx <= xPos +  width / 2 + pointerSize &&
        details.globalPosition.dy >= yPos + height &&
        details.globalPosition.dy <= yPos + height + pointerSize;
  }

  bool isPoint9Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + width &&
        details.globalPosition.dx <= xPos +  width + pointerSize &&
        details.globalPosition.dy >= yPos + height &&
        details.globalPosition.dy <= yPos + height + pointerSize;
  }

  bool isPoint2Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + width / 2 &&
        details.globalPosition.dx <= xPos + width / 2 + pointerSize &&
        details.globalPosition.dy >= yPos &&
        details.globalPosition.dy <= yPos + pointerSize;
  }

  bool isPoint3Drag(DragStartDetails details) {
    return details.globalPosition.dx >= xPos + width &&
        details.globalPosition.dx <= xPos + width + pointerSize &&
        details.globalPosition.dy >= yPos &&
        details.globalPosition.dy <= yPos + pointerSize;
  }

  Widget Point6() {
    return Positioned(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
            Rect.fromLTWH(
              xPos + width,
              yPos + height / 2,
              pointerSize,
              pointerSize,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }

  Widget Point4() {
    return Positioned(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
            Rect.fromLTWH(
              xPos,
              yPos + height / 2,
              pointerSize,
              pointerSize,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }

  Widget Point8() {
    return Positioned(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
            Rect.fromLTWH(
              xPos + width / 2,
              yPos + height,
              pointerSize,
              pointerSize,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }

  Widget Point2() {
    return SizedBox(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
            Rect.fromLTWH(
              xPos + width / 2,
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

  Widget Point9() {
    return SizedBox(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
            Rect.fromLTWH(
              xPos + width,
              yPos + height,
              pointerSize,
              pointerSize,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }

  Widget Point7() {
    return SizedBox(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
            Rect.fromLTWH(
              xPos,
              yPos + height,
              pointerSize,
              pointerSize,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }

  Widget Point3() {
    return SizedBox(
      width: pointerSize,
      height: pointerSize,
      child: Center(
        child: CustomPaint(
          painter: CirclePointPainter(
            Rect.fromLTWH(
              xPos + width,
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

  Widget Point1() {
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

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class CirclePointPainter extends CustomPainter {
  CirclePointPainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(rect, Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
