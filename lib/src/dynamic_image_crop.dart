import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dynamic_image_crop/src/controller/crop_controller.dart';
import 'package:dynamic_image_crop/src/crop/crop_type.dart';
import 'package:dynamic_image_crop/src/image_utils.dart';
import 'package:dynamic_image_crop/src/ui/drawing_view.dart';
import 'package:dynamic_image_crop/src/ui/figure_shape_view.dart';
import 'package:flutter/material.dart';

class DynamicImageCrop extends StatefulWidget {
  /// Input image as bytes([Uint8List]).
  ///
  /// Declare [CropController] variable and input it to control this Widget.
  ///
  /// [onResult] is a callback function that returns the cropped image, width, and height.
  const DynamicImageCrop({
    required this.image,
    required this.controller,
    required this.onResult,
    this.imageByteFormat,
    this.cropLineColor,
    this.cropLineWidth,
    super.key,
  });

  /// Input image as File.
  ///
  /// Declare [CropController] variable and input it to control this Widget.
  ///
  /// [onResult] is a callback function that returns the cropped image, width, and height.
  DynamicImageCrop.fromFile({
    required File imageFile,
    required this.controller,
    required this.onResult,
    this.imageByteFormat,
    this.cropLineColor,
    this.cropLineWidth,
    super.key,
  }) : image = imageFile.readAsBytesSync();

  final Uint8List image;
  final CropController controller;
  final void Function(Uint8List resultImage, int width, int height) onResult;
  final ui.ImageByteFormat? imageByteFormat;
  final Color? cropLineColor;
  final double? cropLineWidth;

  @override
  State<DynamicImageCrop> createState() => _DynamicImageCropState();
}

class _DynamicImageCropState extends State<DynamicImageCrop> {
  late final callback = widget.onResult;
  late final controller = widget.controller;
  late final imageByteFormat = widget.imageByteFormat ?? ui.ImageByteFormat.png;

  late final lineColor = widget.cropLineColor ?? const Color(0xffff572b);
  late final strokeWidth = widget.cropLineWidth ?? 2.0;

  final boxConstraintsNotifier = ValueNotifier(const BoxConstraints());

  double painterWidth = 0;
  double painterHeight = 0;

  final myKey = GlobalKey();
  final painterKey = GlobalKey<FigureShapeViewState>();
  final drawingKey = GlobalKey<DrawingViewState>();

  @override
  void initState() {
    super.initState();
    controller.init(
      image: widget.image,
      imageByteFormat: imageByteFormat,
      callback: callback,
      painterKey: painterKey,
      drawingKey: drawingKey,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.microtask(() async {
        await getImageInfo(controller.imageNotifier.image);
        controller.imageNotifier.addListener(() {
          getImageInfo(controller.imageNotifier.image);
        });
        boxConstraintsNotifier.addListener(() {
          getImageInfo(controller.imageNotifier.image);
        });
        controller.cropTypeNotifier.addListener(() {
          getImageInfo(controller.imageNotifier.image);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Size?>(
      valueListenable: controller.imageSizeNotifier,
      builder: (context, imageSize, child) {
        if (imageSize == null) return Container();
        return LayoutBuilder(
          builder: (context, constraints) {
            if (boxConstraintsNotifier.value != constraints) {
              boxConstraintsNotifier.value = constraints;
            }
            if (controller.cropTypeNotifier.value == CropType.none) {
              return backgroundImage();
            }
            if (controller.cropTypeNotifier.value == CropType.drawing) {
              return Stack(
                children: [
                  backgroundImage(),
                  DrawingView(
                    painterWidth: imageSize.width,
                    painterHeight: imageSize.height,
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
                  painterWidth: imageSize.width,
                  painterHeight: imageSize.height,
                  shapeNotifier: controller.cropTypeNotifier,
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
    final s = ImageUtils.getPainterSize(boxConstraintsNotifier.value);
    final deviceWidth = s.width;
    final deviceHeight = s.height;

    ImageUtils.getImageSize(image, (imageWidth, imageHeight) async {
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
      setState(() {
        final size = Size(painterWidth, painterHeight);
        controller.imageSizeNotifier.value = size;
        controller.painterSize = size;
      });
    });
  }
}
