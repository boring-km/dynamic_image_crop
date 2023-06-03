import 'dart:ui';

import 'package:dynamic_image_crop/dynamic_image_crop.dart';
import 'package:flutter/cupertino.dart';

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
  CropType cropType = CropType.none;

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
    ImageByteFormat imageFormat = ImageByteFormat.png,
  }) {
    // Network image to Uint8List
    Image.network(url).image.resolve(ImageConfiguration.empty).addListener(
      ImageStreamListener((info, _) async {
        try {
          final byteData =
          await info.image.toByteData(format: imageFormat);
          setState(() {
            image = byteData!.buffer.asUint8List();
            if (image != null) {
              callback?.call(image!);
            }
          });
        } catch (e) {
          debugPrint('try another image byte format: $e');
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: cropController.cropImage,
        backgroundColor: Colors.white,
        label: const Text('Crop', style: TextStyle(color: Colors.black)),
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
                  image: image!,
                  onResult: (image, width, height) {
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
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              onPressed: () {
                                loadImage(
                                  urlController.text,
                                  callback: cropController.changeImage,
                                );
                              },
                              icon: const Icon(
                                CupertinoIcons.search_circle_fill,
                                color: Colors.white,
                              ),
                            ),
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
        IconButton(
          onPressed: () => changeShape(CropType.rectangle),
          icon: const Icon(CupertinoIcons.rectangle_fill, color: Colors.white),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => changeShape(CropType.circle),
          icon: const Icon(CupertinoIcons.circle_fill, color: Colors.white),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => changeShape(CropType.triangle),
          icon: const Icon(CupertinoIcons.triangle_fill, color: Colors.white),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => changeShape(CropType.drawing),
          icon: const Icon(CupertinoIcons.pencil_outline, color: Colors.white),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () => changeShape(CropType.none),
          icon: const Icon(
            CupertinoIcons.clear_circled_solid,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void changeShape(CropType type) {
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
        backgroundColor: Colors.white,
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back, color: Colors.black),
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
