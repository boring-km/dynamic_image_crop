import 'dart:typed_data';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen(
      {Key? key,
      required this.image,
      required this.width,
      required this.height})
      : super(key: key);

  final Uint8List image;

  final double width;
  final double height;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Center(
        child: Image.memory(
          widget.image,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }
}
