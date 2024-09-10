import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationIcon extends StatelessWidget {
  final String path;
  final bool isActive;

  const BottomNavigationIcon({
    super.key,
    required this.path,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      colorFilter: ColorFilter.mode(
          isActive ? Colors.black : Colors.black54, BlendMode.srcIn),
    );
  }
}
