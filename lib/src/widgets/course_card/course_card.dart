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
    this.backgroundColor,
    this.isEnrolled = false,
    this.isActive = false,
    this.progress,
    this.expiresAt,
  }) : _course = course;

  final double? maxWidth, maxHeight;
  final Course _course;
  final bool listMode;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? backgroundColor;
  final bool isEnrolled;
  final bool? isActive;
  final double? progress;
  final int? expiresAt;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: maxWidth != null ? maxWidth! / 2 : double.maxFinite,
      duration: const Duration(milliseconds: 300),
      // decoration: listMode
      //     ? const BoxDecoration(
      //         border: Border(
      //           bottom: BorderSide(
      //             width: ThemeConstants.borderSizeSmall,
      //             color: ThemeConstants.borderColor,
      //           ),
      //         ),
      //       )
      //     : null,
      child: listMode
          ?
          //  ListTile(
          //     onTap: onTap,
          //     leading: CourseCardImage(
          //       imageUrl: _course.image,
          //       maxHeight: listMode ? 100 : maxHeight,
          //       maxWidth: listMode ? 50 : maxWidth,
          //       listMode: true,
          //     ),
          //     title: CourseCardTitle(title: _course.title),
          //     subtitle: CourseCardSubtitle(course: _course),
          //     trailing: trailing,
          //   )
          Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: ThemeConstants.primaryShadowColor,
              color: backgroundColor ?? Colors.white,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CourseCardImage(
                        imageUrl: _course.image,
                        maxHeight: listMode ? 180 : maxHeight,
                        maxWidth: listMode ? 110 : maxWidth,
                        listMode: true,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CourseCardTitle(title: _course.title),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "by Mohamed",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withAlpha(150),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _course.durationInHours != null
                                        ? '${_course.durationInHours} hours'
                                        : '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black.withAlpha(150),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              isEnrolled
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                ThemeConstants.paddingSmall,
                                            vertical:
                                                ThemeConstants.paddingSmall / 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isActive!
                                                ? Colors.green.withAlpha(50)
                                                : Colors.red.withAlpha(50),
                                            borderRadius: BorderRadius.circular(
                                              ThemeConstants.borderRadiusSmall,
                                            ),
                                          ),
                                          child: Text(
                                            isActive! ? 'Active' : 'Expired',
                                            style: TextStyle(
                                              color: isActive!
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          expiresAt! > 0
                                              ? "Expires in $expiresAt days"
                                              : "Expired ${expiresAt! * -1} days ago",
                                          style: TextStyle(
                                            color: Colors.black.withAlpha(150),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    )
                                  : CourseCardSubtitle(course: _course),
                            ],
                          ),
                        ),
                      ),
                      isEnrolled
                          ? SizedBox(
                              width: 40,
                              height: 40,
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.grey[200],
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      ThemeConstants.primaryColor,
                                    ),
                                    strokeWidth: 4,
                                  ),
                                  Center(
                                    child: Text(
                                      '${(progress! * 100).toInt()}%',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : trailing ?? Container()
                    ],
                  ),
                ),
              ),
            )
          : InkWell(
              onTap: onTap,
              borderRadius:
                  BorderRadius.circular(ThemeConstants.borderRadiusLarge),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    ThemeConstants.borderRadiusLarge,
                  ),
                ),
                elevation: 2,
                shadowColor: const Color.fromARGB(70, 0, 0, 0),
                semanticContainer: true,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                          child: CourseCardImage(
                            imageUrl: _course.image,
                            maxHeight: maxHeight,
                            maxWidth: maxWidth,
                          ),
                        ),
                        const SizedBox(height: ThemeConstants.paddingSmall),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Subject",
                                    style: TextStyle(
                                      fontSize: ThemeConstants.fontSizeSmall,
                                      color: ThemeConstants.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    _course.durationInHours != null
                                        ? '${_course.durationInHours} hours'
                                        : '',
                                    style: TextStyle(
                                      fontSize: ThemeConstants.fontSizeSmall,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withAlpha(100),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: ThemeConstants.paddingSmall / 2,
                              ),
                              CourseCardTitle(title: _course.title),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Divider(
                          height: 0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 4),
                          child: CourseCardSubtitle(course: _course),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
