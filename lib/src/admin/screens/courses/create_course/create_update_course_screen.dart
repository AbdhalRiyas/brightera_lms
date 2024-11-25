import 'package:app/src/config/app_contants.dart';
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/repositories/subject_repository.dart';
import 'package:app/src/repositories/user_repository.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/course_duration_field.dart';
import 'widgets/cover_image_field.dart';
import 'widgets/description_field.dart';
import 'widgets/featured_published_field.dart';
import 'widgets/language_selector_field.dart';
import 'widgets/preview_video_field.dart';
import 'widgets/price_field.dart';
import 'widgets/subject_field.dart';
import 'widgets/submit_button.dart';
import 'widgets/title_field.dart';

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
      appBar: AppBar(
        title: Text(widget.course != null ? "Edit Course" : "Create a Course"),
      ),
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
                          CoverImageField(coverPicture: _coverPicture),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          TitleField(titleController: _titleController),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          DescriptionField(
                              descriptionController: _descriptionController),
                          PreviewVideoField(
                              previewVideoController: _previewVideoController),
                          CourseDurationField(
                              durationController: _durationController),
                          LanguageSelectorField(
                              language: _language, course: widget.course),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          SubjectField(
                            subjectRepository: _subjectRepository,
                            subject: _subject,
                            course: widget.course,
                          ),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          FeaturedPublishedField(
                              isFeatured: _isFeatured,
                              isPublished: _isPublished),
                          PriceField(
                            salePriceController: _salePriceController,
                            regularPriceController: _regularPriceController,
                          ),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          SubmitButton(
                            formKey: _formKey,
                            coverPicture: _coverPicture,
                            course: widget.course,
                            repository: _repository,
                            titleController: _titleController,
                            salePriceController: _salePriceController,
                            regularPriceController: _regularPriceController,
                            isFeatured: _isFeatured,
                            isPublished: _isPublished,
                            descriptionController: _descriptionController,
                            durationController: _durationController,
                            previewVideoController: _previewVideoController,
                            language: _language,
                            subjectRepository: _subjectRepository,
                            subject: _subject,
                            userRepository: _userRepository,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
