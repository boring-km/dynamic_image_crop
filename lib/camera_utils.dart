import 'package:flutter/material.dart';

Rect calculateDefaultArea({
  required int imageWidth,
  required int imageHeight,
  required double viewWidth,
  required double viewHeight,
  required double aspectRatio,
  required double left,
  double top = 0.0,
}) {
  double height;
  double width;
  if (aspectRatio < 1) {
    height = 1.0;
    width = (aspectRatio * imageHeight * viewHeight * height) /
        imageWidth /
        viewWidth;
    if (width > 1.0) {
      width = 1.0;
      height = (imageWidth * viewWidth * width) /
          (imageHeight * viewHeight * aspectRatio);
    }
  } else {
    width = 1.0;
    height = (imageWidth * viewWidth * width) /
        (imageHeight * viewHeight * aspectRatio);
    if (height > 1.0) {
      height = 1.0;
      width = (aspectRatio * imageHeight * viewHeight * height) /
          imageWidth /
          viewWidth;
    }
  }
  double fromLeft = left < 0 ? 0 : left / viewWidth;
  double fromTop = top < 0 ? 0 : top / viewHeight;

  return Rect.fromLTWH(fromLeft, fromTop, width, height);
}

Rect calculateCropArea({
  required int? imageWidth,
  required int? imageHeight,
  required double viewWidth,
  required double viewHeight,
  required double left,
  double top = 0.0,
}) {
  if (imageWidth == null || imageHeight == null) {
    return Rect.zero;
  }
  double height = imageHeight / viewHeight;
  double width = imageWidth / viewWidth;

  final fromLeft = left < 0 ? 0.0 : left / viewWidth;
  final fromTop = top < 0 ? 0.0 : top / viewHeight;

  return Rect.fromLTWH(fromLeft, fromTop, width, height);
}
