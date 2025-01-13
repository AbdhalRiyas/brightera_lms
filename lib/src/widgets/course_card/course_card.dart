import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/widgets/course_card/course_card_image.dart';
import 'package:app/src/widgets/course_card/course_card_subtitle.dart';
import 'package:app/src/widgets/course_card/course_card_title.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required Course course,
    this.maxWidth,
    this.maxHeight,
    this.listMode = false,
    this.onTap,
    this.trailing,
  }) : _course = course;

  final double? maxWidth, maxHeight;
  final Course _course;
  final bool listMode;
  final VoidCallback? onTap;
  final Widget? trailing;

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
              trailing: trailing,
            )
          : InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusLarge),
              child: Card(
                elevation: ThemeConstants.cardElevation,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
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
              ),
            ),
    );
  }
}
