import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: CircleAvatar(
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            'assets/icons/arrow-back.svg',
          ),
        ),
      ),
    );
  }
}
