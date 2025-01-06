import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  final List<Course> _courses = [];

  Future<void> _loadCourses() async {
    final result = await _courseRepository.getCourses();
    if (result.isNotEmpty) {
      setState(() {
        _courses.clear();
        _courses.addAll(result);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(ThemeConstants.paddingMedium),
        child: SearchAnchor(
          viewBackgroundColor: Colors.white,
          viewShape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(ThemeConstants.borderRadiusMedium),
          ),
          builder: (BuildContext context, SearchController controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(
                  ThemeConstants.borderRadiusMedium,
                ),
              ),
              child: SearchBar(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      ThemeConstants.borderRadiusMedium,
                    ),
                  ),
                ),
                padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(
                    horizontal: ThemeConstants.paddingMedium,
                  ),
                ),
                controller: controller,
                onChanged: (text) {
                  controller.openView();
                },
                leading: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search Courses',
              ),
            );
          },
          suggestionsBuilder: (context, controller) {
            final suggestions = _courses
                .where((course) => course.title
                    .toLowerCase()
                    .contains(controller.text.toLowerCase()))
                .toList();
            return List<ListTile>.generate(
              suggestions.length,
              (index) {
                final course = suggestions[index];
                return ListTile(
                  title: Text(
                    course.title,
                  ),
                  onTap: () {
                    controller.text = course.title;
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: ThemeConstants.paddingSmall,
                    horizontal: ThemeConstants.paddingMedium,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
