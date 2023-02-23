import 'package:flutter/material.dart';

class ToggleImageButton extends StatefulWidget {
  const ToggleImageButton({
    Key? key,
    required this.offImage,
    required this.onImage,
    required this.onTap,
    this.width,
    this.height,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final String offImage;
  final String onImage;
  final double? width;
  final double? height;
  final Function(bool) onTap;

  @override
  State<ToggleImageButton> createState() => ToggleImageButtonState();
}

class ToggleImageButtonState extends State<ToggleImageButton> {
  late Image onImage;
  late Image offImage;

  late Image currentImage;
  late Function(bool) _action;
  bool preloaded = false;
  bool isToggle = false;
  bool imageState = false;
  bool? isComplete = false;
  bool isClick = false;

  @override
  void initState() {
    _setValue();
    super.initState();
  }

  void _setValue() {
    onImage = Image.asset(widget.onImage);
    offImage = Image.asset(widget.offImage);

    setCurrentImage();
    _action = widget.onTap;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(onImage.image, context);
    precacheImage(offImage.image, context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setValue();

    return GestureDetector(
      onTap: () {
        setState(() {
          isClick = true;
          imageState = !imageState;
        });
        _action(imageState);
      },
      child: Container(
        height: widget.height ?? onImage.height,
        width: widget.width ?? onImage.width,
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

    if (imageState) {
      currentImage = onImage;
    } else {
      currentImage = offImage;
    }
  }
}
