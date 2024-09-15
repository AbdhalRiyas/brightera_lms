import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/widgets/syllabus/syllabus_accordion.dart';
import 'package:flutter/material.dart';

class CreateEditSyllabusScreen extends StatelessWidget {
  const CreateEditSyllabusScreen(
      {super.key,
      required Course course,
      required CourseRepository courseRepository})
      : _course = course,
        _courseRepository = courseRepository;

  final Course _course;
  final CourseRepository _courseRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Syllabus"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
        child: Column(
          children: [
            FutureBuilder(
                future: _courseRepository.fetchSectionsForCourse(_course.id),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    List<Section> sections = snapshot.data ?? [];

                    return StatefulBuilder(builder: (context, setState) {
                      return ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sections.length,
                        itemBuilder: (_, i) => ListTile(
                          leading: ReorderableDragStartListener(
                            index: i,
                            child: const Icon(Icons.drag_handle),
                          ),
                          key: Key(sections[i].id),
                          title: Text(
                            sections[i].title,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                          ),
                          onTap: () {
                            print("wwqd");
                          },
                        ),
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final Section movedSection =
                                sections.removeAt(oldIndex);

                            sections.insert(newIndex, movedSection);

                            for (int i = 0; i < sections.length; i++) {
                              sections[i].order = i;
                            }
                          });
                        },
                      );
                    });
                  } else {
                    return const Text("No sections have been added yet!");
                  }
                }),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              onPressed: () {},
              label: const Text("Add a Section"),
            ),
          ],
        ),
      ),
    );
  }
}
