import 'package:app/src/models/enrollment.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/repositories/enrollment_repository.dart';
import 'package:app/src/repositories/user_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnrollmentAddEditDialog extends StatefulWidget {
  const EnrollmentAddEditDialog({
    super.key,
    this.enrollment,
  });

  final Enrollment? enrollment;

  @override
  State<EnrollmentAddEditDialog> createState() =>
      _EnrollmentAddEditDialogState();
}

class _EnrollmentAddEditDialogState extends State<EnrollmentAddEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final CourseRepository _courseRepository = CourseRepository();
  final UserRepository _userRepository = UserRepository();
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final ValueNotifier<String?> _course = ValueNotifier('');
  final ValueNotifier<DateTime?> _startDate = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime?> _endDate = ValueNotifier(DateTime.now());

  @override
  void initState() {
    _userController.text = widget.enrollment?.user.id ?? '';
    _statusController.text = widget.enrollment?.status ?? '';
    _startDateController.text =
        widget.enrollment?.startDate.toDate().toString() ?? '';
    _endDateController.text =
        widget.enrollment?.endDate.toDate().toString() ?? '';
    _course.value = widget.enrollment?.course.path;
    _startDate.value = widget.enrollment?.startDate.toDate();
    _endDate.value = widget.enrollment?.endDate.toDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: AlertDialog(
        title: const Text('Add Enrollment'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Prevent unnecessary expansion
              children: [
                FutureBuilder(
                  future: _courseRepository.getCourses(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (snapshot.hasData) {
                      return DropdownSearch<String>(
                          mode: Mode.form,
                          items: (filter, loadProps) => snapshot.data!
                              .map((course) => course.title)
                              .toList(),
                          selectedItem: snapshot.data!
                              .firstWhere(
                                (course) =>
                                    "courses/${course.id}" == _course.value,
                                orElse: () => snapshot.data!.first,
                              )
                              .title,
                          popupProps: const PopupPropsMultiSelection.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Search courses",
                              ),
                            ),
                          ),
                          decoratorProps: const DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: "Select Courses",
                              hintText: "Search and select courses",
                            ),
                          ),
                          onChanged: (String? selectedTitle) {
                            final selectedCourse = snapshot.data!.firstWhere(
                              (course) => course.title == selectedTitle,
                            );
                            _course.value = "courses/${selectedCourse.id}";
                          });
                    } else {
                      return const Center(
                        child: Text("Couldn't fetch courses"),
                      );
                    }
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'User',
                    hintText: '94712345678',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: _userController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Status', hintText: 'active, expired'),
                  controller: _statusController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a status';
                    }
                    return null;
                  },
                ),
                ValueListenableBuilder<DateTime?>(
                  valueListenable: _startDate,
                  builder: (context, value, child) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                      ),
                      controller: _startDateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: value ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          _startDate.value = pickedDate;
                          _startDateController.text = pickedDate.toString();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a start date';
                        }
                        return null;
                      },
                    );
                  },
                ),
                ValueListenableBuilder<DateTime?>(
                  valueListenable: _endDate,
                  builder: (context, value, child) {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                      ),
                      controller: _endDateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: value ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          _endDate.value = pickedDate;
                          _endDateController.text = pickedDate.toString();
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an end date';
                        }
                        return null;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (_course.value == null || _course.value!.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Please select a course'),
                  ),
                );
                return;
              }
              if (_formKey.currentState!.validate()) {
                final enrollment = Enrollment(
                  id: widget.enrollment?.id ?? '',
                  course: _courseRepository
                      .getCourseReference(_course.value!.split('/').last),
                  user: _userRepository.getUserReference(_userController.text),
                  status: _statusController.text,
                  startDate: Timestamp.fromDate(_startDate.value!),
                  endDate: Timestamp.fromDate(_endDate.value!),
                );
                Result result = widget.enrollment == null
                    ? await _enrollmentRepository.addEnrollment(enrollment)
                    : await _enrollmentRepository.updateEnrollment(enrollment);
                if (result.isSuccess) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: widget.enrollment == null
                          ? const Text('Enrollment added successfully')
                          : const Text('Enrollment updated successfully'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result.error ?? ''),
                    ),
                  );
                }
              }
            },
            child: Text(
              widget.enrollment == null ? 'Add' : 'Update',
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
