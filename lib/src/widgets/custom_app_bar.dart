import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/announcements/announcements.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          "assets/images/logo.svg",
          width: 120,
          colorFilter: ColorFilter.mode(
            Theme.of(context).primaryColor,
            BlendMode.srcIn,
          ),
        ),
        DropShadow(
          blurRadius: 4,
          spread: 0,
          offset: const Offset(2, 2),
          color: ThemeConstants.primaryShadowColor,
          child: IconButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Announcements(),
                ),
              );
              // await FirebaseService().sendNotificationToAll(
              //   'New Announcement',
              //   'Check out the latest announcement',
              // );
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              width: 40,
              height: 40,
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: OvalBorder(),
              ),
              child: SvgPicture.asset(
                'assets/icons/Megaphone.svg',
                // color: ThemeConstants.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
