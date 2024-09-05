import 'package:app/app/models/course.dart';
import 'package:app/app/models/subject.dart';
import 'package:app/app/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class AllCoursesScreen extends StatefulWidget {
  const AllCoursesScreen({super.key, required this.subject});

  final Subject? subject;

  @override
  State<AllCoursesScreen> createState() => _AllCoursesScreenState();
}

class _AllCoursesScreenState extends State<AllCoursesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Courses in ${widget.subject?.name}"),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, i) => CourseCard(
          listMode: true,
          course: const Course(
            id: 'dqd',
            title: 'Accounting in 60 Minutes - A Brief Introduction',
            description: 'qwdqwdqwd',
            price: 5000,
            subject: null,
          ),
          onTap: () {},
        ),
      ),
    );
  }
}

class AllCoursesScreenArguments {
  final Subject? subject;

  AllCoursesScreenArguments(this.subject);
}
