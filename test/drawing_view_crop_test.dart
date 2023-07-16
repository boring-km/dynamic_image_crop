import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:dynamic_image_crop/src/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/src/ui/drawing_view.dart';
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

  group('Drawing Crop test on horizontal image', () {

    const defaultPhysicalSize = Size(1920, 880); // sample image size

    setUp(() {
      file = File('test/assets/sample_image.png'); // 1920 x 880
      image = file.readAsBytesSync();
      cropController = CropController();
    });

    testWidgets('Drawing CropType by drawing a square success test.', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.drawing;
      const expectedImageBytesLength = 6026;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(expectedImageBytesLength, image.length);
            expect(expectedCroppedWidth, width);
            expect(expectedCroppedHeight, height);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      // draw a line in the shape of a square
      final drawingView = find.byType(DrawingView);
      expect(drawingView, findsOneWidget);

      final center = tester.getCenter(drawingView);
      final topLeft = Offset(center.dx - 50, center.dy - 50);
      final topRight = Offset(center.dx + 50, center.dy - 50);
      final bottomRight = Offset(center.dx + 50, center.dy + 50);
      final bottomLeft = Offset(center.dx - 50, center.dy + 50);

      final gesture = await tester.startGesture(topLeft);
      await gesture.moveTo(topRight);
      await gesture.moveTo(bottomRight);
      await gesture.moveTo(bottomLeft);
      await gesture.up();

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    });

    testWidgets('Drawing CropType throws an RangeError if no lines are drawn.', (tester) async {
      cropController.cropTypeNotifier.value = CropType.drawing;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) { },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      try {
        cropController.cropImage();
        fail('Expected an RangeError to be thrown.');
      } catch (e) {
        expect(e, isA<RangeError>());
      }

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    });
  });

  group('Drawing Crop test on vertical image', () {

    const defaultPhysicalSize = Size(920, 1143); // sample image size

    setUp(() {
      file = File('test/assets/sample_image_vertical.png'); // 1920 x 880
      image = file.readAsBytesSync();
      cropController = CropController();
    });

    testWidgets('Drawing CropType by drawing a square success test.', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.drawing;
      const expectedImageBytesLength = 886;

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

      // draw a line in the shape of a square
      final drawingView = find.byType(DrawingView);
      expect(drawingView, findsOneWidget);

      final center = tester.getCenter(drawingView);
      final topLeft = Offset(center.dx - 50, center.dy - 50);
      final topRight = Offset(center.dx + 50, center.dy - 50);
      final bottomRight = Offset(center.dx + 50, center.dy + 50);
      final bottomLeft = Offset(center.dx - 50, center.dy + 50);

      final gesture = await tester.startGesture(topLeft);
      await gesture.moveTo(topRight);
      await gesture.moveTo(bottomRight);
      await gesture.moveTo(bottomLeft);
      await gesture.up();

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    });

    testWidgets('Drawing CropType throws an RangeError if no lines are drawn.', (tester) async {
      cropController.cropTypeNotifier.value = CropType.drawing;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) { },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));

      try {
        cropController.cropImage();
        fail('Expected an RangeError to be thrown.');
      } catch (e) {
        expect(e, isA<RangeError>());
      }

      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
      await waitAndPumpAndSettle(tester, const Duration(seconds: 1));
    });
  });
}
