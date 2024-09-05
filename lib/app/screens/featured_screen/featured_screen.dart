import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/screens/featured_screen/widgets/carousel.dart';
import 'package:app/app/screens/featured_screen/widgets/custom_app_bar.dart';
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Carousel(),
            Padding(
              padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Courses",
                    style: ThemeConstants.headingStyle,
                  ),
                  const SizedBox(height: 10), // Add spacing if needed
                  const Courses(),
                  const SizedBox(height: 10), // Add spacing if needed
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/lectures'),
                    child: const Text("Show lectures"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
