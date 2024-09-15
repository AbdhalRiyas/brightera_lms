import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CourseDurationField extends StatelessWidget {
  const CourseDurationField({
    super.key,
    required TextEditingController durationController,
  }) : _durationController = durationController;

  final TextEditingController _durationController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _durationController,
      maxLength: 6,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(
            r'^\d*\.?\d{0,2}')), // Allows numbers with up to 2 decimal places
      ],
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(labelText: "Duration (Hours)"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter course duration';
        }
        return null;
      },
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
