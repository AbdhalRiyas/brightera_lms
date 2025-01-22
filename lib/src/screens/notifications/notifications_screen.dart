import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/widgets/app_bar_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: const AppBarBackButton(),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          return const NotificationCard(
            leadingIcon: 'assets/icons/bell.svg',
            title: 'New Course Available',
            subtitle:
                'Flutter for Beginners. Start learning now! and get 50% off, Hurry up!',
            time: '2 hours ago',
            trailingImage: 'assets/images/books.png',
          );
        },
        itemCount: 5,
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.leadingIcon,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.trailingImage,
  });

  final String leadingIcon;
  final String title;
  final String subtitle;
  final String time;
  final String trailingImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeConstants.primaryShadowColor,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
                margin: const EdgeInsets.all(8),
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  leadingIcon,
                  colorFilter: const ColorFilter.mode(
                    ThemeConstants.primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 220),
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.all(16),
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusLarge),
              color: Colors.white,
            ),
            // child: Image.asset(
            //   trailingImage,
            //   fit: BoxFit.fill,
            // ),
          ),
        ],
      ),
    );
  }
}
