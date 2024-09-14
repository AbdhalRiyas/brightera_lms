import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/screens/featured_screen/widgets/carousel.dart';
import 'package:app/app/widgets/custom_app_bar.dart';
import 'package:app/app/screens/featured_screen/widgets/courses/courses.dart';
import 'package:flutter/material.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Carousel(),
              Padding(
                padding: EdgeInsets.all(ThemeConstants.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Featured Courses",
                      style: ThemeConstants.headingStyle,
                    ),
                    SizedBox(height: 10),
                    FeaturedCourses(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
