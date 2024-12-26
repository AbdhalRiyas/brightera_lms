import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<FilePickerResult?> pickPaymentProof(BuildContext context) async {
  try {
    // Prompt the user to pick a file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
      withData: false, // Avoid holding file data in memory
    );

    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) {
      // Show feedback if no file is selected
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No payment proof selected.'),
          backgroundColor: Colors.orange,
        ),
      );
      return null;
    }
    return result;
  } catch (e) {
    // Handle errors (e.g., permissions, file picker issues)
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error selecting payment proof: $e'),
        backgroundColor: Colors.red,
      ),
    );
    return null;
  }
}
