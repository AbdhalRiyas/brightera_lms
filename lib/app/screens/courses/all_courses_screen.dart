import 'package:app/app/models/subject.dart';
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
      body: const Placeholder(),
    );
  }
}

class AllCoursesScreenArguments {
  final Subject? subject;

  AllCoursesScreenArguments(this.subject);
}
