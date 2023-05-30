import 'dart:io';

import 'package:dynamic_image_crop/crop_controller.dart';
import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop_example/result_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

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
  const SelectView({super.key});

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
          moveToCropScreen(file.readAsBytesSync());
        }
      }
    });
  }

  void pickImage() {
    if (kIsWeb) {
      // ImagePickerWeb.getImageAsBytes().then((value) {
      //   if (value != null) {
      //     moveToCropScreen(value);
      //   }
      // });
    } else {
      ImagePicker().pickImage(source: ImageSource.gallery).then((xFile) {
        if (xFile != null) {
          final file = File(xFile.path);
          if (file.existsSync()) {
            moveToCropScreen(file.readAsBytesSync());
          }
        }
      });
    }
  }

  void moveToCropScreen(Uint8List imageList) {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (_) => CropScreen(imageList),
      ),
    );
  }
}

class CropScreen extends StatefulWidget {
  const CropScreen(this.imageList, {super.key});

  final Uint8List imageList;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  ShapeType shapeType = ShapeType.none;
  late final imageList = widget.imageList;

  final controller = CropController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: '1',
            onPressed: controller.cropImage,
            label: const Text('Crop'),
          ),
          FloatingActionButton.extended(
            heroTag: '2',
            onPressed: () {
              changeShape(ShapeType.none);
            },
            label: const Text('Cancel'),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: DynamicImageCrop(
                controller: controller,
                imageList: imageList,
                cropResult: (image, width, height) {
                  sendResultImage(image, width, height, context);
                },
              ),
            ),
            const Center(),
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
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.rectangle);
          },
          child: const Text('Rect'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.circle);
          },
          child: const Text('Circle'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.triangle);
          },
          child: const Text('Triangle'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.drawing);
          },
          child: const Text('Drawing'),
        ),
      ],
    );
  }

  void changeShape(ShapeType type) {
    controller.changeType(type);
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
        MaterialPageRoute<dynamic>(
          builder: (_) => ResultScreen(
            image: bytes,
            width: shapeWidth,
            height: shapeHeight,
          ),
        ),
      );
    }
  }
}
