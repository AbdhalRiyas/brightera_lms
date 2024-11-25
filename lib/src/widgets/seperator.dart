import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';

class Seperator extends StatelessWidget {
  const Seperator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: ThemeConstants.borderSizeSmall,
            color: ThemeConstants.borderColor,
          ),
        ),
      ),
    );
  }
}
