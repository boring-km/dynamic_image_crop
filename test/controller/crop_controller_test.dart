import 'dart:io';

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:dynamic_image_crop/src/dynamic_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_utils.dart';

void main() {
  testWidgets('change image test', (tester) async {
    final beforeImage = File('test/assets/sample_image.png');
    final afterImage = File('test/assets/sample_image_vertical.png');

    final cropController = CropController();
    final testWidget = MaterialApp(
      home: Center(
        child: DynamicImageCrop.fromFile(
          imageFile: beforeImage,
          controller: cropController,
          onResult: (image, width, height) { },
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    await waitAndPumpAndSettle(tester, Duration.zero);
    await waitAndPumpAndSettle(tester, Duration.zero);

    // when
    cropController.changeImage(afterImage.readAsBytesSync());

    // then
    expect(cropController.imageNotifier.image, afterImage.readAsBytesSync());
  });

  testWidgets('change imageFile test', (tester) async {
    final beforeImage = File('test/assets/sample_image.png');
    final afterImage = File('test/assets/sample_image_vertical.png');

    final cropController = CropController();
    final testWidget = MaterialApp(
      home: Center(
        child: DynamicImageCrop.fromFile(
          imageFile: beforeImage,
          controller: cropController,
          onResult: (image, width, height) { },
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    await waitAndPumpAndSettle(tester, Duration.zero);
    await waitAndPumpAndSettle(tester, Duration.zero);

    // when
    cropController.changeImageFile(afterImage);

    // then
    expect(cropController.imageNotifier.image, afterImage.readAsBytesSync());
  });

  testWidgets('clear Crop Area test', (tester) async {
    final imageFile = File('test/assets/sample_image.png');

    final cropController = CropController();
    final testWidget = MaterialApp(
      home: Center(
        child: DynamicImageCrop.fromFile(
          imageFile: imageFile,
          controller: cropController,
          onResult: (image, width, height) { },
        ),
      ),
    );
    await tester.pumpWidget(testWidget);
    await waitAndPumpAndSettle(tester, Duration.zero);
    await waitAndPumpAndSettle(tester, Duration.zero);

    // when
    cropController.clearCropArea();

    // then
    expect(cropController.cropTypeNotifier.value, CropType.none);
  });


  group('change CropType tests', () {
    final file = File('test/assets/sample_image.png'); // 1920 x 880

    testWidgets('change CropType from none to circle', (tester) async {
      final cropController = CropController();
      const expectedCropType = CropType.circle;

      final testWidget = MaterialApp(
        home: Center(
          child: DynamicImageCrop.fromFile(
            imageFile: file,
            controller: cropController,
            onResult: (image, width, height) { },
          ),
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, Duration.zero);
      await waitAndPumpAndSettle(tester, Duration.zero);

      cropController.changeType(expectedCropType);

      expect(cropController.cropTypeNotifier.value, expectedCropType);
    });

    testWidgets('change CropType from none to rectangle', (tester) async {
      final cropController = CropController();
      const expectedCropType = CropType.rectangle;

      final testWidget = MaterialApp(
        home: Center(
          child: DynamicImageCrop.fromFile(
            imageFile: file,
            controller: cropController,
            onResult: (image, width, height) { },
          ),
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, Duration.zero);
      await waitAndPumpAndSettle(tester, Duration.zero);

      cropController.changeType(expectedCropType);

      expect(cropController.cropTypeNotifier.value, expectedCropType);
    });

    testWidgets('change CropType from none to triangle', (tester) async {
      final cropController = CropController();
      const expectedCropType = CropType.triangle;

      final testWidget = MaterialApp(
        home: Center(
          child: DynamicImageCrop.fromFile(
            imageFile: file,
            controller: cropController,
            onResult: (image, width, height) { },
          ),
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, Duration.zero);
      await waitAndPumpAndSettle(tester, Duration.zero);

      cropController.changeType(expectedCropType);

      expect(cropController.cropTypeNotifier.value, expectedCropType);
    });
  });
}
