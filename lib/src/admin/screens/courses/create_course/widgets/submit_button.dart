// ignore_for_file: use_build_context_synchronously

import 'package:app/src/config/app_contants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/repositories/subject_repository.dart';
import 'package:app/src/repositories/user_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  const SubmitButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required ValueNotifier<String> coverPicture,
    Course? course,
    required CourseRepository repository,
    required TextEditingController titleController,
    required TextEditingController salePriceController,
    required TextEditingController regularPriceController,
    required ValueNotifier<bool> isFeatured,
    required ValueNotifier<bool> isPublished,
    required TextEditingController descriptionController,
    required TextEditingController durationController,
    required TextEditingController previewVideoController,
    required ValueNotifier<String?> language,
    required SubjectRepository subjectRepository,
    required ValueNotifier<String?> subject,
    required UserRepository userRepository,
    required TextEditingController expiresInDaysController,
  })  : _formKey = formKey,
        _coverPicture = coverPicture,
        _repository = repository,
        _titleController = titleController,
        _salePriceController = salePriceController,
        _regularPriceController = regularPriceController,
        _isFeatured = isFeatured,
        _isPublished = isPublished,
        _descriptionController = descriptionController,
        _durationController = durationController,
        _previewVideoController = previewVideoController,
        _language = language,
        _subjectRepository = subjectRepository,
        _subject = subject,
        _course = course,
        _userRepository = userRepository,
        _expiresInDaysController = expiresInDaysController;

  final GlobalKey<FormState> _formKey;
  final ValueNotifier<String> _coverPicture;
  final Course? _course;
  final CourseRepository _repository;
  final TextEditingController _titleController;
  final TextEditingController _salePriceController;
  final TextEditingController _regularPriceController;
  final ValueNotifier<bool> _isFeatured;
  final ValueNotifier<bool> _isPublished;
  final TextEditingController _descriptionController;
  final TextEditingController _durationController;
  final TextEditingController _previewVideoController;
  final ValueNotifier<String?> _language;
  final SubjectRepository _subjectRepository;
  final ValueNotifier<String?> _subject;
  final UserRepository _userRepository;
  final TextEditingController _expiresInDaysController;

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (BuildContext context, value, Widget? child) => value
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ElevatedButton(
              onPressed: () async {
                _isLoading.value = true;
                if (widget._formKey.currentState!.validate()) {
                  bool canUpdate = true;

                  if (widget._coverPicture.value != widget._course?.image) {
                    Result result = await widget._repository
                        .uploadCourseCover(widget._coverPicture.value);

                    if (result.isSuccess) {
                      widget._coverPicture.value = result.data;
                    } else {
                      widget._coverPicture.value = widget._course?.image ??
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
                    Course newCourse = widget._course == null
                        ? Course(
                            id: '',
                            title: widget._titleController.text,
                            salePrice:
                                num.parse(widget._salePriceController.text),
                            regularPrice: num.parse(
                                widget._regularPriceController.text.isEmpty
                                    ? '0.00'
                                    : widget._regularPriceController.text),
                            isFeatured: widget._isFeatured.value,
                            isPublished: widget._isPublished.value,
                            description: widget._descriptionController.text,
                            durationInHours:
                                num.parse(widget._durationController.text),
                            image: widget._coverPicture.value,
                            previewVideo: widget._previewVideoController.text,
                            language: widget._language.value!,
                            subject: widget._subjectRepository
                                .getSubjectReference(
                                    widget._subject.value!.split('/').last),
                            instructor: widget._userRepository.getUserReference(
                                widget._userRepository.currentUserUid),
                            expiresInDays:
                                int.parse(widget._expiresInDaysController.text),
                          )
                        : widget._course!.copyWith(
                            title: widget._titleController.text,
                            salePrice:
                                num.parse(widget._salePriceController.text),
                            regularPrice: num.parse(
                                widget._regularPriceController.text.isEmpty
                                    ? '0.00'
                                    : widget._regularPriceController.text),
                            isFeatured: widget._isFeatured.value,
                            isPublished: widget._isPublished.value,
                            description: widget._descriptionController.text,
                            durationInHours:
                                num.parse(widget._durationController.text),
                            image: widget._coverPicture.value,
                            previewVideo: widget._previewVideoController.text,
                            language: widget._language.value!,
                            subject: widget._subjectRepository
                                .getSubjectReference(
                                    widget._subject.value!.split('/').last),
                            instructor: widget._userRepository.getUserReference(
                                widget._userRepository.currentUserUid),
                            expiresInDays:
                                int.parse(widget._expiresInDaysController.text),
                          );

                    Result result = widget._course == null
                        ? await widget._repository.createCourse(newCourse)
                        : await widget._repository.updateCourse(newCourse);

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

                _isLoading.value = false;
              },
              child: Text(
                  widget._course == null ? "Create Course" : "Save Changes"),
            ),
    );
  }
}
