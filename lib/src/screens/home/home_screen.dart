// home_screen.dart
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/featured_screen/widgets/carousel.dart';
import 'package:app/src/screens/featured_screen/widgets/courses/courses.dart';
import 'package:app/src/screens/home/categories.dart';
import 'package:app/src/screens/home/popular_courses.dart';
import 'package:app/src/services/youtube_service.dart';
import 'package:app/src/widgets/custom_app_bar.dart';
import 'package:app/src/widgets/youtube_custom_player.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        appBar: AppBar(
          title: const CustomAppBar(),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Carousel(),
                  TextButton(
                      onPressed: () async {
                        final videoService = YouTubeService();
                        final urls = await videoService
                            .getVideoAndAudioUrls('XMrZO7hH6sw');

                        if (urls['videoUrl'] != null &&
                            urls['audioUrl'] != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiStreamPlayer(
                                videoUrl: urls['videoUrl']!,
                                audioUrl: urls['audioUrl']!,
                              ),
                            ),
                          );
                        } else {
                          print("Video or audio URL is null");
                        }
                      },
                      child: Text('Plat')),
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
      ),
    );
  }
}
