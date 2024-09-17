import 'package:flutter/material.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField({
    super.key,
    required TextEditingController descriptionController,
  }) : _descriptionController = descriptionController;

  final TextEditingController _descriptionController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _descriptionController,
      maxLines: null,
      maxLength: 300,
      decoration: const InputDecoration(labelText: "Description"),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
