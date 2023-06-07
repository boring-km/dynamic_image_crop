import 'package:flutter/material.dart';

class BoxConstraintsNotifier extends ChangeNotifier {
  BoxConstraints _constraints = const BoxConstraints();

  BoxConstraints get constraints => _constraints;

  void setConstraints(BoxConstraints constraints) {
    _constraints = constraints;
    notifyListeners();
  }
}
