// home_screen.dart
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/featured_screen/widgets/carousel.dart';
import 'package:app/src/screens/featured_screen/widgets/courses/courses.dart';
import 'package:app/src/screens/home/categories.dart';
import 'package:app/src/screens/home/popular_courses.dart';
import 'package:app/src/screens/notifications/notifications_screen.dart';
import 'package:app/src/services/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const WelcomeHeader(),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Carousel(),
                SizedBox(height: ThemeConstants.paddingSmall),
                FeaturedCourses(),
                SizedBox(height: ThemeConstants.paddingLarge),
                Categories(),
                SizedBox(height: ThemeConstants.paddingLarge),
                PopularCourses(),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: CustomBottomNavBar(),
    );
  }
}

// welcome_header.dart
class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthManager().getUserDetails(),
      builder: (context, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back!',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (AuthManager().userDetails != null)
                      Text(
                        "Hey, ${AuthManager().userDetails!['name']} 👋 ",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
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
            ),
    );
  }
}
