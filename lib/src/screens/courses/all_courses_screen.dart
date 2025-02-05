import 'package:app/src/models/course.dart';
import 'package:app/src/models/subject.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/screens/courses/show_course_screen.dart';
import 'package:app/src/widgets/app_bar_back_button.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class AllCoursesScreen extends StatelessWidget {
  const AllCoursesScreen({super.key, this.subject, this.language});

  final Subject? subject;
  final String? language;

  Future<List<Course>> _fetchCourses() {
    final CourseRepository repository = CourseRepository();
    return subject != null
        ? repository.getCoursesBySubject(subject!.id)
        : repository.getCoursesByLanguage(language!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${subject?.name ?? language} Courses"),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: FutureBuilder<List<Course>>(
        future: _fetchCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                subject != null
                    ? "No courses have been featured for this subject yet."
                    : "No courses have been featured for this language yet.",
              ),
            );
          }

          final courses = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (_, i) => CourseCard(
                key: Key(courses[i].id),
                course: courses[i],
                listMode: true,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/course',
                  arguments: CourseScreenArguments(courses[i]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListOfCoursesScreenArguments {
  final Subject? subject;
  final String? language;

  ListOfCoursesScreenArguments({this.subject, this.language});
}
