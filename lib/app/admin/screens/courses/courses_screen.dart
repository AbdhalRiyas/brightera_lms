import 'package:app/app/admin/screens/courses/create_edit_syllabus_screen.dart';
import 'package:app/app/admin/screens/courses/create_update_course_screen.dart';
import 'package:app/app/config/theme_constants.dart';
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
              return ListView.builder(
                itemBuilder: (context, i) {
                  final course = courses[i];

                  return CourseCard(
                    course: course,
                    listMode: true,
                    trailing: PopupMenuButton<String>(
                      color: ThemeConstants.backgroundColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge)),
                      onSelected: (String result) {
                        // Handle the selected option
                        switch (result) {
                          case 'Edit Syllabus':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CreateEditSyllabusScreen(
                                  course: course,
                                  courseRepository: _repository,
                                ),
                              ),
                            );
                            break;
                          case 'Delete':
                            break;
                          default:
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Edit Syllabus',
                          child: Text('Edit Syllabus'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert), // Vertical dots icon
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CreateUpdateCourseScreen(course: course),
                      ),
                    ),
                  );
                },
                itemCount: courses.length,
              );
            } else {
              return const Center(child: Text("No courses have been added"));
            }
          }),
    );
  }
}
