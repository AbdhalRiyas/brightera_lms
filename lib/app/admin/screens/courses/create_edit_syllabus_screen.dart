import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/lecture.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/utils/int_extension.dart';
import 'package:app/app/utils/string_extension.dart';
import 'package:flutter/material.dart';

class CreateEditSyllabusScreen extends StatefulWidget {
  const CreateEditSyllabusScreen(
      {super.key,
      required Course course,
      required CourseRepository courseRepository})
      : _course = course,
        _courseRepository = courseRepository;

  final Course _course;
  final CourseRepository _courseRepository;

  @override
  State<CreateEditSyllabusScreen> createState() =>
      _CreateEditSyllabusScreenState();
}

class _CreateEditSyllabusScreenState extends State<CreateEditSyllabusScreen> {
  void _createEditSection([Section? section, int order = 0]) {
    final TextEditingController _titleController = TextEditingController();

    _titleController.text = section?.title ?? '';

    showDialog(
      context: context,
      builder: (_) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context,
                    void Function(void Function()) setState) =>
                Form(
                    child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  section != null ? "Edit Section" : "Create a Section",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: ThemeConstants.paddingLarge),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                  maxLength: 60,
                  onChanged: (value) {},
                ),
                // ListTile(
                //   title: const Text("Active"),
                //   contentPadding: EdgeInsets.zero,
                //   trailing: Switch.adaptive(
                //       value: isActive,
                //       onChanged: (value) {
                //         setState(
                //           () => isActive = !isActive,
                //         );
                //       }),
                // ),
                const SizedBox(height: ThemeConstants.paddingMedium),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel")),
              ],
            )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Syllabus"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _createEditSection(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
        child: ListView(
          shrinkWrap: true,
          children: [
            FutureBuilder(
                future: widget._courseRepository
                    .fetchSectionsForCourse(widget._course.id),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }
                  if (snapshot.hasData) {
                    List<Section> sections = snapshot.data ?? [];

                    return StatefulBuilder(builder: (context, setState) {
                      return ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sections.length,
                        itemBuilder: (_, i) {
                          List<Lecture> lectures =
                              snapshot.data?[i].lectures ?? [];

                          ValueNotifier<bool> isLecturesExpanded =
                              ValueNotifier(false);
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            key: Key(sections[i].id),
                            children: [
                              ListTile(
                                leading: ReorderableDragStartListener(
                                  index: i,
                                  child: const Icon(Icons.drag_handle),
                                ),
                                title: Text(
                                  sections[i].title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                onTap: () => _createEditSection(sections[i]),
                                trailing: IconButton(
                                  onPressed: () => setState(
                                    () {
                                      isLecturesExpanded.value =
                                          !isLecturesExpanded.value;
                                    },
                                  ),
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                              ReorderableListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (_, j) => ListTile(
                                  contentPadding: const EdgeInsets.only(
                                      left: ThemeConstants.paddingLarge * 2),
                                  key: Key(lectures[j].id),
                                  leading: Text("${lectures[j].order + 1}"),
                                  title: Text(
                                    lectures[j].title,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  subtitle: Text(
                                    lectures[j].isLive
                                        ? "Live video"
                                        : "${lectures[j].type.capitalize()} - ${lectures[j].durationInSeconds.toMinutes()}",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                                itemCount: lectures.length,
                                onReorder: (int oldSubIndex, int newSubIndex) {
                                  setState(() {
                                    if (oldSubIndex < newSubIndex) {
                                      newSubIndex -= 1;
                                    }
                                    final Lecture movedLecture =
                                        lectures.removeAt(oldSubIndex);

                                    lectures.insert(newSubIndex, movedLecture);
                                  });

                                  for (int k = 0; k < lectures.length; k++) {
                                    lectures[k].order = k;
                                    widget._courseRepository.updateLecture(
                                      courseId: widget._course.id,
                                      sectionId: sections[i].id,
                                      lecture: lectures[k],
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final Section movedSection =
                                sections.removeAt(oldIndex);

                            sections.insert(newIndex, movedSection);
                          });

                          for (int k = 0; k < sections.length; k++) {
                            sections[k].order = k;
                            widget._courseRepository.updateSection(
                                courseId: widget._course.id,
                                section: sections[k]);
                          }
                        },
                      );
                    });
                  } else {
                    return const Text("No sections have been added yet!");
                  }
                }),
          ],
        ),
      ),
    );
  }
}
