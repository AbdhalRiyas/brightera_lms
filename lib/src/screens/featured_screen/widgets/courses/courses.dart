import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/screens/courses/show_course_screen.dart';
import 'package:app/src/screens/courses/all_courses_screen.dart';
import 'package:app/src/widgets/course_card/course_card.dart';
import 'package:flutter/material.dart';

class FeaturedCourses extends StatefulWidget {
  const FeaturedCourses({super.key});

  @override
  State<FeaturedCourses> createState() => _FeaturedCoursesState();
}

class _FeaturedCoursesState extends State<FeaturedCourses> {
  final List<String> languages = ['All', 'English', 'தமிழ்', 'සිංහල'];
  final ValueNotifier<String> _selectedLanguage = ValueNotifier('All');
  final CourseRepository _repository = CourseRepository();

  void _switchLanguage(String language) {
    if (_selectedLanguage.value != language) {
      _selectedLanguage.value = language;
      setState(() {});
    }
  }

  Future<List<Course>> fetchFeaturedCourses() async {
    return await _repository.getFeaturedCoursesByLanguage(
      _selectedLanguage.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Featured Courses",
          style: ThemeConstants.headingStyle,
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder<String>(
          valueListenable: _selectedLanguage,
          builder: (context, selectedLanguage, child) {
            return SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: languages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: FilterChip(
                      showCheckmark: false,
                      label: Text(
                        languages[index],
                        style: TextStyle(
                          color: selectedLanguage == languages[index]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      selected: selectedLanguage == languages[index],
                      onSelected: (bool selected) {
                        _switchLanguage(languages[index]);
                      },
                      selectedColor: ThemeConstants.primaryColor,
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        FutureBuilder<List<Course>>(
          future: fetchFeaturedCourses(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text("Error loading courses.");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No courses have been featured in this language yet.",
                ),
              );
            } else {
              final courses = snapshot.data!;
              return SizedBox(
                height: 250,
                child: LayoutBuilder(builder: (context, constraints) {
                  return ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) => i == courses.length
                        ? SizedBox(
                            width: constraints.maxWidth <= 400
                                ? constraints.maxWidth / 2
                                : 250,
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(
                                context,
                                '/all-courses',
                                arguments: ListOfCoursesScreenArguments(
                                  language: _selectedLanguage.value,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      ThemeConstants.borderRadiusLarge),
                                ),
                              ),
                              child: const Text(
                                "See All",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                        : CourseCard(
                            course: courses[i],
                            maxWidth: 450,
                            maxHeight: 250,
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/course',
                              arguments: CourseScreenArguments(courses[i]),
                            ),
                          ),
                    separatorBuilder: (context, i) => const SizedBox(width: 10),
                    itemCount: courses.length + 1,
                  );
                }),
              );
            }
          },
        ),
      ],
    );
  }
}

  // final GlobalKey<ListOfCoursesScreenState> _key =
  //     GlobalKey<ListOfCoursesScreenState>();

  // List<Subject> _subjects = [];
  // bool _isLoading = true;
  // Subject? _selectedSubject;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchSubjects();
  // }

  // Future<void> _fetchSubjects() async {
  //   final subjects = await _repository.getAllSubjects();
  //   _subjects = subjects;
  //   _selectedSubject = _subjects.first;
  //   _key.currentState?.fetchCourses(_subjects.first.id);
  //   if (mounted) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  // void _switchSubject(Subject subject) {
  //   if (_selectedSubject?.id != subject.id) {
  //     // Calling child method using a global key
  //     _key.currentState?.fetchCourses(subject.id);
  //     if (mounted) {
  //       setState(() {
  //         _selectedSubject = subject;
  //       });
  //     }
  //   }
  // }


      // const SizedBox(height: 10),
            // if (_subjects.length > 1) ...[
            //   SizedBox(
            //     height: 38,
            //     child: ListView.separated(
            //       scrollDirection: Axis.horizontal,
            //       shrinkWrap: true,
            //       itemCount: _subjects.length,
            //       itemBuilder: (context, i) => SubjectButton(
            //         onTap: () => _switchSubject(_subjects[i]),
            //         selectedSubject: _selectedSubject?.id ?? '',
            //         subject: _subjects[i],
            //       ),
            //       separatorBuilder: (BuildContext context, int index) =>
            //           const SizedBox(
            //         width: 10,
            //       ),
            //     ),
            //   ),
            //   const SizedBox(height: 20),
            // ],
            // ListOfCoursesScreen(
            //   key: _key,
            //   language: _selectedLanguage,
            //   // subject: _selectedSubject,
            //   featuredCoursesOnly: true,
            // ),