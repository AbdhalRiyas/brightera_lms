import 'package:app/src/config/theme_constants.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropShadow(
      blurRadius: 4,
      offset: const Offset(2, 2),
      color: ThemeConstants.primaryShadowColor,
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(2.0), // Reduce the size of the button
          minimumSize: const Size(40, 40), // Set minimum size
        ),
        icon: SvgPicture.asset(
          'assets/icons/arrow-back.svg',
          colorFilter: const ColorFilter.mode(
            ThemeConstants.primaryColor,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
