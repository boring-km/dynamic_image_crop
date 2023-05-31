class CropArea {

  CropArea(this.left, this.top, this.width, this.height);
  final double left;
  final double top;
  final double width;
  final double height;

  @override
  String toString() {
    return 'left: $left, top: $top, width: $width, height: $height';
  }
}
