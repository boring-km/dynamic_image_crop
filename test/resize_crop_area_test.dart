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

  group('resize rectangle crop area test by 8 ways', () {
    testWidgets('expand crop area to left and top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 39034;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to left and top by 50 from Center
      final leftAndTopMovePointer = center + const Offset(-50, -50);
      // move to left and top by 100
      await tester.dragFrom(leftAndTopMovePointer, const Offset(-100, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 12870;

      const expectedCroppedWidth = 100;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to top by 50 from Center
      final topMovePointer = center + const Offset(0, -50);
      // expand crop area to top by 100
      await tester.dragFrom(topMovePointer, const Offset(0, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to right and top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 28980;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to right and top by 50 from Center
      final rightAndTopMovePointer = center + const Offset(50, -50);
      // move to right and top by 100
      await tester.dragFrom(rightAndTopMovePointer, const Offset(100, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to left test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 20489;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 100;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to left by 50 from Center
      final leftMovePointer = center + const Offset(-50, 0);
      // expand crop area to left by 100
      await tester.dragFrom(leftMovePointer, const Offset(-100, 0));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to right test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 12972;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 100;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to right by 50 from Center
      final rightMovePointer = center + const Offset(50, 0);
      // expand crop area to right by 100
      await tester.dragFrom(rightMovePointer, const Offset(100, 0));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom and left test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 51265;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom and left by 50 from Center
      final leftAndBottomMovePointer = center + const Offset(-50, 50);
      // move to bottom and left by 100
      await tester.dragFrom(leftAndBottomMovePointer, const Offset(-100, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 19989;

      const expectedCroppedWidth = 100;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom by 50 from Center
      final bottomMovePointer = center + const Offset(0, 50);
      // expand crop area to bottom by 100
      await tester.dragFrom(bottomMovePointer, const Offset(0, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom and right test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.rectangle;
      const expectedLength = 38733;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom and right by 50 from Center
      final rightAndBottomMovePointer = center + const Offset(50, 50);
      // move to bottom and right by 100
      await tester.dragFrom(rightAndBottomMovePointer, const Offset(100, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });
  });

  group('resize circle crop area test by 8 ways', () {
    testWidgets('expand crop area to left and top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 35273;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to left and top by 50 from Center
      final leftAndTopMovePointer = center + const Offset(-50, -50);
      // move to left and top by 100
      await tester.dragFrom(leftAndTopMovePointer, const Offset(-100, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 10625;

      const expectedCroppedWidth = 100;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to top by 50 from Center
      final topMovePointer = center + const Offset(0, -50);
      // expand crop area to top by 100
      await tester.dragFrom(topMovePointer, const Offset(0, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to right and top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 23278;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to right and top by 50 from Center
      final rightAndTopMovePointer = center + const Offset(50, -50);
      // move to right and top by 100
      await tester.dragFrom(rightAndTopMovePointer, const Offset(100, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to left test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 18087;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 100;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to left by 50 from Center
      final leftMovePointer = center + const Offset(-50, 0);
      // expand crop area to left by 100
      await tester.dragFrom(leftMovePointer, const Offset(-100, 0));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to right test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 11446;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 100;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to right by 50 from Center
      final rightMovePointer = center + const Offset(50, 0);
      // expand crop area to right by 100
      await tester.dragFrom(rightMovePointer, const Offset(100, 0));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom and left test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 42734;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom and left by 50 from Center
      final leftAndBottomMovePointer = center + const Offset(-50, 50);
      // move to bottom and left by 100
      await tester.dragFrom(leftAndBottomMovePointer, const Offset(-100, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 16457;

      const expectedCroppedWidth = 100;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom by 50 from Center
      final bottomMovePointer = center + const Offset(0, 50);
      // expand crop area to bottom by 100
      await tester.dragFrom(bottomMovePointer, const Offset(0, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom and right test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.circle;
      const expectedLength = 32771;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom and right by 50 from Center
      final rightAndBottomMovePointer = center + const Offset(50, 50);
      // move to bottom and right by 100
      await tester.dragFrom(rightAndBottomMovePointer, const Offset(100, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });
  });

  group('resize triangle crop area test by 8 ways', () {
    testWidgets('expand crop area to left and top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 25774;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to left and top by 50 from Center
      final leftAndTopMovePointer = center + const Offset(-50, -50);
      // move to left and top by 100
      await tester.dragFrom(leftAndTopMovePointer, const Offset(-100, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 6636;

      const expectedCroppedWidth = 100;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to top by 50 from Center
      final topMovePointer = center + const Offset(0, -50);
      // expand crop area to top by 100
      await tester.dragFrom(topMovePointer, const Offset(0, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to right and top test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 13884;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to right and top by 50 from Center
      final rightAndTopMovePointer = center + const Offset(50, -50);
      // move to right and top by 100
      await tester.dragFrom(rightAndTopMovePointer, const Offset(100, -100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to left test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 12460;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 100;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to left by 50 from Center
      final leftMovePointer = center + const Offset(-50, 0);
      // expand crop area to left by 100
      await tester.dragFrom(leftMovePointer, const Offset(-100, 0));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to right test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 7524;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 100;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to right by 50 from Center
      final rightMovePointer = center + const Offset(50, 0);
      // expand crop area to right by 100
      await tester.dragFrom(rightMovePointer, const Offset(100, 0));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom and left test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 33726;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom and left by 50 from Center
      final leftAndBottomMovePointer = center + const Offset(-50, 50);
      // move to bottom and left by 100
      await tester.dragFrom(leftAndBottomMovePointer, const Offset(-100, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 13323;

      const expectedCroppedWidth = 100;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom by 50 from Center
      final bottomMovePointer = center + const Offset(0, 50);
      // expand crop area to bottom by 100
      await tester.dragFrom(bottomMovePointer, const Offset(0, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });

    testWidgets('expand crop area to bottom and right test', (tester) async {
      // set same screen size as sample image
      tester.view.physicalSize = defaultPhysicalSize;
      tester.view.devicePixelRatio = 1;

      cropController.cropTypeNotifier.value = CropType.triangle;
      const expectedLength = 25054;

      const expectedCroppedWidth = 200;
      const expectedCroppedHeight = 200;

      final testWidget = MaterialApp(
        home: DynamicImageCrop(
          image: image,
          controller: cropController,
          onResult: (image, width, height) {
            expect(
              image.length,
              inInclusiveRange(expectedLength - 5, expectedLength + 5),
            );
            expect(width, expectedCroppedWidth);
            expect(height, expectedCroppedHeight);
          },
        ),
      );
      await tester.pumpWidget(testWidget);

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));

      // drag crop area from Center
      final center = tester.getCenter(find.byType(FigureShapeView));
      // add to bottom and right by 50 from Center
      final rightAndBottomMovePointer = center + const Offset(50, 50);
      // move to bottom and right by 100
      await tester.dragFrom(rightAndBottomMovePointer, const Offset(100, 100));

      cropController.cropImage();

      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
      await waitAndPumpAndSettle(tester, const Duration(milliseconds: 300));
    });
  });
}
