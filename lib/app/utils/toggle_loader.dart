import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';

void showLoader(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: ThemeConstants.paddingMedium),
            Text(
              "Processing please wait...",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

void hideLoader(BuildContext context) => Navigator.pop(context);
