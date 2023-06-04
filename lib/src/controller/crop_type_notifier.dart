import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:flutter/foundation.dart';

class CropTypeNotifier with ChangeNotifier {
  var _cropType = CropType.none;
  CropType get cropType => _cropType;
  
  void set(CropType cropType) {
    _cropType = cropType;
    notifyListeners();
  }
}
