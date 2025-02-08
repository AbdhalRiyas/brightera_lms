// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<FilePickerResult?> pickImage(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowCompression: true,
    compressionQuality: 80,
  );

  if (result == null) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No picture selected.'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Picture has has been selected.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  return result;
}
