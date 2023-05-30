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
    ui.Image result;

    if (shapeType == ShapeType.drawing) {
      result = await getDrawingImage(
        crop: rect,
        image: decoded,
        area: area,
      );
    } else {
      result = await getCropImage(
        crop: rect,
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
    required Rect crop,
    required ui.Image image,
    required ShapeType shapeType,
    required CropArea area,
    double? maxSize,
    ui.FilterQuality quality = FilterQuality.high,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final cropWidth = crop.width * image.width;
    final cropHeight = crop.height * image.height;

    final cropCenter = Offset(
      image.width.toDouble() * crop.center.dx,
      image.height.toDouble() * crop.center.dy,
    );

    if (shapeType == ShapeType.rectangle) {
      RectanglePainterForCrop(
        Rect.fromLTWH(area.left, area.top, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else if (shapeType == ShapeType.circle) {
      CirclePainterForCrop(
        Rect.fromLTWH(area.left, area.top, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else if (shapeType == ShapeType.triangle) {
      TrianglePainterForCrop(
        Rect.fromLTWH(area.left, area.top, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else {
      throw Exception('Unknown shape type');
    }

    //FIXME Picture.toImage() crashes on Flutter Web with the HTML renderer. Use CanvasKit or avoid this operation for now. https://github.com/flutter/engine/pull/20750
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

    //FIXME Picture.toImage() crashes on Flutter Web with the HTML renderer. Use CanvasKit or avoid this operation for now. https://github.com/flutter/engine/pull/20750
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

  void changeType(ShapeType type) {
    shapeNotifier.set(type);
  }

  void set(double painterWidth, double painterHeight) {
    this.painterWidth = painterWidth;
    this.painterHeight = painterHeight;
  }
}
