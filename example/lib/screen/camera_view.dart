// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dynamic_image_crop_example/screen/crop_screen.dart';
import 'package:dynamic_image_crop_example/ui/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final cameraFullWidth = MediaQuery.of(context).size.width - 133;
    final deviceHeight = MediaQuery.of(context).size.height;
    final cameraRealWidth = deviceHeight * (4 / 3);

    final horizontalMargin = (cameraFullWidth - cameraRealWidth) / 2;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraRealPreview(deviceHeight, cameraFullWidth),
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
                    unpressedImage: 'images/camera_btn_rotate_nor.webp',
                    pressedImage: 'images/camera_btn_rotate_pre.webp',
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
              unpressedImage: 'images/camera_btn_shutter_nor.webp',
              pressedImage: 'images/camera_btn_shutter_pre.webp',
              width: 160,
              height: 147,
              onTap: () => takePicture(context),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.all(26),
              child: ImageButton(
                unpressedImage: 'images/camera_btn_back_nor.webp',
                pressedImage: 'images/camera_btn_back_pre.webp',
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

  Future<void> takePicture(BuildContext context) async {
    final xFile = await cameraController?.takePicture();
    final croppedImageBytes = File(xFile?.path ?? '').readAsBytesSync();
    final tempFile = await File('${(await getTemporaryDirectory()).path}/image.jpg')
            .create();
    final resultFile = await tempFile.writeAsBytes(croppedImageBytes);
    if (resultFile.existsSync()) {
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CropScreen(resultFile),
        ),
      );
    }
  }

  Widget CameraRealPreview(double deviceHeight, double cameraFullWidth) {
    return isReady()
        ? Center(
            child: SizedBox(
              height: deviceHeight,
              child: CameraPreview(cameraController!),
            ),
          )
        : SizedBox(width: cameraFullWidth);
  }

  Widget MarginForCameraPreview(
      double horizontalMargin, double cameraFullWidth) {
    return Stack(
      children: [
        Container(
          color: Colors.black,
          width: horizontalMargin,
        ),
        SizedBox(
          width: cameraFullWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              color: Colors.black,
              width: horizontalMargin,
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
