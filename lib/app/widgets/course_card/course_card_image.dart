import 'package:app/app/config/theme_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CourseCardImage extends StatelessWidget {
  const CourseCardImage(
      {super.key, this.maxWidth, this.maxHeight, this.listMode = false});

  final double? maxWidth, maxHeight;
  final bool listMode;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: listMode
          ? BorderRadius.circular(
              ThemeConstants.borderRadiusSmall,
            )
          : const BorderRadius.only(
              topLeft: Radius.circular(
                ThemeConstants.borderRadiusLarge,
              ),
              topRight: Radius.circular(
                ThemeConstants.borderRadiusLarge,
              ),
            ),
      child: CachedNetworkImage(
        imageUrl: 'https://img-c.udemycdn.com/course/240x135/10971_da21_5.jpg',
        fit: BoxFit.cover,
        width: maxWidth,
        height: maxHeight != null ? maxHeight! * 0.50 : null,
      ),
    );
  }
}
