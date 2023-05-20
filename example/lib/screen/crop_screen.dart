import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop/shapes/triangle_painter.dart';
import 'package:dynamic_image_crop_example/gen/assets.gen.dart';
import 'package:dynamic_image_crop_example/screen/buttons/image_button.dart';
import 'package:dynamic_image_crop_example/screen/buttons/toggle_image_button.dart';

import 'package:dynamic_image_crop/painter/dynamic_crop_painter.dart';
import 'package:dynamic_image_crop_example/screen/result_screen.dart';
import 'package:dynamic_image_crop/shapes/circle_painter.dart';
import 'package:dynamic_image_crop/shapes/custom_shape.dart';
import 'package:dynamic_image_crop/painter/drawing_painter.dart';
import 'package:dynamic_image_crop/camera_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'dart:ui' as ui;

class CropScreen extends StatefulWidget {
  const CropScreen(
    this.resultFile,
    this.imageWidth,
    this.imageHeight, {
    super.key,
    this.startMargin,
    this.topMargin,
  });

  final File resultFile;
  final double imageWidth;
  final double imageHeight;
  final double? startMargin;
  final double? topMargin;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  ShapeType shapeType = ShapeType.none;

  late double painterWidth; // painter 가로 길이를 fix
  double painterHeight = 0;

  ui.Image? uiImage;

  double dx = 0;
  double dy = 0;
  double cropWidth = 0;
  double cropHeight = 0;
  final painterKey = GlobalKey<DynamicCropPainterState>();
  final customDrawingKey = GlobalKey<CustomShapeState>();

  @override
  void initState() {
    getImage();
    super.initState();
  }

  void getImage() {
    painterWidth = widget.imageWidth;
    painterHeight = widget.imageHeight;
    widget.resultFile.readAsBytes().then((imageBytes) {
      loadImage(imageBytes, painterWidth, painterHeight).then((result) {
        setState(() {
          uiImage = result;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildPainter(),
              ],
            ),
          ),
          Positioned(
            width: size.width,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0x66666666),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ToggleImageButton(
                        key: rectangleButtonKey,
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
                        key: circleButtonKey,
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
                        key: triangleButtonKey,
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
                        key: drawingButtonKey,
                        offImage: Assets.images.mBookBtnDrawing.path,
                        onImage: Assets.images.mBookBtnDrawingSelected.path,
                        width: 87,
                        height: 73,
                        onTap: (imageState) {
                          setImageState(imageState, ShapeType.custom);
                        },
                      ),
                      ImageButton(
                        unpressedImage: Assets.images.mBookBtnCancel.path,
                        pressedImage:
                            Assets.images.mBookBtnCancelOverSelected.path,
                        width: 76,
                        height: 72,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(width: 12),
                      ImageButton(
                        unpressedImage: Assets.images.mBookBtnImgcropSave.path,
                        pressedImage:
                            Assets.images.mBookBtnImgcropSaveSelected.path,
                        width: 76,
                        height: 72,
                        onTap: () {
                          cropImage(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPainter() {
    if (shapeType == ShapeType.none) {
      return Image.file(
        widget.resultFile,
        width: painterWidth,
        height: painterHeight,
        fit: BoxFit.cover,
      );
    } else if (uiImage != null && shapeType != ShapeType.custom) {
      return DynamicCropPainter(
        painterWidth: painterWidth,
        painterHeight: painterHeight,
        uiImage: uiImage!,
        shapeType: shapeType,
        key: painterKey,
        startMargin: widget.startMargin ?? 0,
        topMargin: widget.topMargin ?? 0,
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
      sendResult(
        widget.resultFile.readAsBytesSync(),
        widget.imageWidth,
        widget.imageHeight,
        context,
      );
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

    ImageCrop.cropImage(file: widget.resultFile, area: area).then((file) {
      if (shapeType == ShapeType.rectangle) {
        sendResultImage(
          file.readAsBytesSync(),
          shapeWidth,
          shapeHeight,
          context,
        );
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
          sendImageToResultScreen(recorder, context, width, height);
        });
      }
    });
  }

  final rectangleButtonKey = GlobalKey<ToggleImageButtonState>();
  final circleButtonKey = GlobalKey<ToggleImageButtonState>();
  final triangleButtonKey = GlobalKey<ToggleImageButtonState>();
  final drawingButtonKey = GlobalKey<ToggleImageButtonState>();

  Widget buildShapeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ToggleImageButton(
          key: rectangleButtonKey,
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
          key: circleButtonKey,
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
          key: triangleButtonKey,
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
          key: drawingButtonKey,
          offImage: Assets.images.mBookBtnDrawing.path,
          onImage: Assets.images.mBookBtnDrawingSelected.path,
          width: 87,
          height: 73,
          onTap: (imageState) {
            setImageState(imageState, ShapeType.custom);
          },
        ),
      ],
    );
  }

  void setImageState(bool imageState, ShapeType type) {
    setState(() {
      if (imageState) {
        // 이미 켜져있는 버튼 닫기
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
    rectangleButtonKey.currentState!.setState(() {
      rectangleButtonKey.currentState!.imageState = state;
    });
  }

  void setCircleState(bool state) {
    circleButtonKey.currentState!.setState(() {
      circleButtonKey.currentState!.imageState = state;
    });
  }

  void setTriangleState(bool state) {
    triangleButtonKey.currentState!.setState(() {
      triangleButtonKey.currentState!.imageState = state;
    });
  }

  void setDrawingState(bool state) {
    drawingButtonKey.currentState!.setState(() {
      drawingButtonKey.currentState!.imageState = state;
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
        .toImageSync(shapeWidth.floor(), shapeHeight.floor());

    rendered.toByteData(format: ui.ImageByteFormat.png).then((bytes) {
      sendResultImage(
        bytes?.buffer.asUint8List(),
        shapeWidth,
        shapeHeight,
        context,
      );
    });
  }

  void sendResultImage(
    Uint8List? bytes,
    double shapeWidth,
    double shapeHeight,
    BuildContext context,
  ) {
    if (bytes != null) {
      sendResult(bytes, shapeWidth, shapeHeight, context);
    }
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

  void sendResult(
      Uint8List image, double width, double height, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ResultScreen(image: image, width: width, height: height),
      ),
    );
  }
}
