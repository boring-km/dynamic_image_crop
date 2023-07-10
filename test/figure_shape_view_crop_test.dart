import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:dynamic_image_crop/src/dynamic_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FigureShapeView cropImage success test', () {
    late File file;
    late Uint8List image;
    late CropController cropController;

    const expectedCroppedWidth = 300;
    const expectedCroppedHeight = 300;
    const defaultPhysicalSize = Size(1920, 1000);

    setUp(() {
      file = File('test/assets/sample_image.png'); // 1920 x 880
      image = file.readAsBytesSync();
      cropController = CropController();
    });

    testWidgets('circle CropType success test', (tester) async {
      tester.view.physicalSize = defaultPhysicalSize;
      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedImageBytesLength = 81129;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            debugPrint(
                'image length: ${image.length}, width: $width, height: $height');
            expect(expectedImageBytesLength, image.length);
            expect(expectedCroppedWidth, width);
            expect(expectedCroppedHeight, height);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    });

    testWidgets('rectangle CropType success test', (tester) async {
      tester.view.physicalSize = defaultPhysicalSize;
      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedImageBytesLength = 98868;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            debugPrint(
                'image length: ${image.length}, width: $width, height: $height');
            expect(expectedImageBytesLength, image.length);
            expect(expectedCroppedWidth, width);
            expect(expectedCroppedHeight, height);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    });

    testWidgets('triangle CropType success test', (tester) async {
      tester.view.physicalSize = defaultPhysicalSize;
      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedImageBytesLength = 56144;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            debugPrint(
                'image length: ${image.length}, width: $width, height: $height');
            expect(expectedImageBytesLength, image.length);
            expect(expectedCroppedWidth, width);
            expect(expectedCroppedHeight, height);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    });
  });
}
