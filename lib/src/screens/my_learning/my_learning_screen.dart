import 'dart:developer';

import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/route/screen_exports.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class MyLearningScreen extends StatefulWidget {
  const MyLearningScreen({super.key});

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  final List<String> _tabs = ["All", "Active", "Expired"];
  final List _enrollments = [];
  final List<Course> _courses = [];
  final ValueNotifier<int> _selectedTab = ValueNotifier(0);

  void switchTab(int index) {
    if (_selectedTab.value != index) {
      _selectedTab.value = index;
    }
  }

  void fetchEnrolledCourses() async {
    final enrollments = await _courseRepository.getEnrollments();
    setState(() {
      _enrollments.addAll(enrollments);
    });
    log(_enrollments.toString());
    final enrolledCourses = await _courseRepository.getEnrolledCourses();
    setState(() {
      _courses.addAll(enrolledCourses);
    });
  }

  @override
  initState() {
    super.initState();
    fetchEnrolledCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Learning'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.paddingSmall,
        ),
        child: Column(
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: ValueListenableBuilder<int>(
                valueListenable: _selectedTab,
                builder: (context, value, child) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      return FilterChip(
                        color: WidgetStateProperty.all(
                          value == index
                              ? ThemeConstants.primaryColor
                              : Colors.white,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.paddingLarge,
                          vertical: ThemeConstants.paddingSmall,
                        ),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ThemeConstants.borderRadiusLarge * 2,
                          ),
                        ),
                        showCheckmark: false,
                        label: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: value == index ? Colors.white : Colors.black,
                            fontSize: ThemeConstants.fontSizeMedium,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        selected: value == index,
                        onSelected: (bool selected) {
                          switchTab(index);
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: ThemeConstants.paddingSmall);
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return CourseCard(
                    course: _courses[index],
                    listMode: true,
                    isEnrolled: true,
                    expiresAt: _enrollments[index]['endDate']
                        .toDate()
                        .difference(DateTime.now())
                        .inDays,
                    isActive: _enrollments[index]['status'] == 'active'
                        ? true
                        : false,
                    progress: _courses[index].sections != null
                        ? _courses[index].sections!.length.toDouble()
                        : 0,
                    onTap: () {
                      print(_courses[index].sections);
                      Navigator.pushNamed(
                        context,
                        '/course',
                        arguments: CourseScreenArguments(
                          _courses[index],
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
