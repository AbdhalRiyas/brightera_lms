import 'package:app/app/models/course.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key, required this.course});

  final Course? course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course?.title ?? ''),
      ),
      body: const Placeholder(),
    );
  }
}

class CourseScreenArguments {
  final Course course;

  CourseScreenArguments(this.course);
}
