import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop_example/gen/assets.gen.dart';
import 'package:dynamic_image_crop_example/screen/result_screen.dart';
import 'package:dynamic_image_crop_example/ui/buttons/image_button.dart';
import 'package:dynamic_image_crop_example/ui/buttons/toggle_image_button.dart';
import 'package:dynamic_image_crop_example/ui/painter/custom_crop_painter.dart';
import 'package:dynamic_image_crop_example/ui/painter/dynamic_crop_painter.dart';
import 'package:dynamic_image_crop_example/ui/shapes/circle_painter.dart';
import 'package:dynamic_image_crop_example/ui/shapes/rectangle_painter.dart';
import 'package:dynamic_image_crop_example/ui/shapes/shape_type.dart';
import 'package:dynamic_image_crop_example/ui/shapes/triangle_painter.dart';
import 'package:flutter/material.dart';
import 'package:image_size_getter/image_size_getter.dart' as isg;
import 'dart:ui' as ui;

class CropScreen extends StatefulWidget {
  const CropScreen(
    this.resultFile,
    this.imageWidth,
    this.imageHeight,
    this.topMargin, {
    Key? key,
  }) : super(key: key);

  final File resultFile;
  final double imageWidth;
  final double imageHeight;
  final double topMargin;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  ShapeType shapeType = ShapeType.none;
  isg.Size? imageSize;

  late double painterWidth; // painter 가로 길이를 fix
  double painterHeight = 0.0;

  ui.Image? uiImage;

  double dx = 0;
  double dy = 0;
  double cropWidth = 0;
  double cropHeight = 0;
  late double topMargin;
  final painterKey = GlobalKey<DynamicCropPainterState>();

  @override
  void initState() {
    getImage();
    super.initState();
  }

  void getImage() {
    painterWidth = widget.imageWidth;
    painterHeight = widget.imageHeight;
    topMargin = widget.topMargin;
    widget.resultFile.readAsBytes().then((imageBytes) {
      loadImage(imageBytes, painterWidth).then((result) {
        setState(() {
          uiImage = result;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final menuWidth = (size.width - painterWidth) / 2;

    return Scaffold(
      backgroundColor: const Color(0xff3b4278),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildShapeButtons(menuWidth),
          Container(
            margin: EdgeInsets.only(top: topMargin),
            child: Builder(builder: (context) {
              if (shapeType == ShapeType.none) {
                return Image.file(
                  widget.resultFile,
                  width: painterWidth,
                  height: painterHeight,
                );
              } else if (uiImage != null && shapeType != ShapeType.custom) {
                return DynamicCropPainter(
                  painterWidth: painterWidth,
                  painterHeight: painterHeight,
                  uiImage: uiImage!,
                  shapeType: shapeType,
                  key: painterKey,
                  startMargin: menuWidth,
                  topMargin: topMargin,
                  cropCallback: (x, y, width, height) {
                    dx = x;
                    dy = y;
                    cropWidth = width;
                    cropHeight = height;
                  },
                );
              } else if (uiImage != null && shapeType == ShapeType.custom) {
                return Container(
                  color: Colors.transparent,
                  width: painterWidth,
                  height: painterHeight,
                  child: CustomCropPainter(uiImage!),
                );
              } else {
                return Container();
              }
            }),
          ),
          SizedBox(
            width: menuWidth,
            child: Container(
              margin: EdgeInsets.only(top: topMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ImageButton(
                    unpressedImage: Assets.images.mBookBtnCancel.path,
                    pressedImage: Assets.images.mBookBtnCancelOverSelected.path,
                    width: 76,
                    height: 72,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 12),
                  ImageButton(
                    unpressedImage: Assets.images.mBookBtnImgcropSave.path,
                    pressedImage:
                        Assets.images.mBookBtnImgcropSaveSelected.path,
                    width: 76,
                    height: 72,
                    onTap: () {
                      final recorder = ui.PictureRecorder();
                      final canvas = Canvas(recorder);

                      final xPos = painterKey.currentState!.xPos;
                      final yPos = painterKey.currentState!.yPos;
                      final shapeWidth = painterKey.currentState!.shapeWidth;
                      final shapeHeight = painterKey.currentState!.shapeHeight;

                      if (shapeType == ShapeType.rectangle) {
                        RectanglePainterForCrop(
                          Rect.fromLTWH(xPos, yPos, shapeWidth, shapeHeight),
                          uiImage!,
                        ).paint(
                          canvas,
                          Size(painterWidth, painterHeight),
                        );
                        sendImageToResultScreen(
                            recorder, context, shapeWidth, shapeHeight);
                      } else if (shapeType == ShapeType.circle) {
                        CirclePainterForCrop(
                          Rect.fromLTWH(xPos, yPos, shapeWidth, shapeHeight),
                          uiImage!,
                        ).paint(
                          canvas,
                          Size(painterWidth, painterHeight),
                        );
                        sendImageToResultScreen(
                            recorder, context, shapeWidth, shapeHeight);
                      } else if (shapeType == ShapeType.triangle) {
                        TrianglePainterForCrop(
                          Rect.fromLTWH(xPos, yPos, shapeWidth, shapeHeight),
                          uiImage!,
                        ).paint(
                          canvas,
                          Size(painterWidth, painterHeight),
                        );
                        sendImageToResultScreen(
                            recorder, context, shapeWidth, shapeHeight);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  final rectangleKey = GlobalKey<ToggleImageButtonState>();
  final circleKey = GlobalKey<ToggleImageButtonState>();
  final triangleKey = GlobalKey<ToggleImageButtonState>();
  final drawingKey = GlobalKey<ToggleImageButtonState>();

  Widget buildShapeButtons(double menuWidth) {
    return SizedBox(
      width: menuWidth,
      child: Center(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: topMargin),
                child: Assets.images.imgTypeLogo.image(),
              ),
            ),
            SizedBox(
              width: menuWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ToggleImageButton(
                    key: rectangleKey,
                    offImage: Assets.images.mBookBtnNemo.path,
                    onImage: Assets.images.mBookBtnNemoSelected.path,
                    width: 87,
                    height: 73,
                    onTap: (imageState) {
                      setImageState(imageState, ShapeType.rectangle);
                    },
                  ),
                  const SizedBox(height: 26),
                  ToggleImageButton(
                    key: circleKey,
                    offImage: Assets.images.mBookBtnCircle.path,
                    onImage: Assets.images.mBookBtnCircleSelected.path,
                    width: 87,
                    height: 73,
                    onTap: (imageState) {
                      setImageState(imageState, ShapeType.circle);
                    },
                  ),
                  const SizedBox(height: 26),
                  ToggleImageButton(
                    key: triangleKey,
                    offImage: Assets.images.mBookBtnTriangle.path,
                    onImage: Assets.images.mBookBtnTriangleSelected.path,
                    width: 87,
                    height: 73,
                    onTap: (imageState) {
                      setImageState(imageState, ShapeType.triangle);
                    },
                  ),
                  const SizedBox(height: 26),
                  ToggleImageButton(
                    key: drawingKey,
                    offImage: Assets.images.mBookBtnDrawing.path,
                    onImage: Assets.images.mBookBtnDrawingSelected.path,
                    width: 87,
                    height: 73,
                    onTap: (imageState) {
                      setImageState(imageState, ShapeType.custom);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setImageState(bool imageState, ShapeType type) {
    setState(() {
      if (imageState) {  // 이미 켜져있는 버튼 닫기
        if (shapeType != type) {
          if (shapeType == ShapeType.rectangle) {
            setRectangleState(!imageState);
          } else if (shapeType == ShapeType.circle) {
            setCircleState(!imageState);
          } else if (shapeType == ShapeType.triangle) {
            setTriangleState(!imageState);
          } else if (shapeType == ShapeType.custom) {
            setDrawingState(!imageState);
          }
        }
        shapeType = type;
      } else {
        shapeType = ShapeType.none;
      }
    });
  }

  void setRectangleState(bool state) {
    rectangleKey.currentState!.setState(() {
      rectangleKey.currentState!.imageState = state;
    });
  }

  void setCircleState(bool state) {
    circleKey.currentState!.setState(() {
      circleKey.currentState!.imageState = state;
    });
  }

  void setTriangleState(bool state) {
    triangleKey.currentState!.setState(() {
      triangleKey.currentState!.imageState = state;
    });
  }

  void setDrawingState(bool state) {
    drawingKey.currentState!.setState(() {
      drawingKey.currentState!.imageState = state;
    });
  }

  void sendImageToResultScreen(
    ui.PictureRecorder recorder,
    BuildContext context,
    double shapeWidth,
    double shapeHeight,
  ) {
    final rendered = recorder
        .endRecording()
        .toImageSync((shapeWidth).floor(), (shapeHeight).floor());

    rendered.toByteData(format: ui.ImageByteFormat.png).then((bytes) {
      if (bytes != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              image: bytes.buffer.asUint8List(),
              width: shapeWidth,
              height: shapeHeight,
            ),
          ),
        );
      }
    });
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
    double targetWidth,
  ) async {
    final codec = await ui.instantiateImageCodec(
      img,
      targetWidth: painterWidth.toInt(),
      targetHeight: painterHeight.toInt(),
    );
    return (await codec.getNextFrame()).image;
  }
}
