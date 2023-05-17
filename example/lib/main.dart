import 'dart:io';

import 'package:dynamic_image_crop_example/screen/crop_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

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
  late double deviceHeight;
  late double deviceWidth;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    deviceWidth = size.width;
    deviceHeight = size.height;
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
    ImagePicker().pickImage(source: ImageSource.camera).then((filePath) {
      if (filePath == null) return;
      var file = File(filePath.path);
      final size = ImageSizeGetter.getSize(FileInput(file));

      var topMargin = deviceHeight * 0.06;
      final imageHeight = deviceHeight - topMargin * 2;
      final ratio = imageHeight / size.height;
      final imageWidth = size.width * ratio;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CropScreen(file, imageWidth, imageHeight, topMargin),
        ),
      );
    });
  }

  void pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((filePath) {
      if (filePath == null) return;
      var file = File(filePath.path);
      final size = ImageSizeGetter.getSize(FileInput(file));

      var topMargin = deviceHeight * 0.06;
      final imageHeight = deviceHeight - topMargin * 2;
      final ratio = imageHeight / size.height;
      final imageWidth = size.width * ratio;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CropScreen(file, imageWidth, imageHeight, topMargin),
        ),
      );
    });
  }
}
