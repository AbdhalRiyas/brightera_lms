// ignore_for_file: use_build_context_synchronously

import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/lecture.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void createEditLecture({
  required BuildContext context,
  required Function updateSections,
  required Future<List<Section>> sectionsAndLectures,
  required CourseRepository courseRepository,
  required String courseId,
  required String sectionId,
  required int order,
  required int sectionIndex,
}) {
  final formKey = GlobalKey<FormState>();
  bool freePreview = false;
  bool isLive = false;
  String type = "video";

  final TextEditingController durationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  const String initialId = '';

  final youtubeController = YoutubePlayerController(
    initialVideoId: initialId,
    flags: const YoutubePlayerFlags(autoPlay: false, mute: true),
  );

  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        content: StatefulBuilder(
            builder: (BuildContext context,
                    void Function(void Function()) setState) =>
                Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge),
                          child: YoutubePlayer(controller: youtubeController),
                        ),
                        // Title field
                        TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title';
                            }
                            return null;
                          },
                        ),

                        // Type field
                        DropdownButtonFormField(
                          value: type,
                          items: const [
                            DropdownMenuItem(
                              child: Text("Video"),
                              value: 'video',
                            ),
                          ],
                          decoration: const InputDecoration(labelText: 'Type'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the type (e.g. video)';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            debugPrint(value);
                          },
                        ),

                        // Source (YouTube URL) field
                        TextFormField(
                          controller: sourceController,
                          decoration: const InputDecoration(
                              labelText: 'Source (YouTube URL)'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the source URL';
                            }
                            const youtubePattern =
                                r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$';
                            if (!RegExp(youtubePattern).hasMatch(value)) {
                              return 'Please enter a valid YouTube URL';
                            }
                            return null;
                          },
                        ),

                        // Duration (seconds) field
                        TextFormField(
                          controller: durationController,
                          decoration: const InputDecoration(
                              labelText: 'Duration (seconds)'),
                          keyboardType: TextInputType.number,
                          onTap: () {
                            if (initialId !=
                                    youtubeController.metadata.videoId &&
                                youtubeController.metadata.videoId.isNotEmpty) {
                              setState(
                                () {
                                  durationController.text = youtubeController
                                      .metadata.duration.inSeconds
                                      .toString();
                                },
                              );
                              youtubeController.pause();
                            } else {
                              youtubeController.load(
                                  YoutubePlayer.convertUrlToId(
                                          sourceController.text) ??
                                      '');
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter duration in seconds';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),

                        // Free preview switch
                        SwitchListTile.adaptive(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: const Text('Free Preview'),
                          value: freePreview,
                          onChanged: (bool value) {
                            setState(() {
                              freePreview = value;
                            });
                          },
                        ),

                        // Is live switch
                        SwitchListTile.adaptive(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          title: const Text('Is Live'),
                          value: isLive,
                          onChanged: (bool value) {
                            setState(() {
                              isLive = value;
                            });
                          },
                        ),

                        const SizedBox(height: 20),

                        // Submit Button
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // If the form is valid, display a success message or process the data
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);

                              Lecture lecture = Lecture(
                                id: '',
                                title: titleController.text,
                                type: type,
                                source: sourceController.text,
                                order: order,
                                durationInSeconds:
                                    num.parse(durationController.text),
                                isLive: isLive,
                                freePreview: freePreview,
                              );

                              Result result =
                                  await courseRepository.createLecture(
                                courseId: courseId,
                                sectionId: sectionId,
                                lecture: lecture,
                              );

                              if (result.isSuccess) {
                                lecture = lecture.copyWith(id: result.data);

                                final sections = await sectionsAndLectures;

                                sections[sectionIndex].lectures.add(lecture);

                                updateSections(sections);

                                Navigator.pop(context);
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(result.error ??
                                        "Couldn't able to add the lecture"),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Submit'),
                        ),

                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel")),
                      ],
                    ),
                  ),
                )),
      ),
    ),
  );
}
