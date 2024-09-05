import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/screens/courses/all_courses_screen.dart';
import 'package:app/app/screens/courses/course_screen.dart';
import 'package:app/app/screens/featured_screen/widgets/courses/course_card.dart';
import 'package:flutter/material.dart';

class ListOfCourses extends StatefulWidget {
  const ListOfCourses({super.key, required this.subject});

  final Subject? subject;

  @override
  State<ListOfCourses> createState() => ListOfCoursesState();
}

class ListOfCoursesState extends State<ListOfCourses> {
  List<Course> _courses = [];
  final CourseRepository _repository = CourseRepository();

  @override
  void initState() {
    fetchCourses(widget.subject?.id ?? '');
    super.initState();
  }

  Future<void> fetchCourses(String subjectId) async {
    final courses = await _repository.getCoursesBySubject(subjectId, true);
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
                  itemBuilder: (context, i) => i == _courses.length
                      ? SizedBox(
                          width: constraints.maxWidth / 2,
                          child: TextButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/all-courses',
                              arguments:
                                  AllCoursesScreenArguments(widget.subject),
                            ),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    ThemeConstants.borderRadiusLarge),
                              ),
                            ),
                            child: const Text(
                              "See All",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/course',
                            arguments: CourseScreenArguments(_courses[i]),
                          ),
                          borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge),
                          child: CourseCard(
                            course: _courses[0],
                            maxWidth: constraints.maxWidth,
                            maxHeight: constraints.maxHeight,
                          ),
                        ),
                  separatorBuilder: (context, i) => const SizedBox(width: 10),
                  itemCount: _courses.length + 1,
                );
              }),
            );
          })
        : const Text(
            "No courses have been featured for this subject yet.",
          );
  }
}
