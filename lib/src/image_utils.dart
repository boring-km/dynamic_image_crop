import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageUtils {
  static ui.Size getPainterSize(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final deviceWidth = deviceSize.width;
    final deviceHeight = deviceSize.height;
    return Size(deviceWidth, deviceHeight);
  }

  static Future<void> getImageSize(
    Uint8List imageList,
    void Function(double, double) callback,
  ) async {
    ui.decodeImageFromList(imageList, (image) {
      callback(image.width.toDouble(), image.height.toDouble());
    });
  }

  static ui.Size getRatio(ui.Image image, Size painterSize) {
    return Size(
      image.width / painterSize.width,
      image.height / painterSize.height,
    );
  }
}
