import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowCourseScreen extends StatefulWidget {
  const ShowCourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<ShowCourseScreen> createState() => _ShowCourseScreenState();
}

class _ShowCourseScreenState extends State<ShowCourseScreen> {
  final CourseRepository _repository = CourseRepository();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _previewVideoController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _regularPriceController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.course.title;
    _descriptionController.text = widget.course.description;
    _salePriceController.text = widget.course.salePrice.toString();
    _regularPriceController.text = widget.course.regularPrice.toString();
    _previewVideoController.text = widget.course.previewVideo.toString();
    _durationController.text = widget.course.durationInHours.toString();
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
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.course.image,
                            width: double.maxFinite,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(height: ThemeConstants.paddingSmall),
                          TextFormField(
                            controller: _titleController,
                            maxLength: 70,
                            decoration: const InputDecoration(
                              labelText: "Course Title",
                            ),
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
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          DropdownButtonFormField(
                            items: const [
                              DropdownMenuItem(
                                value: "Tamil",
                                child: Text("Tamil"),
                              ),
                              DropdownMenuItem(
                                value: "English",
                                child: Text("English"),
                              ),
                              DropdownMenuItem(
                                value: "Sinhala",
                                child: Text("Sinhala"),
                              ),
                            ],
                            onChanged: (value) {
                              // Handle value change
                              print("Selected language: $value");
                            },
                            value: widget.course.language,
                            decoration:
                                const InputDecoration(labelText: "Language"),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          if (widget.course.instructorInfo != null)
                            Text.rich(
                              TextSpan(
                                text: "Taught by ",
                                children: [
                                  TextSpan(
                                    text: widget.course.instructorInfo?.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const TextSpan(text: " in "),
                                  TextSpan(text: widget.course.language),
                                ],
                              ),
                              style: const TextStyle(
                                fontSize: ThemeConstants.fontSizeSmall,
                              ),
                            ),
                          Row(
                            children: [
                              const Text("Featured"),
                              Expanded(
                                child: Switch.adaptive(
                                  value: widget.course.isFeatured,
                                  onChanged: (bool value) {},
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Text("Published"),
                              Expanded(
                                child: Switch.adaptive(
                                  value: widget.course.isPublished,
                                  onChanged: (bool value) {},
                                ),
                              ),
                            ],
                          ),
                          if (widget.course.instructorInfo != null)
                            const SizedBox(height: ThemeConstants.paddingSmall),
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
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.paddingSmall),
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

class ShowCourseScreenArguments {
  final Course course;

  ShowCourseScreenArguments(this.course);
}
