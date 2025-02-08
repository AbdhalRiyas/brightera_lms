import 'package:app/src/screens/notifications/notifications_screen.dart';
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
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
                // NotificationService().showNotification(
                //   title: 'Test',
                //   body: 'This is a test notification',
                // );
              },
              icon: Container(
                padding: const EdgeInsets.all(6),
                width: 36,
                height: 36,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: OvalBorder(),
                  shadows: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/icons/bell.svg',
                  // color: ThemeConstants.primaryColor,
                ),
              ),
            ),
            // IconButton(
            //   onPressed: () {},
            //   icon: CircleAvatar(
            //     radius: 25,
            //     backgroundImage: Image.asset(
            //       'assets/images/profile-avatar.png',
            //     ).image,
            //   ),
            // ),
          ],
        ),
      ],
    );
  }
}
