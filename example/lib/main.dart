import 'dart:ui';

import 'package:dynamic_image_crop/crop_controller.dart';
import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:dynamic_image_crop/shapes/shape_type.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      home: CropScreen(),
    );
  }
}

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  ShapeType shapeType = ShapeType.none;

  Uint8List? image;
  final cropController = CropController();
  final urlController = TextEditingController();

  // https://medium.com/flutter/racing-forward-at-i-o-2023-with-flutter-and-dart-df2a8fa841ab
  final initialUrl = 'https://miro.medium.com/v2/1*bzC0ul7jBVhOJiastVGKlw.png';

  @override
  void initState() {
    urlController.text = initialUrl;
    loadImage(initialUrl);
    super.initState();
  }

  void loadImage(
    String url, {
    void Function(Uint8List)? callback,
  }) {
    // Network image to Uint8List
    Image.network(url).image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _) async {
        final byteData =
            await info.image.toByteData(format: ImageByteFormat.png);
        setState(() {
          image = byteData!.buffer.asUint8List();
          if (image != null) {
            callback?.call(image!);
          }
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: '1',
            onPressed: cropController.cropImage,
            label: const Text('Crop'),
          ),
          FloatingActionButton.extended(
            heroTag: '2',
            onPressed: () {
              changeShape(ShapeType.none);
            },
            label: const Text('Cancel'),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (image == null)
              const Center(child: CircularProgressIndicator())
            else
              Center(
                child: DynamicImageCrop(
                  controller: cropController,
                  initialImage: image!,
                  cropResult: (image, width, height) {
                    sendResultImage(image, context);
                  },
                ),
              ),
            const Center(),
            Positioned(
              width: size.width,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.black,
                child: Center(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: buildButtons(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: urlController,
                              decoration: const InputDecoration(
                                hintText: 'Enter URL',
                              ),
                              onChanged: (value) {
                                urlController.text = value;
                              },
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              loadImage(
                                urlController.text,
                                callback: cropController.changeImage,
                              );
                            },
                            child: const Text('Load'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.rectangle);
          },
          child: const Text('Rect'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.circle);
          },
          child: const Text('Circle'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.triangle);
          },
          child: const Text('Triangle'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            changeShape(ShapeType.drawing);
          },
          child: const Text('Drawing'),
        ),
      ],
    );
  }

  void changeShape(ShapeType type) {
    cropController.changeType(type);
  }

  void sendResultImage(
    Uint8List? bytes,
    BuildContext context,
  ) {
    if (bytes != null) {
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (_) => ResultScreen(
            image: bytes,
          ),
        ),
      );
    }
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.image,
    super.key,
  });

  final Uint8List image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back),
      ),
      body: Center(
        child: Image.memory(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
