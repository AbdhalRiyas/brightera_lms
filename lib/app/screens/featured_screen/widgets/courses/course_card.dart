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
      decoration: BoxDecoration(
        color: ThemeConstants.lavenderMist, // Change this as needed
        borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
      ),
      child: Column(
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
            padding: const EdgeInsets.all(
              ThemeConstants.paddingSmall,
            ),
            child: Text(
              _course.title,
              maxLines: 3,
              style: const TextStyle(
                fontSize: ThemeConstants.fontSizeMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
