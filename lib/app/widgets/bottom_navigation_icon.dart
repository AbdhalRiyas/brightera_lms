import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavigationIcon extends StatelessWidget {
  final String path;
  final bool isActive;
  final bool hasNotes;

  const BottomNavigationIcon({
    super.key,
    required this.path,
    required this.isActive,
    this.hasNotes = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SvgPicture.asset(
          path,
          colorFilter: ColorFilter.mode(
              isActive ? Colors.black : Colors.black54, BlendMode.srcIn),
        ),
        if (hasNotes)
          const Positioned(
            top: 0,
            right: 0,
            child: CircleAvatar(
              maxRadius: 5,
              backgroundColor: ThemeConstants.primaryColor,
            ),
          ),
      ],
    );
  }
}
