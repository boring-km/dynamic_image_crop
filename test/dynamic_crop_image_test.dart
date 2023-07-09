import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:dynamic_image_crop/src/dynamic_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  late final Uint8List image;
  late final CropController cropController;
  // ignore: unused_local_variable
  late final ImageByteFormat imageByteFormat;
  late final Widget testWidget;

  setUp(() {
    image = File('test/assets/sample_image.png').readAsBytesSync();
    imageByteFormat = ImageByteFormat.png;
    cropController = CropController();

    testWidget = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: DynamicImageCrop(
            image: image,
            controller: cropController,
            onResult: (image, width, height) {},
          ),
        ),
      ),
    );
  });

  testWidgets('circle crop test', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget);

    cropController.cropTypeNotifier.set(CropType.circle);

    // TODO: test
  });
}
