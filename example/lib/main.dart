import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dynamic_image_crop/crop_controller.dart';
import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop_example/result_screen.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectView(),
    );
  }
}

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: pickCamera, child: const Text('Camera')),
            ElevatedButton(onPressed: pickImage, child: const Text('Gallery')),
          ],
        ),
      ),
    );
  }

  void pickCamera() {
    imagePicker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        final file = File(xFile.path);
        if (file.existsSync()) {
          moveToCropScreen(file);
        }
      }
    });
  }

  void pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        final file = File(xFile.path);
        if (file.existsSync()) {
          moveToCropScreen(file);
        }
      }
    });
  }

  void moveToCropScreen(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CropScreen(file),
      ),
    );
  }
}

class CropScreen extends StatefulWidget {
  const CropScreen(this.resultFile, {super.key});

  final File resultFile;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  ShapeType shapeType = ShapeType.none;
  late final imageFile = widget.resultFile;

  final controller = CropController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.cropImage(context);
        }, label: const Text('crop'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DynamicImageCrop(
                  controller: controller,
                  imageFile: imageFile,
                  cropResult: (image, width, height) {
                    sendResultImage(image, width, height, context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            width: size.width,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0x66666666),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: buildButtons(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.rectangle);
          },
          child: const Text('Rect'),
        ),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.circle);
          },
          child: const Text('Circle'),
        ),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.triangle);
          },
          child: const Text('Triangle'),
        ),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.drawing);
          },
          child: const Text('Drawing'),
        ),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.none);
          },
          child: const Text('cancel'),
        ),
      ],
    );
  }

  void changeShape(ShapeType type) {
    setState(() {
      controller.changeType(ShapeType.none);
    });
    setState(() {
      controller.changeType(type);
    });
  }

  void sendResultImage(
    Uint8List? bytes,
    double shapeWidth,
    double shapeHeight,
    BuildContext context,
  ) {
    if (bytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
              image: bytes, width: shapeWidth, height: shapeHeight),
        ),
      );
    }
  }
}
