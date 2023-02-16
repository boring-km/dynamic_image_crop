// ignore_for_file: non_constant_identifier_names

import 'package:dynamic_image_crop_example/screen/crop_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Custom Painter',
      home: CropScreen(),
    );
  }
}
