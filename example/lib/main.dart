import 'dart:io';

import 'package:dynamic_image_crop_example/screen/camera_view.dart';
import 'package:dynamic_image_crop_example/screen/crop_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

void main() {
  runApp(const CameraView());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: CameraView(),
      ),
    );
  }
}

class GalleryApp extends StatefulWidget {
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GalleryView(),
      ),
    );
  }
}

class GalleryView extends StatefulWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {

  late double deviceHeight;
  late double deviceWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final XFile? filePath = await ImagePicker().pickImage(source: ImageSource.gallery);
      var file = File(filePath!.path);
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    deviceWidth = size.width;
    deviceHeight = size.height;
    return Scaffold(backgroundColor: Colors.black, body: Container(),);
  }
}
