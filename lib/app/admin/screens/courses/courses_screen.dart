import 'package:app/app/admin/screens/courses/create_update_course_screen.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final CourseRepository _repository = CourseRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CreateUpdateCourseScreen(),
          ),
        ),
      ),
      body: StreamBuilder<List<Course>>(
          stream: _repository.getCoursesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              final courses = snapshot.data!;
              return ListView.separated(
                itemBuilder: (context, i) {
                  final course = courses[i];

                  return Dismissible(
                    key: Key(course
                        .id), // Ensure each item has a unique key (e.g., the item's ID)
                    direction:
                        DismissDirection.endToStart, // Swipe from right to left
                    confirmDismiss: (direction) async {
                      return null;

                      // Result result =
                      //     await _repository.deleteSubject(subject.id);

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text(result.data ?? result.error),
                      //     backgroundColor:
                      //         result.isSuccess ? Colors.green : Colors.red,
                      //   ),
                      // );

                      // return result.isSuccess;
                    },
                    background: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: CourseCard(
                      course: course,
                      listMode: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CreateUpdateCourseScreen(course: course),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, i) => const Divider(),
                itemCount: courses.length,
              );
            } else {
              return const Center(child: Text("No courses have been added"));
            }
          }),
    );
  }
}
