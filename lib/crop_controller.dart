import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dynamic_image_crop/painter/drawing_area.dart';
import 'package:dynamic_image_crop/painter/drawing_painter.dart';
import 'package:dynamic_image_crop/painter/figure_crop_painter.dart';
import 'package:dynamic_image_crop/shape_type_notifier.dart';
import 'package:dynamic_image_crop/shapes/circle_painter.dart';
import 'package:dynamic_image_crop/shapes/custom_shape.dart';
import 'package:dynamic_image_crop/shapes/rectangle_painter.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop/shapes/triangle_painter.dart';
import 'package:flutter/material.dart';

class CropController {
  double painterWidth = 0;
  double painterHeight = 0;

  final shapeNotifier = ShapeTypeNotifier();

  late Uint8List image;
  late void Function(Uint8List, double, double) callback;
  late GlobalKey<FigureCropPainterState> painterKey;
  late GlobalKey<CustomShapeState> drawingKey;

  void init({
    required Uint8List image,
    required void Function(Uint8List, double, double) callback,
    required GlobalKey<FigureCropPainterState> painterKey,
    required GlobalKey<CustomShapeState> drawingKey,
  }) {
    this.image = image;
    this.callback = callback;
    this.painterKey = painterKey;
    this.drawingKey = drawingKey;
  }

  void cropImage() {
    final shapeType = shapeNotifier.shapeType;
    if (shapeType == ShapeType.none) {
      callback(image, painterWidth, painterHeight);
    } else {
      final area = shapeType == ShapeType.drawing
          ? drawingKey.currentState!.getDrawingArea()
          : painterKey.currentState!.getPainterArea();
      callbackToParentWidget(area, shapeType);
    }
  }

  Future<void> callbackToParentWidget(
    CropArea area,
    ShapeType shapeType,
  ) async {
    final rect = calculateCropArea(
      area: area,
      imageSize: Size(painterWidth, painterHeight),
    );

    final decoded = await decodeImageFromList(image);

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final cropWidth = rect.width * decoded.width;
    final cropHeight = rect.height * decoded.height;

    final cropCenter = Offset(
      decoded.width.floorToDouble() * rect.center.dx, // 실제로 crop할 이미지의 width
      decoded.height.floorToDouble() * rect.center.dy, // 실제로 crop할 이미지의 height
    );

    ui.Image result;
    if (shapeType == ShapeType.drawing) {
      result = await getDrawingImage(
        crop: rect,
        image: decoded,
        area: area,
      );
    } else {
      result = await getCropImage(
        pictureRecorder: pictureRecorder,
        canvas: canvas,
        cropCenter: cropCenter,
        cropWidth: cropWidth,
        cropHeight: cropHeight,
        image: decoded,
        shapeType: shapeType,
        area: area,
      );
    }

    // callback to the parent widget
    callback(
      await result
          .toByteData(format: ui.ImageByteFormat.png)
          .then((value) => value!.buffer.asUint8List()),
      area.width,
      area.height,
    );
  }

  static Future<ui.Image> getCropImage({
    required ui.PictureRecorder pictureRecorder,
    required ui.Canvas canvas,
    required Offset cropCenter,
    required double cropWidth,
    required double cropHeight,
    required ui.Image image,
    required ShapeType shapeType,
    required CropArea area,
  }) async {
    // ShapeType에 따라서 다른 Painter를 사용
    if (shapeType == ShapeType.rectangle) {
      RectanglePainterForCrop(
        Rect.fromLTWH(0, 0, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else if (shapeType == ShapeType.circle) {
      CirclePainterForCrop(
        Rect.fromLTWH(0, 0, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else if (shapeType == ShapeType.triangle) {
      TrianglePainterForCrop(
        Rect.fromLTWH(0, 0, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else {
      throw Exception('Unknown shape type');
    }

    // html 렌더링을 사용하는 Web에서는 Picture.toImage()가 작동하지 않음
    return pictureRecorder
        .endRecording()
        .toImage(cropWidth.round(), cropHeight.round());
  }

  Future<ui.Image> getDrawingImage({
    required ui.Rect crop,
    required ui.Image image,
    required CropArea area,
  }) {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final cropWidth = crop.width * image.width;
    final cropHeight = crop.height * image.height;

    DrawingCropPainter(
      drawingKey.currentState!.points,
      drawingKey.currentState!.first,
      image,
      area.left,
      area.top,
    ).paint(
      canvas,
      Size(cropWidth, cropHeight),
    );

    // html 렌더링을 사용하는 Web에서는 Picture.toImage()가 작동하지 않음
    return pictureRecorder
        .endRecording()
        .toImage(cropWidth.round(), cropHeight.round());
  }

  Rect calculateCropArea({
    required CropArea area,
    required Size imageSize,
  }) {
    final height = area.height / imageSize.height;
    final width = area.width / imageSize.width;

    final fromLeft = area.left < 0 ? 0.0 : area.left / imageSize.width;
    final fromTop = area.top < 0 ? 0.0 : area.top / imageSize.height;

    return Rect.fromLTWH(fromLeft, fromTop, width, height);
  }

  ui.Size getRatio(ui.Image image, Size painterSize) {
    return Size(image.width / painterSize.width, image.height / painterSize.height);
  }

  void changeType(ShapeType type) {
    shapeNotifier.set(type);
  }

  void set(double painterWidth, double painterHeight) {
    this.painterWidth = painterWidth;
    this.painterHeight = painterHeight;
  }
}
