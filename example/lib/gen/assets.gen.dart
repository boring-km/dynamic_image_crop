/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $ImagesGen {
  const $ImagesGen();

  /// File path: images/camera_btn_back_nor.webp
  AssetGenImage get cameraBtnBackNor =>
      const AssetGenImage('images/camera_btn_back_nor.webp');

  /// File path: images/camera_btn_back_pre.webp
  AssetGenImage get cameraBtnBackPre =>
      const AssetGenImage('images/camera_btn_back_pre.webp');

  /// File path: images/camera_btn_rotate_nor.webp
  AssetGenImage get cameraBtnRotateNor =>
      const AssetGenImage('images/camera_btn_rotate_nor.webp');

  /// File path: images/camera_btn_rotate_pre.webp
  AssetGenImage get cameraBtnRotatePre =>
      const AssetGenImage('images/camera_btn_rotate_pre.webp');

  /// File path: images/camera_btn_shutter_nor.webp
  AssetGenImage get cameraBtnShutterNor =>
      const AssetGenImage('images/camera_btn_shutter_nor.webp');

  /// File path: images/camera_btn_shutter_pre.webp
  AssetGenImage get cameraBtnShutterPre =>
      const AssetGenImage('images/camera_btn_shutter_pre.webp');

  /// File path: images/m_book_btn_cancel.png
  AssetGenImage get mBookBtnCancel =>
      const AssetGenImage('images/m_book_btn_cancel.png');

  /// File path: images/m_book_btn_cancel_over_selected.webp
  AssetGenImage get mBookBtnCancelOverSelected =>
      const AssetGenImage('images/m_book_btn_cancel_over_selected.webp');

  /// File path: images/m_book_btn_circle.png
  AssetGenImage get mBookBtnCircle =>
      const AssetGenImage('images/m_book_btn_circle.png');

  /// File path: images/m_book_btn_circle_selected.png
  AssetGenImage get mBookBtnCircleSelected =>
      const AssetGenImage('images/m_book_btn_circle_selected.png');

  /// File path: images/m_book_btn_drawing.png
  AssetGenImage get mBookBtnDrawing =>
      const AssetGenImage('images/m_book_btn_drawing.png');

  /// File path: images/m_book_btn_drawing_selected.png
  AssetGenImage get mBookBtnDrawingSelected =>
      const AssetGenImage('images/m_book_btn_drawing_selected.png');

  /// File path: images/m_book_btn_imgcrop_save.png
  AssetGenImage get mBookBtnImgcropSave =>
      const AssetGenImage('images/m_book_btn_imgcrop_save.png');

  /// File path: images/m_book_btn_imgcrop_save_selected.webp
  AssetGenImage get mBookBtnImgcropSaveSelected =>
      const AssetGenImage('images/m_book_btn_imgcrop_save_selected.webp');

  /// File path: images/m_book_btn_nemo.png
  AssetGenImage get mBookBtnNemo =>
      const AssetGenImage('images/m_book_btn_nemo.png');

  /// File path: images/m_book_btn_nemo_selected.png
  AssetGenImage get mBookBtnNemoSelected =>
      const AssetGenImage('images/m_book_btn_nemo_selected.png');

  /// File path: images/m_book_btn_triangle.png
  AssetGenImage get mBookBtnTriangle =>
      const AssetGenImage('images/m_book_btn_triangle.png');

  /// File path: images/m_book_btn_triangle_selected.png
  AssetGenImage get mBookBtnTriangleSelected =>
      const AssetGenImage('images/m_book_btn_triangle_selected.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        cameraBtnBackNor,
        cameraBtnBackPre,
        cameraBtnRotateNor,
        cameraBtnRotatePre,
        cameraBtnShutterNor,
        cameraBtnShutterPre,
        mBookBtnCancel,
        mBookBtnCancelOverSelected,
        mBookBtnCircle,
        mBookBtnCircleSelected,
        mBookBtnDrawing,
        mBookBtnDrawingSelected,
        mBookBtnImgcropSave,
        mBookBtnImgcropSaveSelected,
        mBookBtnNemo,
        mBookBtnNemoSelected,
        mBookBtnTriangle,
        mBookBtnTriangleSelected
      ];
}

class Assets {
  Assets._();

  static const $ImagesGen images = $ImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
