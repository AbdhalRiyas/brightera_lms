import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class ListOfSubjects extends StatefulWidget {
  const ListOfSubjects({super.key});

  @override
  State<ListOfSubjects> createState() => _ListOfSubjectsState();
}

class _ListOfSubjectsState extends State<ListOfSubjects> {
  final SubjectRepository _subjectRepository = SubjectRepository();
  final CourseRepository _courseRepository = CourseRepository();

  List<Subject> _subjects = [];
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    final subjects = await _subjectRepository.getAllSubjects();
    _subjects = subjects;
    _fetchCourses(_subjects.first.id);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchCourses(String subjectId) async {
    _selectedSubject = subjectId;
    final courses = await _courseRepository.getCoursesBySubject(subjectId);
    setState(() {
      _courses = courses;
    });
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
                    itemBuilder: (context, i) => GestureDetector(
                      onTap: _selectedSubject == _subjects[i].id
                          ? null
                          : () => _fetchCourses(_subjects[i].id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.paddingLarge),
                        decoration: BoxDecoration(
                          color: _getPillBackgroundColor(_subjects[i].id),
                          border: Border.all(
                              width: 1 / 2,
                              color: _getPillBorderColor(_subjects[i].id)),
                          borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge * 2),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              if (_subjects[i].icon.startsWith('https://'))
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: ThemeConstants.paddingSmall),
                                  child: SvgPicture.network(
                                    _subjects[i].icon,
                                    width: 24,
                                    colorFilter: ColorFilter.mode(
                                        _getPillTextColor(_subjects[i].id),
                                        BlendMode.srcIn),
                                  ),
                                ),
                              Text(
                                _subjects[i].name,
                                style: TextStyle(
                                  color: _getPillTextColor(_subjects[i].id),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(
                      width: 10,
                    ),
                  ),
                ),
              ),
              _courses.isNotEmpty
                  ? SizedBox(
                      height: 150,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) => AnimatedContainer(
                            width: constraints.maxWidth / 2,
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: ThemeConstants
                                  .lavenderMist, // Change this as needed
                              borderRadius: BorderRadius.circular(
                                  ThemeConstants.borderRadiusLarge * 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  ThemeConstants.paddingLarge),
                              child: Text(
                                _courses[i].title,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: ThemeConstants.fontSizeMedium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, i) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: _courses.length,
                        );
                      }),
                    )
                  : const Text(
                      "No Courses Have Been Added For This Subject",
                    ),
            ],
          );
  }

  Color _getPillBorderColor(String id) {
    return id == _selectedSubject ? ThemeConstants.primaryColor : Colors.black;
  }

  Color _getPillBackgroundColor(String id) {
    return id == _selectedSubject
        ? ThemeConstants.primaryButtonColor
        : Colors.transparent;
  }

  Color _getPillTextColor(String id) {
    return id == _selectedSubject
        ? ThemeConstants.primaryButtonTextColor
        : Colors.black;
  }
}
