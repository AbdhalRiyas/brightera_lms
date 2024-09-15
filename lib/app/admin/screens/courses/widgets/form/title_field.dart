import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  const TitleField({
    super.key,
    required TextEditingController titleController,
  }) : _titleController = titleController;

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _titleController,
      maxLength: 70,
      decoration: const InputDecoration(
        labelText: "Course Title",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a Course Title';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
