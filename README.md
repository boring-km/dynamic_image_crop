# dynamic_image_crop

<p align="center">
<a href="https://pub.dev/packages/dynamic_image_crop"><img src="https://img.shields.io/pub/v/dynamic_image_crop.svg" alt="Pub"></a>
<a href="https://codecov.io/gh/boring-km/dynamic_image_crop"><img src="https://codecov.io/gh/boring-km/dynamic_image_crop/branch/master/graph/badge.svg?token=c8fbc37f-5266-4bdb-8b09-ccb7ba5bf711"/></a>
<a href="https://boring-km.dev/dynamic_image_crop"><img src="https://img.shields.io/badge/flutter-demo-deepskyblue.svg" alt="Flutter Demo"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

---

A Flutter package to crop images into various shapes.

## Introduction

<img src="https://github.com/boring-km/dynamic_image_crop/raw/master/images/demo.gif" width="40%" alt="demo">

You can test the package by this link: [demo_link](https://boring-km.dev/dynamic_image_crop/)

## Features

dynamic_image_crop supports the following features:

- Crop an image into user drawing shapes.
- Crop an image into rectangle, circle, triangle shapes.
- Change the color of the crop shape line.
- Change the width of the crop shape line.

## Usage

```dart
import 'package:dynamic_image_crop/dynamic_image_crop.dart';

final controller = CropController();

DynamicImageCrop(
  controller: controller,
  image: image!,  // Uint8List
  onResult: (image, width, height) {
    // cropped Image (Uint8List), width and height
  },
  cropLineColor: Colors.red, // (Optional)
  cropLineWidth: 1.0, // (Optional)
)

DynamicImageCrop.fromFile(
  imageFile: file,  // File
  controller: controller,
  onResult: (image, width, height) {
    // cropped Image (Uint8List), width and height
  },
)
```

```CropController``` has the following methods:

```dart
void cropImage() {}
void changeType(CropType type) {}
void changeImage(Uint8List image) {}
void clearCropArea() {}
```

```CropType``` has the following types:

```dart
enum CropType {
  rectangle, circle, triangle, drawing, none
}
```
