import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/user.dart';
import 'package:app/app/repositories/user_repository.dart';
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
        backgroundColor: ThemeConstants.backgroundColor,
        body: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Image.asset(
                "assets/images/hero.webp",
                fit: BoxFit.fill,
                height: constraints.maxHeight * 0.50,
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.50 - 50,
                        child: const Column(
                          children: [
                            CustomAppBar(),
                            Carousel(),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.all(ThemeConstants.paddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Courses",
                              style: ThemeConstants.headingStyle,
                            ),
                            const Courses(),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text("Show lectures")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
