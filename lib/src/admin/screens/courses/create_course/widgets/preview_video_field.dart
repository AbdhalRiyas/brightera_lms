import 'package:flutter/material.dart';

class PreviewVideoField extends StatelessWidget {
  const PreviewVideoField({
    super.key,
    required TextEditingController previewVideoController,
  }) : _previewVideoController = previewVideoController;

  final TextEditingController _previewVideoController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _previewVideoController,
      maxLength: 60,
      decoration: const InputDecoration(labelText: "Preview Video (Youtube)"),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      validator: (value) {
        // Updated YouTube URL regex with optional www
        const urlPattern =
            r'^(https?\:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$';
        final regExp = RegExp(urlPattern);

        if (value == null || value.isEmpty) {
          return 'Please enter a YouTube URL';
        } else if (!regExp.hasMatch(value)) {
          return 'Please enter a valid YouTube URL';
        }
        return null; // If valid, return null (no error)
      },
    );
  }
}
