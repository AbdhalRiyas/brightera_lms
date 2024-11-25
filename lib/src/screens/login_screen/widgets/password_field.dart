import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({
    super.key,
    required TextEditingController passwordController,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: ThemeConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(
          ThemeConstants.borderRadiusLarge * 2,
        ),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          hintText: 'Password',
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }
}
