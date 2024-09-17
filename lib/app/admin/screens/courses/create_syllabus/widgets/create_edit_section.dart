// ignore_for_file: use_build_context_synchronously

import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/utils/result.dart';
import 'package:flutter/material.dart';

void createEditSection({
  required BuildContext context,
  required Function updateSections,
  required Future<List<Section>> sectionsAndLectures,
  required CourseRepository courseRepository,
  Section? section,
  required String courseId,
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
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              setState(
                                () {
                                  isLoading = true;
                                },
                              );

                              List<Section> sections =
                                  await sectionsAndLectures;

                              Section section = Section(
                                id: "",
                                title: titleController.text,
                                order: sections.length,
                              );

                              Result result =
                                  await courseRepository.createSection(
                                courseId: courseId,
                                section: section,
                              );

                              if (result.isSuccess) {
                                sections.add(section.copyWith(id: result.data));
                                updateSections(sections);
                                Navigator.pop(context);
                              } else {
                                setState(
                                  () {
                                    isLoading = false;
                                  },
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.error ?? ''),
                                  ),
                                );
                              }
                            }
                          },
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
