import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required Course course,
    required this.maxWidth,
    required this.maxHeight,
  }) : _course = course;

  final double maxWidth, maxHeight;

  final Course _course;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: maxWidth / 2,
      duration: const Duration(milliseconds: 300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                ThemeConstants.borderRadiusLarge,
              ),
              topRight: Radius.circular(
                ThemeConstants.borderRadiusLarge,
              ),
            ),
            child: CachedNetworkImage(
              imageUrl:
                  'https://img-c.udemycdn.com/course/240x135/10971_da21_5.jpg',
              fit: BoxFit.cover,
              width: maxWidth,
              height: maxHeight * 0.50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: ThemeConstants.paddingSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "${_course.title} ${_course.title} ${_course.title}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: ThemeConstants.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Text(
                  "30 Hours",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: ThemeConstants.fontSizeSmall * 0.80,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const Text.rich(
                  TextSpan(
                    text: "Rs.3000",
                    style: TextStyle(
                      fontSize: ThemeConstants.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                    ),
                    children: [
                      TextSpan(
                        text: "  ", // Add space
                        style: TextStyle(
                          fontSize: ThemeConstants.fontSizeSmall,
                        ),
                      ),
                      TextSpan(
                        text: "Rs.5000",
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: ThemeConstants.fontSizeSmall,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
