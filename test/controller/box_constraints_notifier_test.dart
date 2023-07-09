import 'package:dynamic_image_crop/src/controller/box_constraints_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BoxConstraintsNotifier setConstraints', () {
    final boxConstraintsNotifier = BoxConstraintsNotifier();

    const boxConstraints = BoxConstraints(
      minWidth: 100,
      maxWidth: 1000,
      minHeight: 100,
      maxHeight: 1000,
    );
    boxConstraintsNotifier.setConstraints(boxConstraints);

    expect(boxConstraintsNotifier.constraints, boxConstraints);
  });
}
