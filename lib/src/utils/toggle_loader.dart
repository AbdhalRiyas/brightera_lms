import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';

void showLoader(BuildContext context,
        [String label = "Processing please wait..."]) =>
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: ThemeConstants.paddingMedium),
            Text(
              label,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

void hideLoader(BuildContext context) => Navigator.pop(context);
