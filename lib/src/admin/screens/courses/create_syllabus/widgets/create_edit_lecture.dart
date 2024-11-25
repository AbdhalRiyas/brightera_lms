// ignore_for_file: use_build_context_synchronously

import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/lecture.dart';
import 'package:app/src/models/section.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/utils/convert_to_gdrive_direct_link.dart';
import 'package:app/src/utils/result.dart';
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
  Lecture? lecture,
  int? lectureIndex,
}) {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController durationController = TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController pdfNotesController = TextEditingController();
  TextEditingController newDownloadNameController = TextEditingController();
  TextEditingController newDownloadLinkController = TextEditingController();

  String initialId = YoutubePlayer.convertUrlToId(lecture?.source ?? '') ?? '';
  titleController.text = lecture?.title ?? '';
  durationController.text = "${lecture?.durationInSeconds ?? ''}";
  sourceController.text = lecture?.source ?? '';
  pdfNotesController.text = lecture?.pdfNotes ?? '';

  List<dynamic> downloadsList = lecture?.downloads
          .map((link) => {'name': link['name'], 'link': link['link']})
          .toList() ??
      [];

  bool freePreview = lecture?.freePreview ?? false;
  bool isLive = lecture?.isLive ?? false;
  String type = lecture?.type ?? 'video';

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
                isLoading
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    ThemeConstants.borderRadiusLarge),
                                child: YoutubePlayer(
                                    controller: youtubeController),
                              ),
                              // Title field
                              TextFormField(
                                controller: titleController,
                                decoration:
                                    const InputDecoration(labelText: 'Title'),
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
                                    value: 'video',
                                    child: Text("Video"),
                                  ),
                                ],
                                decoration:
                                    const InputDecoration(labelText: 'Type'),
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
                                      youtubeController
                                          .metadata.videoId.isNotEmpty) {
                                    setState(
                                      () {
                                        durationController.text =
                                            youtubeController
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

                              // PDF Notes (Google Drive URL) field
                              TextFormField(
                                controller: pdfNotesController,
                                decoration: const InputDecoration(
                                  labelText:
                                      'PDF Notes (Direct Link or Google Drive)',
                                ),
                                validator: (value) {
                                  if (value != null && value.isNotEmpty) {
                                    // Regular expression to match any valid URL
                                    RegExp urlPattern = RegExp(
                                        r'^(https?:\/\/)?' // optional http or https scheme
                                        );

                                    // If the value is not a valid URL
                                    if (!urlPattern.hasMatch(value)) {
                                      return 'Please enter a valid URL or leave empty';
                                    }
                                  }

                                  // If the value is empty, it's valid
                                  return null;
                                },
                              ),

                              // Downloads fied
                              ...downloadsList.map((download) => ListTile(
                                    title: Text(download['name'] ?? ''),
                                    subtitle: Text(download['link'] ?? ''),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          downloadsList.remove(download);
                                        });
                                      },
                                    ),
                                  )),

                              // Text field to add new download name
                              TextFormField(
                                controller: newDownloadNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Add New Download Name',
                                ),
                                // Remove validation by returning null
                                validator: (value) {
                                  return null; // No validation for name; can be empty
                                },
                              ),

                              // Text field to add new download link
                              TextFormField(
                                controller: newDownloadLinkController,
                                decoration: const InputDecoration(
                                  labelText: 'Add New Download Link',
                                ),
                                // Remove validation by returning null
                                validator: (value) {
                                  return null; // No validation for link; can be empty
                                },
                              ),

                              // Button to add the new link to the list
                              TextButton.icon(
                                onPressed: () {
                                  // Check if both fields are not empty before adding
                                  if (newDownloadNameController
                                          .text.isNotEmpty ||
                                      newDownloadLinkController
                                          .text.isNotEmpty) {
                                    setState(() {
                                      downloadsList.add({
                                        'name': newDownloadNameController.text,
                                        'link': convertToGdriveDirectLink(
                                            newDownloadLinkController.text),
                                      });
                                      newDownloadNameController
                                          .clear(); // Clear the input field after adding
                                      newDownloadLinkController.clear();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Link'),
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
                                    setState(() {
                                      isLoading = true;
                                    });

                                    // If the form is valid, display a success message or process the data
                                    final scaffoldMessenger =
                                        ScaffoldMessenger.of(context);

                                    Lecture newLecture = Lecture(
                                      id: lecture?.id ?? '',
                                      title: titleController.text,
                                      type: type,
                                      source: sourceController.text,
                                      order: order,
                                      durationInSeconds:
                                          num.parse(durationController.text),
                                      isLive: isLive,
                                      freePreview: freePreview,
                                      downloads: downloadsList,
                                      pdfNotes: convertToGdriveDirectLink(
                                          pdfNotesController.text),
                                    );

                                    Result result = lecture != null
                                        ? await courseRepository.updateLecture(
                                            courseId: courseId,
                                            sectionId: sectionId,
                                            lecture: newLecture)
                                        : await courseRepository.createLecture(
                                            courseId: courseId,
                                            sectionId: sectionId,
                                            lecture: newLecture,
                                          );

                                    if (result.isSuccess) {
                                      if (lecture == null) {
                                        newLecture = newLecture.copyWith(
                                            id: result.data);
                                      }

                                      final sections =
                                          await sectionsAndLectures;

                                      if (lecture == null) {
                                        sections[sectionIndex]
                                            .lectures
                                            .add(newLecture);

                                        scaffoldMessenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "New lecture is added successfully!"),
                                          ),
                                        );
                                      } else {
                                        sections[sectionIndex]
                                                .lectures[lectureIndex ?? 0] =
                                            newLecture;

                                        scaffoldMessenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Lecture is updated successfully!"),
                                          ),
                                        );
                                      }

                                      updateSections(sections);

                                      Navigator.pop(context);
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      scaffoldMessenger.showSnackBar(
                                        SnackBar(
                                          content: Text(result.error ??
                                              "Couldn't able to add the lecture"),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(lecture != null
                                    ? 'Save Changes'
                                    : 'Submit'),
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
