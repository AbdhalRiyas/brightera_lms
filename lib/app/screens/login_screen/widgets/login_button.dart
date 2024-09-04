import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const LoginButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ThemeConstants.primaryButtonColor,
        foregroundColor: ThemeConstants.primaryButtonTextColor,
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: onPressed,
      child: const Text("Login"),
    );
  }
}
