import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class ImageChangeNotifier with ChangeNotifier {
  Uint8List _image = Uint8List(0);
  Uint8List get image => _image;

  ui.ImageByteFormat _imageByteFormat = ui.ImageByteFormat.png;
  ui.ImageByteFormat get imageByteFormat => _imageByteFormat;

  void set(Uint8List image, {ui.ImageByteFormat? imageByteFormat}) {
    _image = image;
    _imageByteFormat = imageByteFormat ?? ui.ImageByteFormat.png;
    notifyListeners();
  }
}
