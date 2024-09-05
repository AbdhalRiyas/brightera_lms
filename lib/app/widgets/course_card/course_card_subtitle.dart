import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/utils/format_price.dart';
import 'package:flutter/material.dart';

class CourseCardSubtitle extends StatelessWidget {
  const CourseCardSubtitle({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (course.durationInHours != null)
          Text(
            "${course.durationInHours} Hours",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: ThemeConstants.fontSizeSmall * 0.80,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        Text.rich(
          TextSpan(
            text: formatPrice(course.salePrice),
            style: const TextStyle(
              fontSize: ThemeConstants.fontSizeSmall,
              fontWeight: FontWeight.w600,
            ),
            children: course.regularPrice > 0
                ? [
                    const TextSpan(
                      text: "  ", // Add space
                      style: TextStyle(
                        fontSize: ThemeConstants.fontSizeSmall,
                      ),
                    ),
                    TextSpan(
                      text: formatPrice(course.regularPrice),
                      style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: ThemeConstants.fontSizeSmall,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    )
                  ]
                : null,
          ),
        ),
      ],
    );
  }
}
