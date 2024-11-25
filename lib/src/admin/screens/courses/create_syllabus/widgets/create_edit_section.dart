// ignore_for_file: use_build_context_synchronously

import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/section.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

void createEditSection({
  required BuildContext context,
  required Function updateSections,
  required Future<List<Section>> sectionsAndLectures,
  required CourseRepository courseRepository,
  Section? section,
  required String courseId,
  int? index,
}) {
  final TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  titleController.text = section?.title ?? '';

  bool isLoading = false;

  showDialog(
    context: context,
    builder: (_) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        content: StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) =>
                  Form(
            key: formKey,
            child: isLoading
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: CircularProgressIndicator.adaptive()),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        section != null ? "Edit Section" : "Create a Section",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: ThemeConstants.paddingLarge),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: "Title"),
                        maxLength: 60,
                        onChanged: (value) {
                          setState(() {
                            titleController.text = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title cannot be empty';
                          }

                          return null;
                        },
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

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: ThemeConstants.paddingMedium),
                        child: ElevatedButton(
                          onPressed: titleController.text.isNotEmpty &&
                                  section?.title != titleController.text
                              ? () async {
                                  if (formKey.currentState!.validate()) {
                                    setState(
                                      () {
                                        isLoading = true;
                                      },
                                    );

                                    List<Section> sections =
                                        await sectionsAndLectures;

                                    Section newSection = Section(
                                      id: section?.id ?? '',
                                      title: titleController.text,
                                      order: sections.length,
                                    );

                                    Result result = section != null
                                        ? await courseRepository.updateSection(
                                            courseId: courseId,
                                            section: newSection,
                                          )
                                        : await courseRepository.createSection(
                                            courseId: courseId,
                                            section: newSection,
                                          );

                                    if (result.isSuccess) {
                                      if (section != null) {
                                        updateSections(newSection, index);
                                      } else {
                                        sections.add(newSection.copyWith(
                                            id: result.data));
                                        updateSections(sections);
                                      }

                                      Navigator.pop(context);
                                    } else {
                                      setState(
                                        () {
                                          isLoading = false;
                                        },
                                      );

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(result.error ?? ''),
                                        ),
                                      );
                                    }
                                  }
                                }
                              : null,
                          child: Text(section == null
                              ? "Add Secion"
                              : "Update Changes"),
                        ),
                      ),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel")),
                    ],
                  ),
          ),
        ),
      ),
    ),
  );
}
