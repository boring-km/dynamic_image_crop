import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/crop_controller.dart';
import 'package:dynamic_image_crop/image_utils.dart';
import 'package:dynamic_image_crop/painter/figure_crop_painter.dart';
import 'package:dynamic_image_crop/shapes/custom_shape.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DynamicImageCrop extends StatefulWidget {
  const DynamicImageCrop({
    required this.imageFile,
    required this.controller,
    required this.cropResult,
    Key? key,
  }) : super(key: key);

  final File imageFile;
  final CropController controller;
  final Function(Uint8List image, double width, double height) cropResult;

  @override
  State<DynamicImageCrop> createState() => _DynamicImageCropState();
}

class _DynamicImageCropState extends State<DynamicImageCrop> {
  late final imageFile = widget.imageFile;
  late final callback = widget.cropResult;
  late final controller = widget.controller;

  double painterWidth = 0;
  double painterHeight = 0;

  ui.Image? uiImage;

  double topMargin = 0;
  double startMargin = 0;

  final painterKey = GlobalKey<FigureCropPainterState>();
  final drawingKey = GlobalKey<CustomShapeState>();

  @override
  void initState() {
    controller.init(
      imageFile: imageFile,
      shapeType: ShapeType.none,
      callback: callback,
      painterKey: painterKey,
      drawingKey: drawingKey,
    );
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

        debugPrint('crop screen '
            'width: $painterWidth, '
            'height: $painterHeight, '
            'startMargin: $startMargin, '
            'topMargin: $topMargin');
        loadImage();
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
        debugPrint('crop screen '
            'width: $painterWidth, '
            'height: $painterHeight, '
            'startMargin: $startMargin, '
            'topMargin: $topMargin');
        loadImage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller.shapeType == ShapeType.none) {
      return backgroundImage();
    } else if (uiImage != null && controller.shapeType != ShapeType.drawing) {
      return Stack(
        children: [
          backgroundImage(),
          FigureCropPainter(
            painterWidth: painterWidth,
            painterHeight: painterHeight,
            uiImage: uiImage!,
            shapeType: controller.shapeType,
            key: painterKey,
            startMargin: startMargin,
            topMargin: topMargin,
          ),
        ],
      );
    } else if (uiImage != null && controller.shapeType == ShapeType.drawing) {
      return Stack(
        children: [
          backgroundImage(),
          Container(
            color: Colors.transparent,
            width: painterWidth,
            height: painterHeight,
            child: CustomShape(
              uiImage!,
              top: topMargin,
              left: startMargin,
              painterWidth: painterWidth,
              painterHeight: painterHeight,
              key: drawingKey,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Image backgroundImage() {
    return Image.file(
          imageFile,
          width: painterWidth,
          height: painterHeight,
          fit: BoxFit.cover,
        );
  }

  Future<void> loadImage() async {
    imageFile.readAsBytes().then((imageBytes) async {
      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: painterWidth.toInt(),
        targetHeight: painterHeight.toInt(),
      );
      final result = (await codec.getNextFrame()).image;
      controller.set(painterWidth, painterHeight);
      setState(() {
        uiImage = result;
      });
    });
  }
}
