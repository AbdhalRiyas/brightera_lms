import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Container(
        padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: ThemeConstants.primaryShadowColor,
              blurRadius: 10,
            ),
          ],
        ),
        child: SvgPicture.asset(
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
