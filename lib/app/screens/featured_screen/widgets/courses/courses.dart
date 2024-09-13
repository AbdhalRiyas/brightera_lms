import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/screens/list_of_courses_screen.dart';
import 'package:app/app/screens/featured_screen/widgets/courses/subject_button.dart';
import 'package:flutter/material.dart';

class FeaturedCourses extends StatefulWidget {
  const FeaturedCourses({super.key});

  @override
  State<FeaturedCourses> createState() => _FeaturedCoursesState();
}

class _FeaturedCoursesState extends State<FeaturedCourses> {
  final SubjectRepository _repository = SubjectRepository();
  final GlobalKey<ListOfCoursesScreenState> _key =
      GlobalKey<ListOfCoursesScreenState>();

  List<Subject> _subjects = [];
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
    setState(() {
      _isLoading = false;
    });
  }

  void _switchSubject(Subject subject) {
    if (_selectedSubject?.id != subject.id) {
      // Calling child method using a global key
      _key.currentState?.fetchCourses(subject.id);
      setState(() {
        _selectedSubject = subject;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator.adaptive())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
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
              ListOfCoursesScreen(
                key: _key,
                subject: _selectedSubject,
                featuredCoursesOnly: true,
              ),
            ],
          );
  }
}
