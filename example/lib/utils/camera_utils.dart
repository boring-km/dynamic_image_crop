import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dynamic_image_crop_example/screen/crop_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:path_provider/path_provider.dart';

Future<void> takePicture(
  BuildContext context,
  double left,
  double realWidth,
  double deviceHeight,
  double deviceWidth,
  double aspectRatio,
  CameraController? cameraController,
) async {
  if (cameraController == null) return;
  final xFile = await cameraController.takePicture();
  final croppedImageBytes = await File(xFile.path ?? '').readAsBytes();
  final tempFile =
      await File('${(await getTemporaryDirectory()).path}/image.jpg').create();
  final resultFile = await tempFile.writeAsBytes(croppedImageBytes);

  var scale = aspectRatio / cameraController.value.aspectRatio;
  if (scale < 1) scale = 1 / scale;

  // 안보이게 잘린 영역의 절반
  final margin = (deviceWidth * scale - deviceWidth) / 2 + left;

  final area = calculateDefaultArea(
    imageWidth: realWidth.toInt(),
    imageHeight: deviceHeight.toInt(),
    viewWidth: deviceWidth * scale,
    viewHeight: deviceHeight * scale,
    aspectRatio: aspectRatio,
    left: margin,
  );

  var topMargin = deviceHeight * 0.06;
  double imageHeight = deviceHeight - topMargin * 2;
  double imageWidth = _getWidthFromHeight(imageHeight);

  while (imageWidth > deviceWidth * 0.75) {
    imageHeight *= 0.99;
    imageWidth = _getWidthFromHeight(imageHeight);
  }

  ImageCrop.cropImage(file: resultFile, area: area).then((file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CropScreen(file, imageWidth, imageHeight, topMargin),
      ),
    );
  });
}

double _getWidthFromHeight(double imageHeight) => imageHeight * (4 / 3);

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
