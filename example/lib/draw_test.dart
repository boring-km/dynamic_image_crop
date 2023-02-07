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
  final width = 100.0;
  final height = 100.0;
  bool _dragging = false;
  final controlCircleRadius = 20.0;

  /// Is the point (x, y) inside the rect?
  bool _insideRect(double x, double y) =>
      x >= xPos && x <= xPos + width && y >= yPos && y <= yPos + height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _dragging = _insideRect(
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      onPanEnd: (details) {
        _dragging = false;
      },
      onPanUpdate: (details) {
        if (_dragging) {
          setState(() {
            xPos += details.delta.dx;
            yPos += details.delta.dy;
          });
        }
      },
      child: Stack(
        children: [
          Container(
            color: Colors.white,
            child: CustomPaint(
              painter: RectanglePainter(Rect.fromLTWH(xPos, yPos, width, height)),
              child: Container(),
            ),
          ),
          Positioned(
            left: xPos,
            top: yPos,
            width: controlCircleRadius,
            height: controlCircleRadius,
            child: GestureDetector(
              child: Center(
                child: CustomPaint(
                  painter: CirclePointPainter(xPos, yPos, controlCircleRadius),
                ),
              ),
            ),
          ),
        ],
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
  CirclePointPainter(this.x, this.y, this.radius);

  final double x;
  final double y;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
        Rect.fromLTWH(x, y, radius, radius), Paint()..color = Colors.orange);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
