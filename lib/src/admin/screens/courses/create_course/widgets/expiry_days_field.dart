import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpiryDaysField extends StatelessWidget {
  const ExpiryDaysField({
    super.key,
    required TextEditingController expiresInDaysController,
  }) : _expiresInDaysController = expiresInDaysController;

  final TextEditingController _expiresInDaysController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _expiresInDaysController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: const InputDecoration(
        labelText: "Expires in Days",
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a number';
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
