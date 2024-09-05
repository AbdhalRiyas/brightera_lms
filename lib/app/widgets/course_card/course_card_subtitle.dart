import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';

class CourseCardSubtitle extends StatelessWidget {
  const CourseCardSubtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
    );
  }
}
