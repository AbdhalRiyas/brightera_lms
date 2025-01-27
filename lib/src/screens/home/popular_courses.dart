import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/screens/courses/course_screen.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class PopularCourses extends StatefulWidget {
  const PopularCourses({super.key});

  @override
  State<PopularCourses> createState() => _PopularCoursesState();
}

class _PopularCoursesState extends State<PopularCourses> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CourseRepository().getHomeCourses(
        "popularCourses",
      ),
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : snapshot.hasError
                  ? Center(
                      child: Text('Error: ${snapshot.error}'),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Popular Courses',
                          style: ThemeConstants.headingStyle,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            final course = snapshot.data![i];
                            return CourseCard(
                              course: course,
                              listMode: true,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/course',
                                  arguments: CourseScreenArguments(course),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
    );
  }
}
