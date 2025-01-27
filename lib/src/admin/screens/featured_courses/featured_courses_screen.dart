import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

class FeaturedCoursesScreen extends StatefulWidget {
  const FeaturedCoursesScreen({super.key});

  @override
  State<FeaturedCoursesScreen> createState() => _FeaturedCoursesScreenState();
}

class _FeaturedCoursesScreenState extends State<FeaturedCoursesScreen> {
  List<Course> _courses = [];
  List<String> _selectedCourseIds = [];

  Future<void> fetchCourses() async {
    final courses = await CourseRepository().getCourses();
    setState(() {
      _courses = courses;
    });
  }

  Future<void> fetchFeaturedCourses() async {
    final featuredCourses = await CourseRepository().getHomeCourseIds(
      "featuredCourses",
    );
    setState(() {
      _selectedCourseIds = featuredCourses;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCourses();
    fetchFeaturedCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Featured Courses'),
      ),
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
              "featuredCourses",
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
