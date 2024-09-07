import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/screens/courses/widgets/syllabus_accordion.dart';
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
            SyllabusAccordion(course: course)
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
