import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageExtention {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File> selectImage({required ImageSource imageSource}) async {
    final XFile? _image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    print(_image);

    if (_image == null) {
      throw Exception("Not Get Image");
    } else {
      return File(_image.path);
    }
  }
}
