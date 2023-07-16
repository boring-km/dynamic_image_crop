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

  late File file;
  late Uint8List image;
  late CropController cropController;
  const expectedCroppedWidth = 100;
  const expectedCroppedHeight = 100;

  group('FigureShapeView Crop test on horizontal image', () {

    const defaultPhysicalSize = Size(1920, 880); // sample image size

    setUp(() {
      file = File('test/assets/sample_image.png'); // 1920 x 880
      image = file.readAsBytesSync();
      cropController = CropController();
    });

    testWidgets('circle CropType success test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedImageBytesLength = 4906;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(image.length, expectedImageBytesLength);
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
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
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedImageBytesLength = 3645;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(image.length, expectedImageBytesLength);
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
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
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedImageBytesLength = 5877;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(image.length, expectedImageBytesLength);
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
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

  group('FigureShapeView Crop test on vertical image', () {

    const defaultPhysicalSize = Size(920, 1143); // sample image size

    setUp(() {
      file = File('test/assets/sample_image_vertical.png'); // 920 x 1143
      image = file.readAsBytesSync();
      cropController = CropController();
    });

    testWidgets('circle CropType success test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedImageBytesLength = 1999;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(image.length, expectedImageBytesLength);
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
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
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedImageBytesLength = 1384;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(image.length, expectedImageBytesLength);
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
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
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedImageBytesLength = 733;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(image.length, expectedImageBytesLength);
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
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

  testWidgets('crop horizontal image in small screen', (tester) async {
    file = File('test/assets/sample_image.png'); // 1920 x 880
    image = file.readAsBytesSync();
    cropController = CropController();

    tester.view.physicalSize = const Size(1200, 400);
    tester.view.devicePixelRatio = 1;

    cropController.cropTypeNotifier.value = CropType.rectangle;
    const expectedImageBytesLength = 49393;
    const expectedCroppedWidth = 220;
    const expectedCroppedHeight = 220;

    final testWidget = MaterialApp(
      home: DynamicImageCrop(
        image: image,
        controller: cropController,
        onResult: (image, width, height) {
          expect(image.length, expectedImageBytesLength);
          expect(width, expectedCroppedWidth);
          expect(height, expectedCroppedHeight);
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

  testWidgets('crop vertical image in small screen', (tester) async {
    file = File('test/assets/sample_image_vertical.png'); // 920 x 1143
    image = file.readAsBytesSync();
    cropController = CropController();

    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;

    cropController.cropTypeNotifier.value = CropType.rectangle;
    const expectedImageBytesLength = 3005;
    const expectedCroppedWidth = 230;
    const expectedCroppedHeight = 230;

    final testWidget = MaterialApp(
      home: DynamicImageCrop(
        image: image,
        controller: cropController,
        onResult: (image, width, height) {
          expect(image.length, expectedImageBytesLength);
          expect(width, expectedCroppedWidth);
          expect(height, expectedCroppedHeight);
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
}
