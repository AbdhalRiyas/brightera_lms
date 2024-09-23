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
    return DecoratedBox(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 50,
            color: ThemeConstants.primaryShadowColor,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: const Text("Login or Register"),
      ),
    );
  }
}
