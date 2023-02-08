import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ResizableCircle Painter',
      home: Scaffold(
        body: ResizableCircle(),
      ),
    );
  }
}

class ResizableCircle extends StatefulWidget {
  const ResizableCircle({super.key});

  @override
  State<ResizableCircle> createState() => _ResizableCircleState();
}

class _ResizableCircleState extends State<ResizableCircle> {
  double _radius = 50.0;

  void increaseRadius() {
    setState(() {
      _radius += 10.0;
    });
  }

  void decreaseRadius() {
    setState(() {
      _radius -= 10.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: _radius * 2,
            height: _radius * 2,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.remove),
              color: Colors.black,
              onPressed: decreaseRadius,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.black,
              onPressed: increaseRadius,
            ),
          ),
        ),
      ],
    );
  }
}
