import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageChangeNotifier with ChangeNotifier {
  Uint8List image = Uint8List(0);

  void set(Uint8List image) {
    this.image = image;
    notifyListeners();
  }
}
