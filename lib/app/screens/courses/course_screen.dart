import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/screens/checkout_screen.dart';
import 'package:app/app/screens/courses/widgets/course_cover.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:app/app/widgets/syllabus/syllabus_accordion.dart';
import 'package:app/app/screens/lectures_screen/lectures_screen.dart';
import 'package:app/app/utils/format_price.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final CourseRepository _repository = CourseRepository();
  final ValueNotifier<bool> _activeSubscription = ValueNotifier(false);

  @override
  void initState() {
    _checkActiveSubscription();
    super.initState();
  }

  void _checkActiveSubscription() async {
    _activeSubscription.value =
        await _repository.checkActiveEnrollment(widget.course.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<User?>(
          stream: FirebaseService().authStateChanges,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
              child: ListView(
                children: [
                  CourseCover(course: widget.course),
                  const SizedBox(height: ThemeConstants.paddingSmall),
                  Text(
                    widget.course.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.paddingSmall),
                  Text(
                    widget.course.description,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.paddingSmall),
                  if (widget.course.instructorInfo != null)
                    Text.rich(
                      TextSpan(
                        text: "Taught by ",
                        children: [
                          TextSpan(
                            text: widget.course.instructorInfo?.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const TextSpan(text: " in "),
                          TextSpan(text: widget.course.language),
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: ThemeConstants.fontSizeSmall,
                      ),
                    ),
                  if (widget.course.instructorInfo != null)
                    const SizedBox(height: ThemeConstants.paddingSmall),
                  Text(
                    formatPrice(widget.course.salePrice),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.paddingSmall),
                  ValueListenableBuilder<bool>(
                      valueListenable: _activeSubscription,
                      builder: (context, hasEnrolled, ch) {
                        return ElevatedButton(
                          onPressed: () => hasEnrolled
                              ? Navigator.pushNamed(context, '/lectures',
                                  arguments:
                                      LecturesArguments(course: widget.course))
                              : Navigator.pushNamed(context, '/checkout',
                                  arguments:
                                      CheckoutScreenArguments([widget.course])),
                          child: Text(
                            hasEnrolled ? "Go to lectures" : "Enroll Now",
                            style: const TextStyle(
                              fontSize: 16,
                              color: ThemeConstants.primaryButtonTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                  const SizedBox(height: ThemeConstants.paddingLarge),
                  const Text(
                    "Syllabus",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SyllabusAccordion(
                    course: widget.course,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class CourseScreenArguments {
  final Course course;

  CourseScreenArguments(this.course);
}
