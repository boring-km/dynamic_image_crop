import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CircleWidget extends StatefulWidget {
  const CircleWidget({Key? key}) : super(key: key);

  @override
  State<CircleWidget> createState() => _CircleWidgetState();
}

class _CircleWidgetState extends State<CircleWidget> {
  ui.Image? image;
  bool isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final file = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (file != null) {
        image = await loadImage(await file.readAsBytes());
      }
    });
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageLoaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: image != null
          ? Center(
              child: CustomPaint(
                painter: CircleCropPainter(image!),
                size: const Size(
                  400,
                  400,
                ),
              ),
            )
          : Container(color: Colors.black),
    );
  }
}

class CircleCropPainter extends CustomPainter {
  CircleCropPainter(this.image);

  final ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    // Set up the clipping path as a circle
    var path = Path();
    path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: min(size.width, size.height) / 2));

    // Clip the canvas to the path
    canvas.clipPath(path);

    // Draw the image on the canvas
    canvas.drawImage(image, const Offset(0, 0), Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Circle Crop Painter',
      home: CircleWidget(),
    );
  }
}
