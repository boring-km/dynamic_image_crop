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
    imagePicker.pickImage(source: ImageSource.camera).then((file) {
      if (file != null) getImageFromCamera(file);
    });
  }

  void pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((file) {
      if (file != null) getImageFromGallery(file);
    });
  }

  void getImageFromCamera(XFile xFile) {
    final deviceSize = MediaQuery.of(context).size;
    debugPrint('${deviceSize.width} x ${deviceSize.height}');
    final deviceWidth = deviceSize.width.toDouble();
    final deviceHeight = deviceSize.height.toDouble();
    final isDeviceWidthLonger = deviceWidth > deviceHeight;

    final file = File(xFile.path);
    final imageSize = ImageSizeGetter.getSize(FileInput(file));
    final needRotate = imageSize.needRotate;
    final imageWidth =
        (needRotate ? imageSize.height : imageSize.width).toDouble();
    final imageHeight =
        (needRotate ? imageSize.width : imageSize.height).toDouble();

    processByWidth(
      isDeviceWidthLonger,
      deviceWidth,
      imageWidth,
      imageHeight,
      file,
      deviceHeight,
    );
  }

  void getImageFromGallery(XFile xFile) {
    final deviceSize = MediaQuery.of(context).size;
    final deviceWidth = deviceSize.width.toDouble();
    final deviceHeight = deviceSize.height.toDouble();

    final file = File(xFile.path);
    final imageSize = ImageSizeGetter.getSize(FileInput(file));
    final needRotate = imageSize.needRotate;
    final imageWidth =
        (needRotate ? imageSize.height : imageSize.width).toDouble();
    final imageHeight =
        (needRotate ? imageSize.width : imageSize.height).toDouble();
    final isImageWidthLonger = imageWidth > imageHeight;

    processByWidth(
      isImageWidthLonger,
      deviceWidth,
      imageWidth,
      imageHeight,
      file,
      deviceHeight,
    );
  }

  void processByWidth(
    bool isWidthLonger,
    double deviceWidth,
    double imageWidth,
    double imageHeight,
    File file,
    double deviceHeight,
  ) {
    debugPrint('image width: $imageWidth, height: $imageHeight');
    if (isWidthLonger) {
      // 이미지의 가로 길이가 세로 길이보다 크면
      var ratio = deviceWidth / imageWidth;
      var targetImageWidth = deviceWidth; // 너비는 가로 길이 전체를 사용
      var targetImageHeight =
          imageHeight * ratio; // 높이는 세로 길이를 화면 크기에 맞춰서 늘리거나 축소

      if (targetImageHeight > deviceHeight) {
        // 세로 길이가 너무 길어서 화면 높이보다 길게 나온다면?
        ratio = deviceHeight / targetImageHeight;
        targetImageHeight = deviceHeight;
        targetImageWidth = targetImageWidth * ratio;
      }

      final startMargin = (deviceWidth - targetImageWidth) / 2;
      final topMargin = (deviceHeight - targetImageHeight) / 2;

      moveToCropScreen(
        file,
        targetImageWidth,
        targetImageHeight,
        startMargin: startMargin,
        topMargin: topMargin,
      );
    } else {
      // 이미지의 세로 길이가 가로 길이보다 크면
      var ratio = deviceHeight / imageHeight;
      var targetImageHeight = deviceHeight;
      var targetImageWidth = imageWidth * ratio;

      if (targetImageWidth > deviceWidth) {
        ratio = deviceWidth / targetImageWidth;
        targetImageWidth = deviceWidth;
        targetImageHeight = targetImageHeight * ratio;
      }

      final startMargin = (deviceWidth - targetImageWidth) / 2;
      final topMargin = (deviceHeight - targetImageHeight) / 2;

      moveToCropScreen(
        file,
        targetImageWidth,
        targetImageHeight,
        startMargin: startMargin,
        topMargin: topMargin,
      );
    }
  }

  void moveToCropScreen(
    File file,
    double targetImageWidth,
    double targetImageHeight, {
    double? startMargin,
    double? topMargin,
  }) {
    debugPrint('changed width: $targetImageWidth, height: $targetImageHeight');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CropScreen(
          file,
          targetImageWidth,
          targetImageHeight,
          startMargin: startMargin,
          topMargin: topMargin,
        ),
      ),
    );
  }
}
