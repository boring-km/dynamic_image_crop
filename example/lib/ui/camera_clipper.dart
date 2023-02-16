import 'package:flutter/material.dart';

class CameraClipper extends CustomClipper<Rect> {
  CameraClipper(this.cameraRealWidth);

  final double cameraRealWidth;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, cameraRealWidth, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;


}