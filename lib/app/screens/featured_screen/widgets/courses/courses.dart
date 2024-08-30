import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/screens/featured_screen/widgets/courses/list_of_courses.dart';
import 'package:app/app/screens/featured_screen/widgets/courses/subject_button.dart';
import 'package:flutter/material.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final SubjectRepository _repository = SubjectRepository();
  final GlobalKey<ListOfCoursesState> _key = GlobalKey<ListOfCoursesState>();

  List<Subject> _subjects = [];
  bool _isLoading = true;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    final subjects = await _repository.getAllSubjects();
    _subjects = subjects;
    _selectedSubject = _subjects.first.id;
    _key.currentState?.fetchCourses(_subjects.first.id);
    setState(() {
      _isLoading = false;
    });
  }

  void _switchSubject(String subectId) {
    if (_selectedSubject != subectId) {
      // Calling child method using a global key
      _key.currentState?.fetchCourses(subectId);
      setState(() {
        _selectedSubject = subectId;
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
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: ThemeConstants.paddingMedium),
                child: SizedBox(
                  height: 50,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: _subjects.length,
                    itemBuilder: (context, i) => SubjectButton(
                      onTap: () => _switchSubject(_subjects[i].id),
                      selectedSubject: _selectedSubject ?? '',
                      subject: _subjects[i],
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
              ),
              ListOfCourses(
                key: _key,
                subjectId: _selectedSubject ?? '',
              ),
            ],
          );
  }
}
