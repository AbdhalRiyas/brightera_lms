import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/screens/featured_screen/widgets/carousel.dart';
import 'package:app/app/screens/featured_screen/widgets/list_of_subjects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeaturedScreen extends StatefulWidget {
  const FeaturedScreen({super.key});

  @override
  State<FeaturedScreen> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends State<FeaturedScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
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
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: ThemeConstants.paddingSmall),
                                  child: Image.asset(
                                    'assets/images/logo.webp',
                                    height:
                                        24.0, // Adjust this height as needed
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/icons/notification.svg',
                                        colorFilter: ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: SvgPicture.asset(
                                        'assets/icons/search.svg',
                                        colorFilter: ColorFilter.mode(
                                          Colors.black,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Carousel(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(ThemeConstants.paddingSmall),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Courses",
                              style: ThemeConstants.headingStyle,
                            ),
                            ListOfSubjects(),
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
