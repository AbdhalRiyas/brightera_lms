// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<FilePickerResult?> pickSubjectIcon(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['svg'], // Restrict to SVG files
  );

  if ((result == null || result.files.single.extension != 'svg')) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No .svg icon selected.'),
        backgroundColor: Colors.red,
      ),
    );
  } else {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New icon has been selected.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  return result;
}
