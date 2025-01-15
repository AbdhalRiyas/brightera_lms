import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: SvgPicture.asset('assets/icons/arrow-back.svg'),
      onPressed: () => Navigator.pop(context),
    );
  }
}
