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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final ValueNotifier<String?> _course = ValueNotifier('');
  final ValueNotifier<DateTime?> _startDate = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime?> _endDate = ValueNotifier(DateTime.now());

  @override
  void initState() {
    _userController.text = widget.enrollment?.user.id ?? '';
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
                        },
                      );
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
                          firstDate: DateTime(2000),
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


/*
import 'dart:developer';

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
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  final ValueNotifier<String?> _course = ValueNotifier('');
  final ValueNotifier<DateTime?> _startDate = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime?> _endDate = ValueNotifier(DateTime.now());

  List<String> numbers = [
    "94752358650",
    "94757476144",
    "94762785036",
    "94741316042",
    "94763398711",
    "94755085003",
    "94768410836",
    "94750858106",
    "94753422743",
    "94773409092",
    "94741404026",
    "94770323977",
    "94783865497",
    "94767929341",
    "94772421900",
    "94721978309",
    "94782590536",
    "94754545537",
    "94751304424",
    "94752759073",
    "94764131705",
    "94760547657",
    "94754444866",
    "94754162022",
    "94758416087",
    "94741656592",
    "94704949959",
    "94764131705",
    "94774790475",
    "94779929231",
    "94758722052",
    "94774840948",
    "94728024140",
    "94757100828",
    "94763925680",
    "94778900490",
    "94770289977",
    "94774790475",
    "94787905816",
    "94778993758",
    "94704949959",
    "94729460158",
    "94773613505",
    "94721379128",
    "94783839974",
    "94768489690",
    "94761440628",
    "94752778387",
    "94767370794",
    "94773613505",
    "94754738477",
    "94766885282",
    "94767173378",
    "94774749526",
    "94757326886",
    "94772725454",
    "94763859969",
    "94771774174",
    "94741804700",
    "94763734914",
    "94761997181",
    "94758570799",
    "94772733822",
    "94754171244",
    "94756993545",
    "94763105022",
    "94764352442",
    "94774203607",
    "94764749071",
    "94719122140",
    "94779371913",
    "94778926170",
    "94728567424",
    "94743417784",
    "94761007683",
    "94765762087",
    "94757745572",
    "94752886905",
    "94767370794",
    "94767673369",
    "94772008885",
    "94759469076",
    "94742552005",
    "94718010826",
    "94760093201",
    "94767370894",
    "94728071450",
    "94762559589",
    "94766635045",
    "94719389263",
    "94729318031",
    "94767673369",
    "94778324116",
    "94774295974",
    "94756585353",
    "94762492523",
    "94764033091",
    "94761033774",
    "94753406521",
    "94703350623",
    "94754821134",
    "94779186541",
    "94766598653",
    "94779545226",
    "94759994541",
    "94726727612",
    "94761211041",
    "94761037407",
    "94757586090",
    "94767502425",
    "94771873910",
    "94761896994",
    "94741892483",
    "94751592076",
    "94750172724",
    "94775491757",
    "94763732577",
    "94728071450",
    "94753422743",
    "94753887067",
    "94779260667",
    "94758370700",
    "94773108720",
    "94784868800",
    "94777062491",
    "94771563639",
    "94773573901",
    "94773666565",
    "94763730352",
    "94774579532",
    "94758570799",
    "94777137675",
    "94763324559",
    "94753889231",
    "94754738477",
    "94762572471",
    "94766689484",
    "94751447677",
    "94759994541",
    "94754041045",
    "94755150668",
    "94781347338",
    "94740228889",
    "94765291617",
    "94755591043",
    "94740792522",
    "94776757831",
    "94741184835",
    "94769849916",
    "94766809988",
    "94765525772",
    "94770184446",
    "94751481973",
    "94758595696",
    "94706855390",
    "94763200510",
    "94778952334",
    "94752244536",
    "94710571153",
    "94759878016",
    "94701959640",
    "94779777571",
    "94758753220",
    "94763161322",
    "94760159693",
    "94781020528",
    "94751104118",
    "94759524676",
    "94770775881",
    "94785236695",
    "94706792188",
    "94775157658",
    "94788871122",
    "94758416087",
    "94777714380",
    "94779209297",
    "94706621224",
    "94775951792",
    "94763859969",
    "94706303893",
    "94757121924",
    "94703977708",
    "94773224268",
    "94722500647",
    "94778633468",
    "94702767239",
    "94766884058",
    "94760060452",
    "94771904180",
    "94761236371",
    "94753195977",
    "94743419372",
    "94757604366",
    "94771743157",
    "94775851213",
    "94761079178",
    "94716196072",
    "94750543931",
    "94763114767",
    "94777960749",
    "94769966443",
    "94721379128",
    "94777759949",
    "94762339363",
    "94714750793",
    "94753809753",
    "94770729121",
    "94767682685",
    "94754374711",
    "94777121267",
    "94762040370",
    "94755379709",
    "94776402971",
    "94759473638",
    "94760896246",
    "94743742945",
    "94766982133",
    "94717089381",
    "94753120909",
    "94752096959",
    "94764912507",
    "94767988068",
    "94767778533",
    "94784569793",
    "94772764845",
    "94778380195",
    "94761815751",
    "94759045343",
    "94761919771",
    "94758232853",
    "94764986131",
    "94758629959",
    "94784157882",
    "94779246657",
    "94740959143",
    "94763694236",
    "94750533425",
    "94774231913",
    "94711911017",
    "94757855582",
    "94777550607",
    "94752129975",
    "94781736674",
    "94779770894",
    "94777538132",
    "94774231913",
    "94711911017"
  ];

  @override
  void initState() {
    _userController.text = widget.enrollment?.user.id ?? '';
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
                        },
                      );
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
                          firstDate: DateTime(2000),
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
                for (var number in numbers) {
                  final enrollment = Enrollment(
                    id: widget.enrollment?.id ?? '',
                    course: _courseRepository
                        .getCourseReference(_course.value!.split('/').last),
                    user: _userRepository.getUserReference(number.toString()),
                    startDate: Timestamp.fromDate(_startDate.value!),
                    endDate: Timestamp.fromDate(_endDate.value!),
                  );
                  Result result = widget.enrollment == null
                      ? await _enrollmentRepository.addEnrollment(enrollment)
                      : await _enrollmentRepository
                          .updateEnrollment(enrollment);

                  log(result.data);
                  if (result.isSuccess) {
                    // Navigator.pop(context);
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     backgroundColor: Colors.green,
                    //     content: widget.enrollment == null
                    //         ? const Text('Enrollment added successfully')
                    //         : const Text('Enrollment updated successfully'),
                    //   ),
                    // );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.error ?? ''),
                      ),
                    );
                  }
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

*/