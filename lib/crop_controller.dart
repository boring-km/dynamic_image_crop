import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/camera_utils.dart';
import 'package:dynamic_image_crop/painter/drawing_painter.dart';
import 'package:dynamic_image_crop/painter/figure_crop_painter.dart';
import 'package:dynamic_image_crop/shapes/circle_painter.dart';
import 'package:dynamic_image_crop/shapes/custom_shape.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop/shapes/triangle_painter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:image_crop/image_crop.dart';

class CropController {
  double painterWidth = 0;

  double painterHeight = 0;

  late File imageFile;
  late ShapeType shapeType;
  late Function callback;
  late GlobalKey<FigureCropPainterState> painterKey;
  late GlobalKey<CustomShapeState> drawingKey;

  void init({
    required File imageFile,
    required ShapeType shapeType,
    required Function callback,
    required GlobalKey<FigureCropPainterState> painterKey,
    required GlobalKey<CustomShapeState> drawingKey,
  }) {
    this.imageFile = imageFile;
    this.shapeType = shapeType;
    this.callback = callback;
    this.painterKey = painterKey;
    this.drawingKey = drawingKey;
  }

  void cropImage(BuildContext context) {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    double xPos;
    double yPos;
    double shapeWidth;
    double shapeHeight;

    if (shapeType == ShapeType.none) {
      // 전체 이미지 사용

      callback(imageFile.readAsBytesSync(), painterWidth, painterHeight);
      return;
    } else if (shapeType == ShapeType.drawing) {
      // 직접 그리기
      final drawingArea = drawingKey.currentState!.getDrawingArea();
      xPos = drawingArea.left;
      yPos = drawingArea.top;
      shapeWidth = drawingArea.width;
      shapeHeight = drawingArea.height;
    } else {
      // 네모 동그라미 세모
      xPos = painterKey.currentState!.xPos;
      yPos = painterKey.currentState!.yPos;
      shapeWidth = painterKey.currentState!.shapeWidth;
      shapeHeight = painterKey.currentState!.shapeHeight;
    }

    final area = calculateCropArea(
      imageWidth: shapeWidth.floor(),
      imageHeight: shapeHeight.floor(),
      viewWidth: painterWidth,
      viewHeight: painterHeight,
      left: xPos,
      top: yPos,
    );

    ImageCrop.cropImage(file: imageFile, area: area).then((file) {
      if (shapeType == ShapeType.rectangle) {
        callback(file.readAsBytesSync(), shapeWidth, shapeHeight);
      } else {
        loadImage(file.readAsBytesSync(), shapeWidth, shapeHeight)
            .then((image) {
          final width = image.width.toDouble();
          final height = image.height.toDouble();
          if (shapeType == ShapeType.circle) {
            CirclePainterForCrop(
              Rect.fromLTWH(0, 0, width, height),
              image,
            ).paint(
              canvas,
              Size(width, height),
            );
          } else if (shapeType == ShapeType.triangle) {
            TrianglePainterForCrop(
              Rect.fromLTWH(0, 0, width, height),
              image,
            ).paint(
              canvas,
              Size(width, height),
            );
          } else if (shapeType == ShapeType.drawing) {
            DrawingCropPainter(
              drawingKey.currentState!.points,
              drawingKey.currentState!.first,
              image,
              xPos,
              yPos,
            ).paint(
              canvas,
              Size(width, height),
            );
          }
          sendResult(recorder, context, width, height);
        });
      }
    });
  }

  void sendResult(
      ui.PictureRecorder recorder,
      BuildContext context,
      double shapeWidth,
      double shapeHeight,
      ) {
    final rendered = recorder
        .endRecording()
        .toImageSync(shapeWidth.floor(), shapeHeight.floor());

    rendered.toByteData(format: ui.ImageByteFormat.png).then((bytes) {
      callback(
        bytes!.buffer.asUint8List(),
        shapeWidth,
        shapeHeight,
      );
    });
  }

  Future<ui.Image> loadImage(
    Uint8List img,
    double targetWidth,
    double targetHeight,
  ) async {
    final codec = await ui.instantiateImageCodec(
      img,
      targetWidth: targetWidth.toInt(),
      targetHeight: targetHeight.toInt(),
    );
    return (await codec.getNextFrame()).image;
  }

  void set(double painterWidth, double painterHeight) {
    this.painterWidth = painterWidth;
    this.painterHeight = painterHeight;
  }

  void changeType(ShapeType type) {
    shapeType = type;
  }
}
