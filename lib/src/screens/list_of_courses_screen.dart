import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/models/subject.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/screens/courses/course_screen.dart';
import 'package:app/src/widgets/app_bar_icon.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ListOfCoursesScreen extends StatefulWidget {
  const ListOfCoursesScreen(
      {super.key, required this.subject, this.featuredCoursesOnly = false});

  final Subject? subject;
  final bool featuredCoursesOnly;

  @override
  State<ListOfCoursesScreen> createState() => ListOfCoursesScreenState();
}

class ListOfCoursesScreenState extends State<ListOfCoursesScreen> {
  List<Course> _courses = [];
  final CourseRepository _repository = CourseRepository();

  @override
  void initState() {
    fetchCourses(widget.subject?.id ?? '');
    super.initState();
  }

  Future<void> fetchCourses(String subjectId) async {
    final courses = await _repository.getCoursesBySubject(
        subjectId, widget.featuredCoursesOnly);
    setState(() {
      _courses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.featuredCoursesOnly
        ? _courses.isNotEmpty
            ? Builder(builder: (context) {
                return SizedBox(
                  height: 250,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) => i == _courses.length
                          ? SizedBox(
                              width: constraints.maxWidth <= 400
                                  ? constraints.maxWidth / 2
                                  : 250,
                              child: TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  '/all-courses',
                                  arguments: ListOfCoursesScreenArguments(
                                      widget.subject),
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
                          : CourseCard(
                              course: _courses[i],
                              maxWidth: 450,
                              maxHeight: 250,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/course',
                                arguments: CourseScreenArguments(_courses[i]),
                              ),
                            ),
                      separatorBuilder: (context, i) =>
                          const SizedBox(width: 10),
                      itemCount: _courses.length + 1,
                    );
                  }),
                );
              })
            : const Text(
                "No courses have been featured for this subject yet.",
              )
        : Scaffold(
            appBar: AppBar(
              title: Text("Top Courses in ${widget.subject?.name}"),
              centerTitle: false,
              leading: const AppBarIcon(),
            ),
            body: _courses.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: _courses.length,
                      itemBuilder: (_, i) => CourseCard(
                        key: Key(_courses[i].id),
                        course: _courses[i],
                        listMode: true,
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/course',
                          arguments: CourseScreenArguments(_courses[i]),
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      "No courses have been featured for this subject yet.",
                    ),
                  ),
          );
  }
}

class ListOfCoursesScreenArguments {
  final Subject? subject;

  ListOfCoursesScreenArguments(this.subject);
}
