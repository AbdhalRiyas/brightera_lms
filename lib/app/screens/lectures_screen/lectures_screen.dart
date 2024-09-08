import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/screens/courses/widgets/syllabus_accordion.dart';
import 'package:app/app/screens/lectures_screen/widgets/lecture_video_player.dart';
import 'package:flutter/material.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key, required this.course});

  final Course course;

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  final CourseRepository _repository = CourseRepository();
  bool _isFullScreen = false;
  List<Section> _sections = [];

  @override
  void initState() {
    _fetchSectionsAndLectures();
    super.initState();
  }

  void _toggleFullScreen(bool isFullScreen) {
    if (isFullScreen != _isFullScreen) {
      setState(() {
        _isFullScreen = isFullScreen;
      });
    }
  }

  void _fetchSectionsAndLectures() async {
    _sections = await _repository.fetchSectionsForCourse(widget.course.id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: !_isFullScreen,
        child: BottomNavigationBar(
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'dwdw'),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'dwdw'),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'dwdw'),
          ],
        ),
      ),
      // appBar: AppBar(),
      body: SafeArea(
        left: !_isFullScreen,
        right: !_isFullScreen,
        bottom: !_isFullScreen,
        top: !_isFullScreen,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: LectureVideoPlayer(
                toggleFullScreen: _toggleFullScreen,
              ),
            ),
            if (!_isFullScreen)
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      if (_sections.isNotEmpty)
                        SyllabusAccordion(
                          sections: _sections,
                          course: widget.course,
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class LecturesArguments {
  final Course course;

  const LecturesArguments({required this.course});
}
