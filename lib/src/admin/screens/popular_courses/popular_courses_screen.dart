import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

class PopularCoursesScreen extends StatefulWidget {
  const PopularCoursesScreen({super.key});

  @override
  State<PopularCoursesScreen> createState() => _PopularCoursesScreenState();
}

class _PopularCoursesScreenState extends State<PopularCoursesScreen> {
  List<Course> _courses = [];
  List<String> _selectedCourseIds = [];

  Future<void> fetchCourses() async {
    final courses = await CourseRepository().getCourses();
    setState(() {
      _courses = courses;
    });
  }

  Future<void> fetchPopularCourses() async {
    final popularCourses = await CourseRepository().getHomeCourseIds(
      "popularCourses",
    );
    setState(() {
      _selectedCourseIds = popularCourses;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
    fetchPopularCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Courses'),
      ),
      // all courses with a check box with a search bar
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, i) {
          final course = _courses[i];
          return CheckboxListTile(
            title: Text(course.title),
            value: _selectedCourseIds.contains(course.id),
            onChanged: (value) {
              setState(() {
                if (value!) {
                  _selectedCourseIds.add(course.id);
                } else {
                  _selectedCourseIds.remove(course.id);
                }
              });
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () async {
            Result result = await CourseRepository().updateHomeCourses(
              _selectedCourseIds,
              "popularCourses",
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.data ?? result.error),
                backgroundColor: result.isSuccess ? Colors.green : Colors.red,
              ),
            );
            result.isSuccess ? Navigator.pop(context) : null;
          },
          child: const Text('Save'),
        ),
      ),
    );
  }
}
