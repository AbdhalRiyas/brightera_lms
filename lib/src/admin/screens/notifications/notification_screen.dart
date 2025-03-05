import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/toggle_loader.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ValueNotifier<String?> _courseId = ValueNotifier<String?>(null);
  final CourseRepository _courseRepository = CourseRepository();
  final FirebaseService _firebaseService = FirebaseService();
  final List<Course> _courses = [];
  final _formKey = GlobalKey<FormState>();

  bool _isSending = false;

  Future<void> _getCourses() async {
    final courses = await _courseRepository.getCourses();
    _courses.addAll(courses);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter your message here',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Send to all users or select a course to send enrolled students',
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _courseId,
                builder: (context, courseId, _) {
                  return DropdownButtonFormField<String>(
                    value: courseId,
                    onChanged: (value) {
                      _courseId.value = value;
                    },
                    items: _courses
                        .map((course) => DropdownMenuItem<String>(
                              value: course.id,
                              child: SizedBox(
                                width: 200, // Adjust based on your layout
                                child: Text(
                                  course.title,
                                  overflow: TextOverflow
                                      .ellipsis, // Truncates long text
                                ),
                              ),
                            ))
                        .toList(),
                    decoration: const InputDecoration(
                      labelText: 'Course',
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Flexible(
                // Now correctly inside the Column
                child: ElevatedButton(
                  onPressed: _isSending
                      ? null
                      : () async {
                          setState(() {
                            _isSending = true;
                          });

                          if (_formKey.currentState!.validate()) {
                            showLoader(context, 'Sending notification...');

                            try {
                              _courseId.value != null
                                  ? await _firebaseService
                                      .sendNotificationToEnrolledUsersByCourse(
                                      courseId: _courseId.value!,
                                      title: _titleController.text,
                                      body: _descriptionController.text,
                                    )
                                  : await _firebaseService
                                      .sendNotificationToAll(
                                      title: _titleController.text,
                                      body: _descriptionController.text,
                                    );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Notification sent successfully'),
                                ),
                              );

                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Failed to send notification: $e'),
                                ),
                              );
                            } finally {
                              Navigator.of(context)
                                  .pop(); // Close the loading dialog
                            }
                          }

                          setState(() {
                            _isSending = false;
                          });
                        },
                  child: const Text('Send Notification'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
