import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageUtils {
  static ui.Size getPainterSize(BoxConstraints constraints) {
    return Size(
      constraints.maxWidth,
      constraints.maxHeight,
    );
  }

  static void getImageSize(
    Uint8List imageList,
    void Function(double, double) callback,
  ) {
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
