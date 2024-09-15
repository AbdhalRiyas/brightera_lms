// ignore_for_file: use_build_context_synchronously

import 'package:app/app/config/app_contants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/repositories/user_repository.dart';
import 'package:app/app/utils/result.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
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
        _userRepository = userRepository;

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

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          bool canUpdate = true;

          if (_coverPicture.value != _course?.image) {
            Result result =
                await _repository.uploadCourseCover(_coverPicture.value);

            if (result.isSuccess) {
              _coverPicture.value = result.data;
            } else {
              _coverPicture.value =
                  _course?.image ?? AppContants.courseCoverPlaceHolder;
              canUpdate = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result.error ?? ''),
                ),
              );
            }
          }

          if (canUpdate) {
            Course newCourse = _course == null
                ? Course(
                    id: '',
                    title: _titleController.text,
                    salePrice: num.parse(_salePriceController.text),
                    regularPrice: num.parse(_regularPriceController.text.isEmpty
                        ? '0.00'
                        : _regularPriceController.text),
                    isFeatured: _isFeatured.value,
                    isPublished: _isPublished.value,
                    description: _descriptionController.text,
                    durationInHours: num.parse(_durationController.text),
                    image: _coverPicture.value,
                    previewVideo: _previewVideoController.text,
                    language: _language.value!,
                    subject: _subjectRepository
                        .getSubjectReference(_subject.value!.split('/').last),
                    instructor: _userRepository
                        .getUserReference(_userRepository.currentUserUid),
                  )
                : _course!.copyWith(
                    title: _titleController.text,
                    salePrice: num.parse(_salePriceController.text),
                    regularPrice: num.parse(_regularPriceController.text.isEmpty
                        ? '0.00'
                        : _regularPriceController.text),
                    isFeatured: _isFeatured.value,
                    isPublished: _isPublished.value,
                    description: _descriptionController.text,
                    durationInHours: num.parse(_durationController.text),
                    image: _coverPicture.value,
                    previewVideo: _previewVideoController.text,
                    language: _language.value!,
                    subject: _subjectRepository
                        .getSubjectReference(_subject.value!.split('/').last),
                    instructor: _userRepository
                        .getUserReference(_userRepository.currentUserUid),
                  );

            Result result = _course == null
                ? await _repository.createCourse(newCourse)
                : await _repository.updateCourse(newCourse);

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
      child: Text(_course == null ? "Create Course" : "Save Changes"),
    );
  }
}
