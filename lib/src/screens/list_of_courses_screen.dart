import 'package:app/src/models/course.dart';
import 'package:app/src/models/subject.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/screens/courses/course_screen.dart';
import 'package:app/src/widgets/app_bar_back_button.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class ListOfCoursesScreen extends StatefulWidget {
  const ListOfCoursesScreen({
    super.key,
    this.subject,
    this.language,
  });

  final Subject? subject;
  final String? language;

  @override
  State<ListOfCoursesScreen> createState() => ListOfCoursesScreenState();
}

class ListOfCoursesScreenState extends State<ListOfCoursesScreen> {
  List<Course> _courses = [];
  final CourseRepository _repository = CourseRepository();

  @override
  void initState() {
    widget.subject != null
        ? fetchCourses(widget.subject!.id)
        : fetchCourses(widget.language);
    super.initState();
  }

  Future<void> fetchCourses(
    String? subjectId,
  ) async {
    final courses = widget.subject != null
        ? await _repository.getCoursesBySubject(subjectId!)
        : await _repository.getCoursesByLanguage(widget.language!);
    setState(() {
      _courses = courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.subject?.name ?? widget.language} Courses"),
        centerTitle: false,
        leading: const AppBarBackButton(),
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
          : Center(
              child: Text(
                widget.subject != null
                    ? "No courses have been featured for this subject yet."
                    : "No courses have been featured for this language yet.",
              ),
            ),
    );
    // : _courses.isNotEmpty
    //     ? Builder(builder: (context) {
    //         return SizedBox(
    //           height: 250,
    //           child: LayoutBuilder(builder: (context, constraints) {
    //             return ListView.separated(
    //               shrinkWrap: true,
    //               scrollDirection: Axis.horizontal,
    //               itemBuilder: (context, i) => i == _courses.length
    //                   ? SizedBox(
    //                       width: constraints.maxWidth <= 400
    //                           ? constraints.maxWidth / 2
    //                           : 250,
    //                       child: TextButton(
    //                         onPressed: () => Navigator.pushNamed(
    //                           context,
    //                           '/all-courses',
    //                           arguments: ListOfCoursesScreenArguments(
    //                             subject: widget.subject,
    //                           ),
    //                         ),
    //                         style: TextButton.styleFrom(
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(
    //                                 ThemeConstants.borderRadiusLarge),
    //                           ),
    //                         ),
    //                         child: const Text(
    //                           "See All",
    //                           style: TextStyle(fontSize: 18),
    //                         ),
    //                       ),
    //                     )
    //                   : CourseCard(
    //                       course: _courses[i],
    //                       maxWidth: 450,
    //                       maxHeight: 250,
    //                       onTap: () => Navigator.pushNamed(
    //                         context,
    //                         '/course',
    //                         arguments: CourseScreenArguments(_courses[i]),
    //                       ),
    //                     ),
    //               separatorBuilder: (context, i) =>
    //                   const SizedBox(width: 10),
    //               itemCount: _courses.length + 1,
    //             );
    //           }),
    //         );
    //       })
    //     : const Text(
    //         "No courses have been featured for this subject yet.",
    //       );
  }
}

class ListOfCoursesScreenArguments {
  final Subject? subject;
  final String? language;

  ListOfCoursesScreenArguments({this.subject, this.language});
}
