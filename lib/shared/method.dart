import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> selectImageByGallery() async {
  XFile? selectedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);

  return selectedImage;
}

Future<XFile?> selectImageByCamera() async {
  XFile? selectedImage =
      await ImagePicker().pickImage(source: ImageSource.camera);

  return selectedImage;
}

void showCustomSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
