import 'dart:io';

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:dynamic_image_crop/src/dynamic_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late File file;
  late CropController cropController;

  const defaultPhysicalSize = Size(1920, 880); // sample image size

  setUp(() {
    file = File('test/assets/sample_image.png'); // 1920 x 880
    cropController = CropController();
  });


  testWidgets('None CropType Crop From File has same size as image', (tester) async  {
    tester.view.physicalSize = defaultPhysicalSize;
    tester.view.devicePixelRatio = 1;

    cropController.cropTypeNotifier.value = CropType.none;

    final testWidget = MaterialApp(
      home: Center(
        child: DynamicImageCrop.fromFile(
          imageFile: file,
          controller: cropController,
          onResult: (image, width, height) {
            // expect same image as sample image
            expect(image, file.readAsBytesSync());
            expect(width, defaultPhysicalSize.width);
            expect(height, defaultPhysicalSize.height);
          },
        ),
      ),
    );
    await tester.pumpWidget(testWidget);

    await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

    cropController.cropImage();

    await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
  });
}
