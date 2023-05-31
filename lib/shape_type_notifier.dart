import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:flutter/foundation.dart';

class ShapeTypeNotifier with ChangeNotifier {
  ShapeType shapeType = ShapeType.none;
  
  void set(ShapeType shapeType) {
    this.shapeType = shapeType;
    notifyListeners();
  }
}
