import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageChangeNotifier with ChangeNotifier {
  Uint8List image = Uint8List(0);
  ui.ImageByteFormat imageByteFormat = ui.ImageByteFormat.png;

  void set(Uint8List image, {ui.ImageByteFormat? imageByteFormat}) {
    this.image = image;
    this.imageByteFormat = imageByteFormat ?? ui.ImageByteFormat.png;
    notifyListeners();
  }
}
