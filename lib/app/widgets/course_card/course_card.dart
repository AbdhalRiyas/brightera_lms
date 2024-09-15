import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/widgets/course_card/course_card_image.dart';
import 'package:app/app/widgets/course_card/course_card_subtitle.dart';
import 'package:app/app/widgets/course_card/course_card_title.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required Course course,
    this.maxWidth,
    this.maxHeight,
    this.listMode = false,
    this.onTap,
  }) : _course = course;

  final double? maxWidth, maxHeight;
  final Course _course;
  final bool listMode;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: maxWidth != null ? maxWidth! / 2 : double.maxFinite,
      duration: const Duration(milliseconds: 300),
      decoration: listMode
          ? const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: ThemeConstants.borderSizeSmall,
                  color: ThemeConstants.borderColor,
                ),
              ),
            )
          : null,
      child: listMode
          ? ListTile(
              onTap: onTap,
              leading: CourseCardImage(
                imageUrl: _course.image,
                maxHeight: listMode ? 100 : maxHeight,
                maxWidth: listMode ? 50 : maxWidth,
                listMode: true,
              ),
              title: CourseCardTitle(title: _course.title),
              subtitle: CourseCardSubtitle(course: _course),
            )
          : InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CourseCardImage(
                    imageUrl: _course.image,
                    maxHeight: maxHeight,
                    maxWidth: maxWidth,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: ThemeConstants.paddingSmall,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CourseCardTitle(title: _course.title),
                        CourseCardSubtitle(course: _course),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
