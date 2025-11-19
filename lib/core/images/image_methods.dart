import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hawiah_client/core/custom_widgets/choose_gallery_or_camera_bottom_sheet.dart';
import 'package:hawiah_client/core/utils/navigator_methods.dart';
import 'package:image_picker/image_picker.dart';

class ImageMethods {
  static Future<void> pickImage({
    required ImageSource source,
    required void Function(File) onSuccess,
  }) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      File result = File(pickedImage.path);
      onSuccess.call(result);
    }
  }

  static Future<void> pickMultiImage({
    required void Function(List<File>) onSuccess,
  }) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImage = await picker.pickMultiImage();
    final List<File> result = pickedImage.map((e) => File(e.path)).toList();
    onSuccess.call(result);
  }

  static void pickImageBottomSheet(
    BuildContext context, {
    required void Function(File) onSuccess,
  }) {
    NavigatorMethods.showAppBottomSheet(
      context,
      ChooseGalleryOrCameraBottomSheet(
        onCamera: () => ImageMethods.pickImage(
          source: ImageSource.camera,
          onSuccess: onSuccess,
        ),
        onGallery: () => ImageMethods.pickImage(
          source: ImageSource.gallery,
          onSuccess: onSuccess,
        ),
      ),
    );
  }

  static Future<void> pickFile({
    required void Function(File) onSuccess,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      onSuccess.call(file);
    }
  }
}
