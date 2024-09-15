// ignore_for_file: use_build_context_synchronously

import 'package:app/app/config/app_contants.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/repositories/user_repository.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:app/app/utils/result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/build_cover_image.dart';
import 'widgets/pick_course_cover.dart';

class CreateUpdateCourseScreen extends StatefulWidget {
  const CreateUpdateCourseScreen({super.key, this.course});

  final Course? course;

  @override
  State<CreateUpdateCourseScreen> createState() =>
      _CreateUpdateCourseScreenState();
}

class _CreateUpdateCourseScreenState extends State<CreateUpdateCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final CourseRepository _repository = CourseRepository();
  final SubjectRepository _subjectRepository = SubjectRepository();
  final UserRepository _userRepository = UserRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _previewVideoController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _regularPriceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final ValueNotifier<bool> _isFeatured = ValueNotifier(false);
  final ValueNotifier<bool> _isPublished = ValueNotifier(false);
  final ValueNotifier<String> _coverPicture = ValueNotifier('');
  final ValueNotifier<String?> _language = ValueNotifier('');
  final ValueNotifier<String?> _subject = ValueNotifier('');

  @override
  void initState() {
    _coverPicture.value = widget.course == null || widget.course!.image.isEmpty
        ? AppContants.courseCoverPlaceHolder
        : widget.course!.image;
    _titleController.text = widget.course?.title ?? '';
    _descriptionController.text = widget.course?.description ?? '';
    _salePriceController.text = widget.course?.salePrice.toString() ?? '';
    _regularPriceController.text = widget.course?.regularPrice.toString() ?? '';
    _previewVideoController.text = widget.course?.previewVideo.toString() ?? '';
    _durationController.text = widget.course?.durationInHours.toString() ?? '';
    _isFeatured.value = widget.course?.isFeatured ?? false;
    _isPublished.value = widget.course?.isPublished ?? false;
    _language.value = widget.course?.language;
    _language.value = widget.course?.language;
    _subject.value = widget.course?.subject?.path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: FocusManager.instance.primaryFocus?.unfocus,
        child: StreamBuilder<User?>(
            stream: FirebaseService().authStateChanges,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
                child: ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ValueListenableBuilder<String>(
                              valueListenable: _coverPicture,
                              builder: (_, value, ch) => Column(
                                    children: [
                                      buildCoverImage(context, value),
                                      TextButton(
                                        onPressed: () async {
                                          final coverPic =
                                              await pickCourseCover(context);
                                          _coverPicture.value =
                                              coverPic?.files.single.path ??
                                                  _coverPicture.value;
                                        },
                                        child: Text(_coverPicture
                                                    .value.isNotEmpty &&
                                                _coverPicture.value !=
                                                    AppContants
                                                        .courseCoverPlaceHolder
                                            ? "Change Course Cover"
                                            : "Add a Course Cover"),
                                      ),
                                    ],
                                  )),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          TextFormField(
                            controller: _titleController,
                            maxLength: 70,
                            decoration: const InputDecoration(
                              labelText: "Course Title",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a Course Title';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: null,
                            maxLength: 300,
                            decoration:
                                const InputDecoration(labelText: "Description"),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextFormField(
                            controller: _previewVideoController,
                            maxLength: 60,
                            decoration: const InputDecoration(
                                labelText: "Preview Video (Youtube)"),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            validator: (value) {
                              // Updated YouTube URL regex with optional www
                              const urlPattern =
                                  r'^(https?\:\/\/)?(www\.)?(youtube\.com|youtu\.?be)\/.+$';
                              final regExp = RegExp(urlPattern);

                              if (value == null || value.isEmpty) {
                                return 'Please enter a YouTube URL';
                              } else if (!regExp.hasMatch(value)) {
                                return 'Please enter a valid YouTube URL';
                              }
                              return null; // If valid, return null (no error)
                            },
                          ),
                          TextFormField(
                            controller: _durationController,
                            maxLength: 6,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(
                                  r'^\d*\.?\d{0,2}')), // Allows numbers with up to 2 decimal places
                            ],
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                                labelText: "Duration (Hours)"),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter course duration';
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          DropdownButtonFormField(
                            items: const [
                              DropdownMenuItem(
                                value: "தமிழ்",
                                child: Text("தமிழ்"),
                              ),
                              DropdownMenuItem(
                                value: "English",
                                child: Text("English"),
                              ),
                              DropdownMenuItem(
                                value: "සිංහල",
                                child: Text("සිංහල"),
                              ),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please choose the Course Language';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              _language.value = value;
                            },
                            value: widget.course?.language,
                            decoration:
                                const InputDecoration(labelText: "Language"),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          FutureBuilder(
                              future: _subjectRepository.getAllSubjects(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                }

                                if (snapshot.hasData) {
                                  return DropdownButtonFormField(
                                    items: List.generate(
                                      snapshot.data!.length,
                                      (i) {
                                        return DropdownMenuItem(
                                          value:
                                              "subjects/${snapshot.data?[i].id}",
                                          child: Text(
                                              snapshot.data?[i].name ?? ''),
                                        );
                                      },
                                    ).toList(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please choose the course subject';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      // Handle value change
                                      _subject.value = value;
                                    },
                                    value: widget.course?.subject?.path,
                                    decoration: const InputDecoration(
                                        labelText: "Subject"),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  );
                                } else {
                                  return const Center(
                                      child: Text("Couldn't fetch subjects"));
                                }
                              }),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          Row(
                            children: [
                              const Text("Featured"),
                              Expanded(
                                child: ValueListenableBuilder<bool>(
                                    valueListenable: _isFeatured,
                                    builder: (context, value, ch) {
                                      return Switch.adaptive(
                                        value: value,
                                        onChanged: (bool value) {
                                          _isFeatured.value = value;
                                        },
                                      );
                                    }),
                              ),
                              const SizedBox(width: 10),
                              const Text("Published"),
                              Expanded(
                                child: ValueListenableBuilder<bool>(
                                    valueListenable: _isPublished,
                                    builder: (context, value, ch) {
                                      return Switch.adaptive(
                                        value: value,
                                        onChanged: (bool value) {
                                          _isPublished.value = value;
                                        },
                                      );
                                    }),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _salePriceController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'^\d*\.?\d{0,2}')), // Allows numbers with up to 2 decimal places
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: "Sale Price"),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the sale price';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: _regularPriceController,
                                  decoration: const InputDecoration(
                                      labelText: "Regular Price"),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'^\d*\.?\d{0,2}')), // Allows numbers with up to 2 decimal places
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool canUpdate = true;

                                if (_coverPicture.value !=
                                    widget.course?.image) {
                                  Result result = await _repository
                                      .uploadCourseCover(_coverPicture.value);

                                  if (result.isSuccess) {
                                    _coverPicture.value = result.data;
                                  } else {
                                    _coverPicture.value =
                                        widget.course?.image ??
                                            AppContants.courseCoverPlaceHolder;
                                    canUpdate = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result.error ?? ''),
                                      ),
                                    );
                                  }
                                }

                                if (canUpdate) {
                                  Course newCourse = widget.course == null
                                      ? Course(
                                          id: '',
                                          title: _titleController.text,
                                          salePrice: num.parse(
                                              _salePriceController.text),
                                          regularPrice: num.parse(
                                              _regularPriceController
                                                      .text.isEmpty
                                                  ? '0.00'
                                                  : _regularPriceController
                                                      .text),
                                          isFeatured: _isFeatured.value,
                                          isPublished: _isPublished.value,
                                          description:
                                              _descriptionController.text,
                                          durationInHours: num.parse(
                                              _durationController.text),
                                          image: _coverPicture.value,
                                          previewVideo:
                                              _previewVideoController.text,
                                          language: _language.value!,
                                          subject: _subjectRepository
                                              .getSubjectReference(_subject
                                                  .value!
                                                  .split('/')
                                                  .last),
                                          instructor: _userRepository
                                              .getUserReference(_userRepository
                                                  .currentUserUid),
                                        )
                                      : widget.course!.copyWith(
                                          title: _titleController.text,
                                          salePrice: num.parse(
                                              _salePriceController.text),
                                          regularPrice: num.parse(
                                              _regularPriceController
                                                      .text.isEmpty
                                                  ? '0.00'
                                                  : _regularPriceController
                                                      .text),
                                          isFeatured: _isFeatured.value,
                                          isPublished: _isPublished.value,
                                          description:
                                              _descriptionController.text,
                                          durationInHours: num.parse(
                                              _durationController.text),
                                          image: _coverPicture.value,
                                          previewVideo:
                                              _previewVideoController.text,
                                          language: _language.value!,
                                          subject: _subjectRepository
                                              .getSubjectReference(_subject
                                                  .value!
                                                  .split('/')
                                                  .last),
                                          instructor: _userRepository
                                              .getUserReference(_userRepository
                                                  .currentUserUid),
                                        );

                                  Result result = widget.course == null
                                      ? await _repository
                                          .createCourse(newCourse)
                                      : await _repository
                                          .updateCourse(newCourse);

                                  if (result.isSuccess) {
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(result.error!),
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            },
                            child: Text(widget.course == null
                                ? "Create Course"
                                : "Save Changes"),
                          ),
                        ],
                      ),
                    ),
                    // const Text(
                    //   "Syllabus",
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // SyllabusAccordion(course: widget.course)
                  ],
                ),
              );
            }),
      ),
    );
  }
}
