import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class MyLearningScreen extends StatefulWidget {
  const MyLearningScreen({super.key});

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> {
  final List<String> tabs = ["All", "Active", "Expired"];
  final List<Course> courses = [];
  final ValueNotifier<int> selectedTab = ValueNotifier(0);

  void switchTab(int index) {
    if (selectedTab.value != index) {
      selectedTab.value = index;
    }
  }

  void fetchCourses() async {
    final List<Course> allCourses = await CourseRepository().getCourses();
    setState(() {
      courses.addAll(allCourses);
    });
  }

  @override
  initState() {
    super.initState();
    fetchCourses();
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
                valueListenable: selectedTab,
                builder: (context, value, child) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: tabs.length,
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
                          tabs[index],
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
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  return CourseCard(
                    course: courses[index],
                    listMode: true,
                    isEnrolled: true,
                    isActive: true,
                    progress: 0.5,
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
