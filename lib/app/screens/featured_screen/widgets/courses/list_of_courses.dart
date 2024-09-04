import 'package:app/app/models/course.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/screens/course_screen/course_screen.dart';
import 'package:app/app/screens/featured_screen/widgets/courses/course_card.dart';
import 'package:flutter/material.dart';

class ListOfCourses extends StatefulWidget {
  const ListOfCourses({super.key, required this.subjectId});

  final String subjectId;

  @override
  State<ListOfCourses> createState() => ListOfCoursesState();
}

class ListOfCoursesState extends State<ListOfCourses> {
  List<Course> _courses = [];
  final CourseRepository _repository = CourseRepository();

  @override
  void initState() {
    fetchCourses(widget.subjectId);
    super.initState();
  }

  Future<void> fetchCourses(String subjectId) async {
    final courses = await _repository.getCoursesBySubject(subjectId);
    setState(() {
      _courses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _courses.isNotEmpty
        ? Builder(builder: (context) {
            return SizedBox(
              height: 200,
              child: LayoutBuilder(builder: (context, constraints) {
                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/course',
                      arguments: CourseScreenArguments(_courses[i]),
                    ),
                    child: CourseCard(
                      course: _courses[i],
                      maxWidth: constraints.maxWidth,
                      maxHeight: constraints.maxHeight,
                    ),
                  ),
                  separatorBuilder: (context, i) => const SizedBox(width: 10),
                  itemCount: _courses.length,
                );
              }),
            );
          })
        : const Text("No Courses Have Been Added For This Subject");
  }
}
