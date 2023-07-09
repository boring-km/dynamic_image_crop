import 'package:dynamic_image_crop/src/controller/crop_type_notifier.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // CropTypeNotifier test
  test('CropTypeNotifier set CropType test', () {
    final cropTypeNotifier = CropTypeNotifier();
    const noneCropType = CropType.none;

    cropTypeNotifier.set(noneCropType);

    expect(cropTypeNotifier.cropType, noneCropType);
  });
}
