import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/utils/format_price.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
        child: ListView(
          children: [
            InkWell(
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusMedium),
              onTap: () {
                print('wdwd');
              },
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(ThemeConstants.borderRadiusMedium),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: course.image,
                      width: double.maxFinite,
                      fit: BoxFit.fill,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/play-filled.svg',
                              height: 50,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                                height: ThemeConstants.paddingMedium),
                            Text(
                              "Preview this course",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    BoxShadow(
                                        offset: const Offset(1, 1),
                                        blurRadius: 10,
                                        spreadRadius: 10,
                                        color: Colors.grey.shade500),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: ThemeConstants.paddingSmall),
            Text(
              course.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: ThemeConstants.paddingSmall),
            Text(
              course.description,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: ThemeConstants.paddingSmall),
            Text(
              formatPrice(course.salePrice),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: ThemeConstants.paddingSmall),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                overlayColor: ThemeConstants.accentColor,
                backgroundColor: ThemeConstants.primaryButtonColor,
                elevation: 0,
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeConstants.primaryButtonTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: ThemeConstants.paddingLarge),
            const Text(
              "Syllabus",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Accordion(
              paddingListTop: 0,
              contentVerticalPadding: ThemeConstants.paddingSmall,
              disableScrolling: true,
              rightIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 22,
              ),
              headerBorderRadius: ThemeConstants.borderRadiusSmall,
              headerBorderWidth: 0,
              paddingListHorizontal: 0,
              headerBorderColorOpened: Colors.transparent,
              headerBackgroundColor: Colors.transparent,
              headerBackgroundColorOpened: Colors.transparent,
              contentBackgroundColor: Colors.transparent,
              contentBorderWidth: 0,
              contentHorizontalPadding: 0,
              scaleWhenAnimating: false,
              openAndCloseAnimation: true,
              headerPadding: const EdgeInsets.symmetric(vertical: 7),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              maxOpenSections: 100,
              children: [
                AccordionSection(
                  isOpen: true,
                  contentVerticalPadding: ThemeConstants.paddingSmall,
                  header: const Text(
                    'Section 1 - Introduction',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: const Text(
                          "1",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        title: const Text(
                          "Had better (Learn)",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          "Video - 02:24 mins",
                          style: TextStyle(fontSize: 11),
                        ),
                        contentPadding: const EdgeInsets.only(
                            left: ThemeConstants.paddingLarge),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_circle_outline_sharp,
                            color: ThemeConstants.primaryButtonColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AccordionSection(
                  contentVerticalPadding: ThemeConstants.paddingSmall,
                  header: const Text(
                    'Section 2 - Physics',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: Text("1"),
                        title: Text(
                          "qdqwd",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CourseScreenArguments {
  final Course course;

  CourseScreenArguments(this.course);
}
