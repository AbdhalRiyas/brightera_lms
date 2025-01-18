import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/subject.dart';
import 'package:app/src/repositories/subject_repository.dart';
import 'package:app/src/screens/list_of_courses_screen.dart';
import 'package:app/src/screens/featured_screen/widgets/courses/subject_button.dart';
import 'package:flutter/material.dart';

class FeaturedCourses extends StatefulWidget {
  const FeaturedCourses({super.key});

  @override
  State<FeaturedCourses> createState() => _FeaturedCoursesState();
}

class _FeaturedCoursesState extends State<FeaturedCourses> {
  final SubjectRepository _repository = SubjectRepository();
  final List<String> languages = ['All', 'English', 'தமிழ்', 'සිංහල'];

  final GlobalKey<ListOfCoursesScreenState> _key =
      GlobalKey<ListOfCoursesScreenState>();

  List<Subject> _subjects = [];
  String _selectedLanguage = 'All';
  bool _isLoading = true;
  Subject? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    final subjects = await _repository.getAllSubjects();
    _subjects = subjects;
    _selectedSubject = _subjects.first;
    _key.currentState?.fetchCourses(_subjects.first.id);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _switchSubject(Subject subject) {
    if (_selectedSubject?.id != subject.id) {
      // Calling child method using a global key
      _key.currentState?.fetchCourses(subject.id);
      if (mounted) {
        setState(() {
          _selectedSubject = subject;
        });
      }
    }
  }

  void _switchLanguage(String language) {
    if (_selectedLanguage != language) {
      if (mounted) {
        setState(() {
          _selectedLanguage = language;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Featured Courses",
                style: ThemeConstants.headingStyle,
              ),
              const SizedBox(height: 10),
              SizedBox(
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
                            color: _selectedLanguage == languages[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: _selectedLanguage == languages[index],
                        onSelected: (bool selected) {
                          _switchLanguage(languages[index]);
                        },
                        selectedColor: ThemeConstants.primaryColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              if (_subjects.length > 1) ...[
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _subjects.length,
                    itemBuilder: (context, i) => SubjectButton(
                      onTap: () => _switchSubject(_subjects[i]),
                      selectedSubject: _selectedSubject?.id ?? '',
                      subject: _subjects[i],
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              ListOfCoursesScreen(
                key: _key,
                subject: _selectedSubject,
                featuredCoursesOnly: true,
              ),
            ],
          );
  }
}
