import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  print("No image selectd");
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
}

Future<List<XFile>> pickImages(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? images = await imagePicker.pickMultiImage();

  return images;
}
