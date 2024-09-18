import 'package:app/app/admin/screens/courses/create_syllabus/widgets/create_edit_lecture.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/lecture.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/utils/int_extension.dart';
import 'package:app/app/utils/string_extension.dart';
import 'package:flutter/material.dart';

import 'widgets/create_edit_section.dart';

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
  late Future<List<Section>> _sectionsAndLectures;

  @override
  void initState() {
    _sectionsAndLectures =
        widget._courseRepository.fetchSectionsForCourse(widget._course.id);
    super.initState();
  }

  void _updateSections(List<Section> updatedSections) {
    setState(() {
      _sectionsAndLectures = Future.value(updatedSections);
    });
  }

  void _updateModifiedSection(Section section, int index) async {
    final sections = await _sectionsAndLectures;
    sections[index] = section;
    setState(() {
      _sectionsAndLectures = Future.value(sections);
    });
  }

  @override
  Widget build(BuildContext context) {
    double bottomNotch = MediaQuery.of(context).viewPadding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Syllabus"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomSheet: Padding(
        padding: EdgeInsets.only(
          left: ThemeConstants.paddingSmall,
          right: ThemeConstants.paddingSmall,
          bottom: bottomNotch,
        ),
        child: ElevatedButton(
          child: const Text("Add a Section"),
          onPressed: () => createEditSection(
            context: context,
            courseId: widget._course.id,
            courseRepository: widget._courseRepository,
            sectionsAndLectures: _sectionsAndLectures,
            updateSections: _updateSections,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
        child: ListView(
          shrinkWrap: true,
          children: [
            FutureBuilder(
                future: _sectionsAndLectures,
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: ThemeConstants.paddingSmall),
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
                                onTap: () => createEditSection(
                                  context: context,
                                  courseId: widget._course.id,
                                  courseRepository: widget._courseRepository,
                                  sectionsAndLectures: _sectionsAndLectures,
                                  section: sections[i],
                                  updateSections: _updateModifiedSection,
                                  index: i,
                                ),
                                trailing: IconButton(
                                  onPressed: () => setState(
                                    () {
                                      isLecturesExpanded.value =
                                          !isLecturesExpanded.value;
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.red[900],
                                  ),
                                ),
                              ),
                              ReorderableListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (_, j) => ListTile(
                                  contentPadding: const EdgeInsets.only(
                                      left: ThemeConstants.paddingLarge),
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
                              TextButton.icon(
                                onPressed: () => createEditLecture(
                                  context: context,
                                  courseId: widget._course.id,
                                  courseRepository: widget._courseRepository,
                                  sectionsAndLectures: _sectionsAndLectures,
                                  updateSections: _updateSections,
                                ),
                                icon: const Icon(
                                  Icons.add,
                                  size: 18,
                                ),
                                label: const Text(
                                  "Add a Lecture",
                                  style: TextStyle(fontSize: 12),
                                ),
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
            SizedBox(height: bottomNotch + 30),
          ],
        ),
      ),
    );
  }
}
