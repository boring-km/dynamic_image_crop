import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dynamic_image_crop/src/controller/image_change_notifier.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('ImageChangeNotifier set test', () {
    final imageChangeNotifier = ImageChangeNotifier();

    final image = Uint8List(0);
    const imageByteFormat = ui.ImageByteFormat.png;
    imageChangeNotifier.set(image, imageByteFormat: imageByteFormat);

    expect(imageChangeNotifier.image, image);
    expect(imageChangeNotifier.imageByteFormat, imageByteFormat);
  });
}
