import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/src/controller/crop_type_notifier.dart';
import 'package:dynamic_image_crop/src/controller/image_change_notifier.dart';
import 'package:dynamic_image_crop/src/crop/crop_area.dart';
import 'package:dynamic_image_crop/src/image_utils.dart';
import 'package:dynamic_image_crop/src/shape_painter/circle_painter.dart';
import 'package:dynamic_image_crop/src/shape_painter/drawing_painter.dart';
import 'package:dynamic_image_crop/src/shape_painter/rectangle_painter.dart';
import 'package:dynamic_image_crop/src/shape_painter/triangle_painter.dart';
import 'package:dynamic_image_crop/src/ui/drawing_view.dart';
import 'package:dynamic_image_crop/src/ui/figure_shape_view.dart';
import 'package:flutter/material.dart';

/// CropController is a controller for [DynamicImageCrop].
class CropController {

  /// The size of the visible painter.
  Size painterSize = Size.zero;

  final _cropTypeNotifier = CropTypeNotifier();
  CropTypeNotifier get cropTypeNotifier => _cropTypeNotifier;

  final _imageNotifier = ImageChangeNotifier();
  ImageChangeNotifier get imageNotifier => _imageNotifier;

  late void Function(Uint8List, int, int) _callback;
  late GlobalKey<FigureShapeViewState> _painterKey;
  late GlobalKey<DrawingViewState> _drawingKey;

  /// initialize the controller after [DynamicImageCrop] build.
  void init({
    required Uint8List image,
    required void Function(Uint8List, int, int) callback,
    required GlobalKey<FigureShapeViewState> painterKey,
    required GlobalKey<DrawingViewState> drawingKey,
  }) {
    imageNotifier.set(image);
    _callback = callback;
    _painterKey = painterKey;
    _drawingKey = drawingKey;
  }

  /// Crop the image as you can see on the screen.
  void cropImage() {
    final cropType = cropTypeNotifier.cropType;
    if (cropType == CropType.none) {
      _callback(
        imageNotifier.image,
        painterSize.width.floor(),
        painterSize.height.floor(),
      );
    } else {
      final area = cropType == CropType.drawing
          ? _drawingKey.currentState!.getDrawingArea()
          : _painterKey.currentState!.getPainterArea();
      _callbackToParentWidget(area, cropType);
    }
  }

  /// Change the image to crop without setState((){}).
  void changeImage(Uint8List image) {
    imageNotifier.set(image);
  }

  Future<void> _callbackToParentWidget(
    CropArea area,
    CropType cropType,
  ) async {
    final rect = _calculateCropArea(
      area: area,
      imageSize: painterSize,
    );

    final decoded = await decodeImageFromList(imageNotifier.image);

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final cropWidth = rect.width * decoded.width;
    final cropHeight = rect.height * decoded.height;

    final cropCenter = Offset(
      decoded.width.floorToDouble() * rect.center.dx, // 실제로 crop할 이미지의 width
      decoded.height.floorToDouble() * rect.center.dy, // 실제로 crop할 이미지의 height
    );

    ui.Image result;
    if (cropType == CropType.drawing) {
      result = await _getDrawingImage(
        crop: rect,
        cropCenter: cropCenter,
        image: decoded,
        area: area,
      );
      result = await _getCropImage(
        pictureRecorder: pictureRecorder,
        canvas: canvas,
        cropCenter: cropCenter,
        cropWidth: cropWidth,
        cropHeight: cropHeight,
        image: result,
        cropType: CropType.rectangle,
      );
      // callback to the parent widget
      _callback(
        await result
            .toByteData(format: ui.ImageByteFormat.png)
            .then((value) => value!.buffer.asUint8List()),
        result.width,
        result.height,
      );
    } else {
      result = await _getCropImage(
        pictureRecorder: pictureRecorder,
        canvas: canvas,
        cropCenter: cropCenter,
        cropWidth: cropWidth,
        cropHeight: cropHeight,
        image: decoded,
        cropType: cropType,
      );
      // callback to the parent widget
      _callback(
        await result
            .toByteData(format: ui.ImageByteFormat.png)
            .then((value) => value!.buffer.asUint8List()),
        result.width,
        result.height,
      );
    }
  }

  static Future<ui.Image> _getCropImage({
    required ui.PictureRecorder pictureRecorder,
    required ui.Canvas canvas,
    required Offset cropCenter,
    required double cropWidth,
    required double cropHeight,
    required ui.Image image,
    required CropType cropType,
  }) async {
    // CropType에 따라서 다른 Painter를 사용
    if (cropType == CropType.rectangle) {
      RectanglePainterForCrop(
        Rect.fromLTWH(0, 0, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else if (cropType == CropType.circle) {
      CirclePainterForCrop(
        Rect.fromLTWH(0, 0, cropWidth, cropHeight),
        cropCenter,
        image,
      ).paint(canvas, Size(cropWidth, cropHeight));
    } else if (cropType == CropType.triangle) {
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

  Future<ui.Image> _getDrawingImage({
    required ui.Rect crop,
    required Offset cropCenter,
    required ui.Image image,
    required CropArea area,
  }) {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final cropWidth = crop.width * image.width;
    final cropHeight = crop.height * image.height;

    DrawingCropPainter(
      _drawingKey.currentState!.points,
      _drawingKey.currentState!.first,
      cropCenter,
      image,
      ImageUtils.getRatio(image, painterSize),
      crop,
    ).paint(
      canvas,
      Size(cropWidth, cropHeight),
    );

    // html 렌더링을 사용하는 Web에서는 Picture.toImage()가 작동하지 않음
    return pictureRecorder.endRecording().toImage(image.width, image.height);
  }

  Rect _calculateCropArea({
    required CropArea area,
    required Size imageSize,
  }) {
    final height = area.height / imageSize.height;
    final width = area.width / imageSize.width;

    final fromLeft = area.left < 0 ? 0.0 : area.left / imageSize.width;
    final fromTop = area.top < 0 ? 0.0 : area.top / imageSize.height;

    return Rect.fromLTWH(fromLeft, fromTop, width, height);
  }

  /// Change Crop Type Without setState((){}).
  /// Changeable Crop Type: [CropType.rectangle], [CropType.circle], [CropType.triangle], [CropType.drawing], [CropType.none]
  /// if change CropType to [CropType.none], then remove the crop area.
  void changeType(CropType type) {
    cropTypeNotifier.set(type);
  }

  /// Clear Crop Area Without setState((){}).
  void clearCropArea() {
    cropTypeNotifier.set(CropType.none);
  }
}
