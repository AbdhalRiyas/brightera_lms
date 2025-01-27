import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/utils/format_price.dart';
import 'package:flutter/material.dart';

class CourseCardSubtitle extends StatelessWidget {
  const CourseCardSubtitle({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatPrice(course.salePrice),
          style: const TextStyle(
            fontSize: ThemeConstants.fontSizeSmall,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (course.regularPrice > 0)
          Text(
            formatPrice(course.regularPrice),
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              fontSize: ThemeConstants.fontSizeSmall,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
