// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<FilePickerResult?> pickCourseCover(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowCompression: true,
    compressionQuality: 80,
  );

  if (result == null) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No cover picture selected.'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cover picture has has been selected.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  return result;
}
