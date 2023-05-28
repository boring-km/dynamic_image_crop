import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dynamic_image_crop/crop_controller.dart';
import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';
import 'package:dynamic_image_crop_example/gen/assets.gen.dart';
import 'package:dynamic_image_crop_example/screen/buttons/image_button.dart';
import 'package:dynamic_image_crop_example/screen/buttons/toggle_image_button.dart';
import 'package:dynamic_image_crop_example/screen/result_screen.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({super.key});

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SelectView(),
    );
  }
}

class SelectView extends StatefulWidget {
  const SelectView({Key? key}) : super(key: key);

  @override
  State<SelectView> createState() => _SelectViewState();
}

class _SelectViewState extends State<SelectView> {
  final ImagePicker imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: pickCamera, child: const Text('Camera')),
            ElevatedButton(onPressed: pickImage, child: const Text('Gallery')),
          ],
        ),
      ),
    );
  }

  void pickCamera() {
    imagePicker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        final file = File(xFile.path);
        if (file.existsSync()) {
          moveToCropScreen(file);
        }
      }
    });
  }

  void pickImage() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        final file = File(xFile.path);
        if (file.existsSync()) {
          moveToCropScreen(file);
        }
      }
    });
  }

  void moveToCropScreen(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CropScreen(file),
      ),
    );
  }
}

class CropScreen extends StatefulWidget {
  const CropScreen(this.resultFile, {super.key});

  final File resultFile;

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  ShapeType shapeType = ShapeType.none;
  late final imageFile = widget.resultFile;

  final controller = CropController();

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
                DynamicImageCrop(
                  controller: controller,
                  imageFile: imageFile,
                  cropResult: (image, width, height) {
                    sendResultImage(image, width, height, context);
                  },
                ),
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
                          controller.cropImage(context);
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
        controller.changeType(type);
      } else {
        controller.changeType(ShapeType.none);
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

  void sendResultImage(
    Uint8List? bytes,
    double shapeWidth,
    double shapeHeight,
    BuildContext context,
  ) {
    if (bytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
              image: bytes, width: shapeWidth, height: shapeHeight),
        ),
      );
    }
  }
}
