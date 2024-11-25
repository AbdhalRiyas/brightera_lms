import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';

class CourseCardTitle extends StatelessWidget {
  const CourseCardTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: ThemeConstants.fontSizeSmall,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
