# dynamic_image_crop

A Flutter package to crop images into various shapes.

## Introduction

<img src="images/demo.gif" width="40%" alt="demo">

## Features

dynamic_image_crop supports the following features:

- Crop an image into rectangle, circle, triangle shapes.
- Crop an image into user drawing shapes.
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
)
```

```CropController``` has the following methods:

```dart
void cropImage() {}
void changeType(CropType type) {}
void changeImage(Uint8List image) {}
```

```CropType``` has the following types:

```dart
enum CropType {
  rectangle, circle, triangle, drawing, none
}
```
