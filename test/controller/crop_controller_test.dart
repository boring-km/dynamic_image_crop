import 'dart:io';
import 'dart:ui';

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final cropController = CropController();

  test('change image test', () {
    final first = File('test/assets/sample_image.png');
    final second = File('test/assets/sample_image_vertical.png');

    cropController.init(
      image: first.readAsBytesSync(),
      imageByteFormat: ImageByteFormat.png,
      callback: (image, width, height) {},
      painterKey: GlobalKey(),
      drawingKey: GlobalKey(),
    );

    expect(first.readAsBytesSync(), cropController.imageNotifier.image);

    cropController.changeImage(second.readAsBytesSync());

    expect(second.readAsBytesSync(), cropController.imageNotifier.image);
  });

  test('change CropType from circle to rectangle', () {
    cropController.cropTypeNotifier.value = CropType.circle;

    cropController.changeType(CropType.rectangle);

    expect(cropController.cropTypeNotifier.value, CropType.rectangle);
  });

  test('clear Crop Area test', () {
    cropController.cropTypeNotifier.value = CropType.circle;

    cropController.clearCropArea();

    expect(cropController.cropTypeNotifier.value, CropType.none);
  });
}
