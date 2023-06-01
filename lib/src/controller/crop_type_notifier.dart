import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:flutter/foundation.dart';

class CropTypeNotifier with ChangeNotifier {
  CropType cropType = CropType.none;
  
  void set(CropType cropType) {
    this.cropType = cropType;
    notifyListeners();
  }
}
