import 'package:flutter/material.dart';

class ImageButton extends StatefulWidget {
  const ImageButton({
    Key? key,
    required this.unpressedImage,
    required this.pressedImage,
    this.completeImage,
    required this.onTap,
    this.width,
    this.height,
    this.isComplete,
    this.isToggle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String unpressedImage;
  final String pressedImage;
  final String? completeImage;
  final double? width;
  final double? height;
  final bool? isToggle;
  final bool? isComplete;
  final Function() onTap;

  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {
  late Image imagePressed;
  late Image imageUnPressed;
  Image? completeImage;
  late Image currentImage;
  late Function() _action;
  bool preloaded = false;
  bool isToggle = false;
  bool imageState = true;
  bool? isComplete = false;

  bool isClick = false;

  @override
  void initState() {
    _setValue();
    super.initState();
  }

  void _setValue() {
    imagePressed = Image.asset(widget.pressedImage);

    if (widget.isComplete != null) {
      isComplete = widget.isComplete;
      if (isComplete ?? false) {
        imageUnPressed = Image.asset(widget.completeImage!);
      } else {
        imageUnPressed = Image.asset(widget.unpressedImage);
      }
      completeImage = Image.asset(widget.completeImage!);
    } else {
      imageUnPressed = Image.asset(widget.unpressedImage);
    }

    setCurrentImage();
    isToggle = widget.isToggle != null ? widget.isToggle! : isToggle;
    _action = widget.onTap;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(imagePressed.image, context);
    precacheImage(imageUnPressed.image, context);
    if (completeImage != null) {
      precacheImage(completeImage!.image, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setValue();

    return GestureDetector(
      onTap: _action,
      onTapCancel: () {
        setState(() {
          currentImage = imageUnPressed;
        });
      },
      onTapDown: (_) {
        setState(() {
          isClick = true;
          currentImage = imagePressed;
        });
      },
      onTapUp: (_) {
        setState(() {
          currentImage = imageUnPressed;
        });
      },
      child: Container(
        height: widget.height ?? imagePressed.height,
        width: widget.width ?? imagePressed.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: currentImage.image,
          ),
        ),
      ),
    );
  }

  void setCurrentImage() {
    if (isClick != true) {
      currentImage = imageUnPressed;
    } else {
      isClick = false;
    }
  }
}
