// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:camera/camera.dart';
import 'package:dynamic_image_crop_example/gen/assets.gen.dart';
import 'package:dynamic_image_crop_example/ui/buttons/image_button.dart';
import 'package:dynamic_image_crop_example/utils/camera_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  @override
  void initState() {
    initCamera();
    super.initState();
  }

  bool isCameraBack = true;
  CameraController? cameraController;
  Rect area = Rect.zero;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final cameraFullWidth = MediaQuery.of(context).size.width - 133;
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    final cameraRealWidth = deviceHeight * (4 / 3);

    final horizontalMargin = (cameraFullWidth - cameraRealWidth) / 2;
    final aspectRatio = MediaQuery.of(context).size.aspectRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraRealPreview(deviceHeight, cameraFullWidth, aspectRatio),
          MarginForCameraPreview(horizontalMargin, cameraFullWidth),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              color: const Color(0xffffaf31),
              width: 133,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 27),
                  child: ImageButton(
                    unpressedImage: Assets.images.cameraBtnRotateNor.path,
                    pressedImage: Assets.images.cameraBtnRotatePre.path,
                    width: 80,
                    height: 80,
                    onTap: () {
                      setState(() {
                        isCameraBack = !isCameraBack;
                        initCamera(back: isCameraBack);
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ImageButton(
              unpressedImage: Assets.images.cameraBtnShutterNor.path,
              pressedImage: Assets.images.cameraBtnShutterPre.path,
              width: 160,
              height: 147,
              onTap: () => takePicture(
                context,
                horizontalMargin,
                cameraRealWidth,
                deviceHeight,
                deviceWidth,
                aspectRatio,
                cameraController,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(26),
              child: ImageButton(
                unpressedImage: Assets.images.cameraBtnBackNor.path,
                pressedImage: Assets.images.cameraBtnBackPre.path,
                width: 80,
                height: 80,
                onTap: () => Navigator.pop(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void activate() {
    initCamera(back: isCameraBack);
    super.activate();
  }

  @override
  void deactivate() {
    cameraController?.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  Widget CameraRealPreview(
      double deviceHeight, double cameraFullWidth, double aspectRatio) {
    if (isReady()) {
      var scale = aspectRatio / cameraController!.value.aspectRatio;
      if (scale < 1) scale = 1 / scale;
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(isCameraBack ? 0 : pi),
        child: Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(cameraController!),
          ),
        ),
      );
    }

    return SizedBox(width: cameraFullWidth);
  }

  Widget MarginForCameraPreview(
    double horizontalMargin,
    double cameraFullWidth,
  ) {
    double margin = horizontalMargin < 0 ? 0 : horizontalMargin;
    return Stack(
      children: [
        Container(
          color: Colors.black,
          width: margin,
        ),
        SizedBox(
          width: cameraFullWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              color: Colors.black,
              width: margin,
            ),
          ),
        ),
      ],
    );
  }

  bool isReady() {
    return cameraController?.value.isInitialized ?? false;
  }

  void initCamera({bool back = true}) {
    Future.microtask(() async {
      final cameras = await availableCameras();
      cameraController = CameraController(
        cameras[back ? 0 : 1],
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      cameraController?.initialize().then((_) async {
        await cameraController!.setFlashMode(FlashMode.off);
        setState(() {});
      }).catchError((Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              break;
            default:
              break;
          }
        }
        setState(() {});
      });
    });
  }

  double getScaleForCamera(
    CameraController? cameraController,
    BuildContext context,
  ) {
    var scale = 1.0;
    if (cameraController != null &&
        cameraController.value.isInitialized == true) {
      scale = cameraController.value.aspectRatio;
    }
    return scale;
  }
}
