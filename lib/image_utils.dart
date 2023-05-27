import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageUtils {
  static (double, double) getDeviceSize(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final deviceWidth = deviceSize.width.toDouble();
    final deviceHeight = deviceSize.height.toDouble();
    return (deviceWidth, deviceHeight);
  }

  static Future<void> getImageSize(File originalFile, Function(double, double) callback) async {
    final bytes = await _getImageBytes(originalFile);
    final values = bytes.buffer.asUint8List();

    ui.decodeImageFromList(values, (image) {
      callback(image.width.toDouble(), image.height.toDouble());
    });
  }

  static Future<Uint8List> _getImageBytes(File file) async {
    // ignore: avoid_slow_async_io
    if (await file.exists()) {
      return await file.readAsBytes();
    } else {
      return Uint8List(0);
    }
  }
}
