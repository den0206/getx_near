import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImageExtention {
  static Future<File?> pickSingleImage(BuildContext context) async {
    final config = AssetPickerConfig(
      maxAssets: 1,
      requestType: RequestType.image,
    );
    final List<AssetEntity>? result =
        await AssetPicker.pickAssets(context, pickerConfig: config);

    if (result == null || result.isEmpty) return null;

    final File? temp = await result.first.file;
    final compressed = await _compressImage(temp);
    return compressed;
  }

  static Future<File?> _compressImage(File? file) async {
    if (file == null) return null;
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(new RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";

    final compressedImage = await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      quality: 40,
    );

    return compressedImage;
  }
}
