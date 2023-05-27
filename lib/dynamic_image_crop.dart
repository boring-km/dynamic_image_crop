import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/camera_utils.dart';
import 'package:dynamic_image_crop/image_utils.dart';
import 'package:dynamic_image_crop/painter/drawing_painter.dart';
import 'package:dynamic_image_crop/painter/figure_crop_painter.dart';
import 'package:dynamic_image_crop/shapes/circle_painter.dart';
import 'package:dynamic_image_crop/shapes/custom_shape.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop/shapes/triangle_painter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:image_crop/image_crop.dart';

class DynamicImageCrop extends StatefulWidget {
  const DynamicImageCrop({
    required this.imageFile,
    required this.cropResult,
    this.shapeType = ShapeType.none,
    Key? key,
  }) : super(key: key);

  final File imageFile;
  final Function(Uint8List image, double width, double height) cropResult;
  final ShapeType shapeType;

  @override
  State<DynamicImageCrop> createState() => _DynamicImageCropState();
}

class _DynamicImageCropState extends State<DynamicImageCrop> {
  late final imageFile = widget.imageFile;
  late final shapeType = widget.shapeType;
  late final callback = widget.cropResult;

  double painterWidth = 0;
  double painterHeight = 0;

  ui.Image? uiImage;

  double dx = 0;
  double dy = 0;
  double cropWidth = 0;
  double cropHeight = 0;
  double topMargin = 0;
  double startMargin = 0;

  final painterKey = GlobalKey<FigureCropPainterState>();
  final customDrawingKey = GlobalKey<CustomShapeState>();

  @override
  void initState() {
    Future.microtask(() {
      getImageFromFile(imageFile);
    });
    super.initState();
  }

  void getImageFromFile(File file) async {
    final (deviceWidth, deviceHeight) = ImageUtils.getDeviceSize(context);
    ImageUtils.getImageSize(file, (imageWidth, imageHeight) {
      final isImageWidthLonger = imageWidth > imageHeight;

      debugPrint('image width: $imageWidth, height: $imageHeight');
      if (isImageWidthLonger) {
        // 이미지의 가로 길이가 세로 길이보다 크면
        var ratio = deviceWidth / imageWidth;
        painterWidth = deviceWidth; // 너비는 가로 길이 전체를 사용
        painterHeight = imageHeight * ratio; // 높이는 세로 길이를 화면 크기에 맞춰서 늘리거나 축소

        if (painterHeight > deviceHeight) {
          // 세로 길이가 너무 길어서 화면 높이보다 길게 나온다면?
          ratio = deviceHeight / painterHeight;
          painterHeight = deviceHeight;
          painterWidth = painterWidth * ratio;
        }

        startMargin = (deviceWidth - painterWidth) / 2;
        topMargin = (deviceHeight - painterHeight) / 2;

        debugPrint('crop screen'
            'width: $painterWidth, '
            'height: $painterHeight, '
            'startMargin: $startMargin, '
            'topMargin: $topMargin');
        getImage();
      } else {
        // 이미지의 세로 길이가 가로 길이보다 크면
        var ratio = deviceHeight / imageHeight;
        painterHeight = deviceHeight;
        painterWidth = imageWidth * ratio;

        if (painterWidth > deviceWidth) {
          ratio = deviceWidth / painterWidth;
          painterWidth = deviceWidth;
          painterHeight = painterHeight * ratio;
        }

        startMargin = (deviceWidth - painterWidth) / 2;
        topMargin = (deviceHeight - painterHeight) / 2;
        debugPrint('crop screen'
            'width: $painterWidth, '
            'height: $painterHeight, '
            'startMargin: $startMargin, '
            'topMargin: $topMargin');
        getImage();
      }
    });
  }

  void getImage() {
    imageFile.readAsBytes().then((imageBytes) {
      loadImage(imageBytes, painterWidth, painterHeight).then((result) {
        setState(() {
          uiImage = result;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (shapeType == ShapeType.none) {
      return Image.file(
        imageFile,
        width: painterWidth,
        height: painterHeight,
        fit: BoxFit.cover,
      );
    } else if (uiImage != null && shapeType != ShapeType.custom) {
      return FigureCropPainter(
        painterWidth: painterWidth,
        painterHeight: painterHeight,
        uiImage: uiImage!,
        shapeType: shapeType,
        key: painterKey,
        startMargin: startMargin,
        topMargin: topMargin,
      );
    } else if (uiImage != null && shapeType == ShapeType.custom) {
      return Container(
        color: Colors.transparent,
        width: painterWidth,
        height: painterHeight,
        child: CustomShape(
          uiImage!,
          key: customDrawingKey,
        ),
      );
    } else {
      return Container();
    }
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
    } else if (shapeType == ShapeType.custom) {
      // 직접 그리기
      final drawingArea = customDrawingKey.currentState!.getDrawingArea();
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
          } else if (shapeType == ShapeType.custom) {
            DrawingCropPainter(
              customDrawingKey.currentState!.points,
              customDrawingKey.currentState!.first,
              image,
              xPos,
              yPos,
            ).paint(
              canvas,
              Size(width, height),
            );
          }
          // sendImageToResultScreen(recorder, context, width, height);
        });
      }
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
}
