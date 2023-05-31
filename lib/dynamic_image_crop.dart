import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/crop_controller.dart';
import 'package:dynamic_image_crop/image_utils.dart';
import 'package:dynamic_image_crop/painter/figure_shape_view.dart';
import 'package:dynamic_image_crop/shapes/custom_shape.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:flutter/material.dart';

class DynamicImageCrop extends StatefulWidget {

  const DynamicImageCrop({
    required this.initialImage,
    required this.controller,
    required this.cropResult,
    this.lineColor,
    this.strokeWidth,
    super.key,
  });

  DynamicImageCrop.fromFile({
    required File imageFile,
    required this.controller,
    required this.cropResult,
    this.lineColor,
    this.strokeWidth,
    super.key,
  }) : initialImage = imageFile.readAsBytesSync();

  final Uint8List initialImage;
  final CropController controller;
  final void Function(Uint8List resultImage, int width, int height) cropResult;
  final Color? lineColor;
  final double? strokeWidth;

  @override
  State<DynamicImageCrop> createState() => _DynamicImageCropState();
}

class _DynamicImageCropState extends State<DynamicImageCrop> {

  late final callback = widget.cropResult;
  late final controller = widget.controller;

  late final lineColor = widget.lineColor ?? const Color(0xffff572b);
  late final strokeWidth = widget.strokeWidth ?? 2.0;

  double painterWidth = 0;
  double painterHeight = 0;

  final myKey = GlobalKey();
  final painterKey = GlobalKey<FigureShapeViewState>();
  final drawingKey = GlobalKey<CustomShapeState>();

  Size? imageSize;

  @override
  void initState() {
    controller.init(
      image: widget.initialImage,
      callback: callback,
      painterKey: painterKey,
      drawingKey: drawingKey,
    );
    controller.imageNotifier.addListener(() {
      getImageInfo(controller.imageNotifier.image);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getImageInfo(controller.imageNotifier.image);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller.imageNotifier,
      builder: (pc, _) {
        return ListenableBuilder(
          key: myKey,
          listenable: controller.shapeNotifier,
          builder: (c, _) {
            if (controller.shapeNotifier.shapeType == ShapeType.none) {
              return backgroundImage();
            }
            if (imageSize == null) return Container();
            if (controller.shapeNotifier.shapeType == ShapeType.drawing) {
              return Stack(
                children: [
                  backgroundImage(),
                  CustomShape(
                    painterWidth: imageSize!.width,
                    painterHeight: imageSize!.height,
                    lineColor: lineColor,
                    strokeWidth: strokeWidth,
                    key: drawingKey,
                  ),
                ],
              );
            }
            return Stack(
              children: [
                backgroundImage(),
                FigureShapeView(
                  painterWidth: imageSize!.width,
                  painterHeight: imageSize!.height,
                  shapeNotifier: controller.shapeNotifier,
                  lineColor: lineColor,
                  strokeWidth: strokeWidth,
                  key: painterKey,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Image backgroundImage() {
    return Image.memory(
      controller.imageNotifier.image,
      width: painterWidth,
      height: painterHeight,
      fit: BoxFit.cover,
    );
  }

  Future<void> getImageInfo(Uint8List image) async {
    final s = ImageUtils.getPainterSize(context);
    final deviceWidth = s.width;
    final deviceHeight = s.height;

    await ImageUtils.getImageSize(image, (imageWidth, imageHeight) async {
      final isImageWidthLonger = imageWidth > imageHeight;

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
      }
      controller.set(painterWidth, painterHeight);
      setState(() {});
      getSizeAfterRenderImage();
    });
  }

  void getSizeAfterRenderImage() {
    Future<dynamic>.delayed(const Duration(milliseconds: 300)).then((value) {
      if (myKey.currentContext != null) {
        final renderBox =
            myKey.currentContext!.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          imageSize = renderBox.size;
          debugPrint('size: $imageSize');
        }
      }
    });
  }
}
