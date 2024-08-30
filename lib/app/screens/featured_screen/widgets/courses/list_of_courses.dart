import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/screens/course_screen/course_screen.dart';
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
        ? SizedBox(
            height: 150,
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
                  child: AnimatedContainer(
                    width: constraints.maxWidth / 2,
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color:
                          ThemeConstants.lavenderMist, // Change this as needed
                      borderRadius: BorderRadius.circular(
                          ThemeConstants.borderRadiusLarge * 2),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(ThemeConstants.paddingLarge),
                      child: Text(
                        _courses[i].title,
                        maxLines: 3,
                        style: const TextStyle(
                          fontSize: ThemeConstants.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                separatorBuilder: (context, i) => const SizedBox(
                  width: 10,
                ),
                itemCount: _courses.length,
              );
            }),
          )
        : const Text(
            "No Courses Have Been Added For This Subject",
          );
  }
}
