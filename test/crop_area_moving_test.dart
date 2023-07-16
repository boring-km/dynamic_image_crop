import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:dynamic_image_crop/src/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/src/ui/figure_shape_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late File file;
  late Uint8List image;
  late CropController cropController;

  const defaultPhysicalSize = Size(1920, 880); // sample image size

  setUp(() {
    file = File('test/assets/sample_image.png'); // 1920 x 880
    image = file.readAsBytesSync();
    cropController = CropController();
  });

  testWidgets('rectangle area moving test', (tester) async {
    // set same screen size as sample image
    tester.view.physicalSize = defaultPhysicalSize;
    tester.view.devicePixelRatio = 1;

    cropController.cropTypeNotifier.value = CropType.rectangle;
    const expectedLength = 12053;
    const expectedCroppedWidth = 100;
    const expectedCroppedHeight = 100;

    final testWidget = MaterialApp(
      home: DynamicImageCrop(
        image: image,
        controller: cropController,
        onResult: (image, width, height) {
          expect(width, expectedCroppedWidth);
          expect(height, expectedCroppedHeight);
          expect(
            image.length,
            inInclusiveRange(expectedLength - 5, expectedLength + 5),
          );
        },
      ),
    );
    await tester.pumpWidget(testWidget);

    await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

    // drag crop area from Center
    final center = tester.getCenter(find.byType(FigureShapeView));
    await tester.dragFrom(
      center,
      const Offset(100, 100),
    ); // move to right and down by 100

    cropController.cropImage();

    await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
  });
}
