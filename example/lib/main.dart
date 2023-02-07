import 'dart:io';
import 'dart:typed_data';

import 'package:dynamic_image_crop/crop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Uint8List? bytes;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              bytes != null
                  ? Expanded(child: MyCrop.bytes(bytes!, key: key))
                  : const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () async {
                  final file = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  setState(() {
                    bytes = File(file!.path).readAsBytesSync();
                  });
                },
                child: const Text('갤러리'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
