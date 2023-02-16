import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop_example/ui/painter/custom_crop_painter.dart';
import 'package:dynamic_image_crop_example/ui/painter/dynamic_crop_painter.dart';
import 'package:dynamic_image_crop_example/ui/shapes/shape_type.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart' as isg;
import 'dart:ui' as ui;

class CropScreen extends StatefulWidget {
  const CropScreen(this.resultFile, {Key? key}) : super(key: key);

  final File resultFile;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  ShapeType shapeType = ShapeType.rectangle;
  late File imageFile;
  isg.Size? imageSize;

  final painterWidth = 900.0; // painter 가로 길이를 fix
  double painterHeight = 0.0;

  ui.Image? uiImage;

  double dx = 0;
  double dy = 0;
  double cropWidth = 0;
  double cropHeight = 0;

  @override
  void initState() {
    getImageFrom(ImageSource.camera);
    super.initState();
  }

  void getImageFrom(ImageSource imageSource) {
    imageFile = widget.resultFile;
    if (imageFile.existsSync()) {
      imageSize = isg.ImageSizeGetter.getSize(FileInput(imageFile));
      imageFile.readAsBytes().then((imageBytes) {
        loadImage(imageBytes, imageSize!, painterWidth).then((result) {
          setState(() {
            uiImage = result;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        shapeType = ShapeType.rectangle;
                      });
                    },
                    child: const Text('네모')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        shapeType = ShapeType.circle;
                      });
                    },
                    child: const Text('동그라미')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        shapeType = ShapeType.triangle;
                      });
                    },
                    child: const Text('세모')),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        shapeType = ShapeType.custom;
                      });
                    },
                    child: const Text('직접 그리기')),
              ],
            ),
          ),
          Builder(builder: (context) {
            if (uiImage != null && shapeType != ShapeType.custom) {
              return DynamicCropPainter(
                painterWidth: painterWidth,
                painterHeight: painterHeight,
                uiImage: uiImage!,
                shapeType: shapeType,
                cropCallback: (x, y, width, height) {
                  dx = x;
                  dy = y;
                  cropWidth = width;
                  cropHeight = height;
                },
              );
            } else if (uiImage != null && shapeType == ShapeType.custom) {
              // TODO 작성 필요
              print('custom');
              return Container(
                color: Colors.transparent,
                width: 400,
                height: 400,
                child: const CustomCropPainter(),
              );
            } else {
              return Container();
            }
          }),
        ],
      ),
    );
  }

  double setPainterHeight(BuildContext context, double width) {
    var height = 0.0;
    if (imageSize != null) {
      final deviceWidth = MediaQuery.of(context).size.width;
      final deviceHeight = MediaQuery.of(context).size.height;
      var ratio = width / deviceWidth;
      height = (ratio * deviceHeight);
      if (height > deviceHeight) {
        height = (deviceHeight - 100);
      }
    }
    return height;
  }

  Future<ui.Image> loadImage(
    Uint8List img,
    isg.Size imageSize,
    double targetWidth,
  ) async {
    painterHeight = (imageSize.height / imageSize.width) * targetWidth;
    final codec = await ui.instantiateImageCodec(
      img,
      targetWidth: targetWidth.toInt(),
      targetHeight: painterHeight.toInt(),
    );
    return (await codec.getNextFrame()).image;
  }
}
