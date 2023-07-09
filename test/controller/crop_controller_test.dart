import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/ui/drawing_view.dart';
import 'package:dynamic_image_crop/src/ui/figure_shape_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('CropController init test', () {
    final cropController = CropController();

    final painterKey = GlobalKey<FigureShapeViewState>();
    final drawingKey = GlobalKey<DrawingViewState>();

    final image = Uint8List(0);
    const imageFormat = ImageByteFormat.png;

    cropController.init(
      image: image,
      imageByteFormat: imageFormat,
      callback: (image, width, height) {},
      painterKey: painterKey,
      drawingKey: drawingKey,
    );

    expect(cropController.imageNotifier.image, image);
    expect(cropController.imageNotifier.imageByteFormat, imageFormat);
  });

  group('CropController tests', () {
    late final Uint8List image;
    late final CropController cropController;
    late final GlobalKey<FigureShapeViewState> painterKey;
    late final GlobalKey<DrawingViewState> drawingKey;
    late final ImageByteFormat imageByteFormat;

    setUp(() {
      image = File('test/assets/sample_image.png').readAsBytesSync();
      cropController = CropController();
      painterKey = GlobalKey<FigureShapeViewState>();
      drawingKey = GlobalKey<DrawingViewState>();
      imageByteFormat = ImageByteFormat.png;
    });

    test('CropController crop test', () async {

      final resultSize = Completer<Size>();

      cropController
        ..cropTypeNotifier.set(CropType.rectangle)
        ..painterSize = const Size(100, 100)
        ..init(
          image: image,
          imageByteFormat: imageByteFormat,
          callback: (image, width, height) {
            resultSize.complete(Size(width.toDouble(), height.toDouble()));
          },
          painterKey: painterKey,
          drawingKey: drawingKey,
        )
        ..cropImage();

      final result = await resultSize.future;
      print(result.width);
    });
  });
}
