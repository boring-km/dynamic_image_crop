import 'dart:io';

import 'package:dynamic_image_crop_example/screen/crop_screen.dart';
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SelectView(),
      ),
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
