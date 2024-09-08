import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/screens/courses/widgets/course_cover.dart';
import 'package:app/app/widgets/syllabus/syllabus_accordion.dart';
import 'package:app/app/screens/lectures_screen/lectures_screen.dart';
import 'package:app/app/utils/format_price.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    bool hasActiveSubscription = true;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
        child: ListView(
          children: [
            CourseCover(course: course),
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
              onPressed: () => Navigator.pushNamed(context, '/lectures',
                  arguments: LecturesArguments(course: course)),
              style: ElevatedButton.styleFrom(
                overlayColor: ThemeConstants.accentColor,
                backgroundColor: ThemeConstants.primaryButtonColor,
                elevation: 0,
              ),
              child: Text(
                hasActiveSubscription == true ? "Go to lectures" : "Buy Now",
                style: const TextStyle(
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
