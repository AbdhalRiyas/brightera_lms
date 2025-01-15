import 'package:flutter/material.dart';

class CourseCardTitle extends StatelessWidget {
  const CourseCardTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 2,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontSize: 14,
        overflow: TextOverflow.ellipsis,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
