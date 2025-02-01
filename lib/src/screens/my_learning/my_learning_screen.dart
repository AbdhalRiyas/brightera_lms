import 'dart:developer';
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/route/screen_exports.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyLearningScreen extends StatefulWidget {
  const MyLearningScreen({super.key});

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  final List<String> _tabs = ["Active", "Expired"];
  final ValueNotifier<int> _selectedTab = ValueNotifier(0);
  final List<Map<String, dynamic>?> _enrollments = [];
  final List<Course> _courses = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    fetchEnrolledCourses();
    _scrollController.addListener(_scrollListener);
  }

  void switchTab(int index) {
    if (_selectedTab.value != index) {
      _selectedTab.value = index;
      fetchEnrolledCourses(reset: true);
    }
  }

  Future<void> fetchEnrolledCourses({bool reset = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    if (reset) {
      setState(() {
        _enrollments.clear();
        _courses.clear();
        _lastDocument = null;
        _hasMore = true;
      });
    }

    final status = _tabs[_selectedTab.value].toLowerCase();

    try {
      final enrollments = await _courseRepository.getEnrollments(status,
          limit: _limit, lastDoc: _lastDocument);
      final enrolledCourses = await _courseRepository.getEnrolledCourses(status,
          limit: _limit, lastDoc: _lastDocument);

      if (enrollments.isNotEmpty) {
        setState(() {
          _enrollments.addAll(enrollments);
          _courses.addAll(enrolledCourses);
          _lastDocument = enrollments
              .last['docSnapshot']; // Store last document for pagination
        });
      } else {
        setState(() => _hasMore = false);
      }
    } catch (e) {
      log("Error fetching courses: $e");
    }

    setState(() => _isLoading = false);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isLoading) {
        fetchEnrolledCourses();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Learning'),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: ThemeConstants.paddingSmall),
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
                controller: _scrollController,
                itemCount: _courses.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _courses.length) {
                    return const Center(
                      heightFactor: 4,
                      child: CircularProgressIndicator(),
                    );
                  }

                  final courseId = _courses[index].id;
                  final enrollment = _enrollments.firstWhere(
                      (e) => e!['courseId'].id == courseId,
                      orElse: () => null);

                  return CourseCard(
                    course: _courses[index],
                    listMode: true,
                    isEnrolled: true,
                    expiresAt: enrollment?['endDate']
                            ?.toDate()
                            ?.difference(DateTime.now())
                            .inDays ??
                        0,
                    isActive: enrollment?['status'] == 'active',
                    progress: _courses[index].sections != null
                        ? _courses[index].sections!.length.toDouble()
                        : 0,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/course',
                        arguments: CourseScreenArguments(_courses[index]),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
