import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/screens/courses/widgets/syllabus_accordion.dart';
import 'package:app/app/screens/lectures_screen/widgets/youtube_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key, required this.course});

  final Course course;

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'iLnmTe5Q2Qw',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    _controller.addListener(_ytPlayerListener);
  }

  void _ytPlayerListener() {
    if (mounted) {
      if (_controller.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller.value.isFullScreen;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_ytPlayerListener);
    _controller.dispose();
    super.dispose();
  }

  void _replayBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 10);
    _controller.seekTo(newPosition < const Duration(seconds: 0)
        ? const Duration(seconds: 0)
        : newPosition);
  }

  void _skipForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + const Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Visibility(
        visible: !_isFullScreen,
        maintainState: true,
        child: BottomNavigationBar(
          currentIndex: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Tab 1'),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Tab 2'),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: 'Tab 3'),
          ],
        ),
      ),
      body: SafeArea(
        right: !_isFullScreen,
        left: !_isFullScreen,
        child: Column(
          children: [
            Flexible(
              child: YoutubePlayerWidget(
                controller: _controller,
                onReplayBackward: _replayBackward,
                onSkipForward: _skipForward,
              ),
            ),
            Visibility(
              visible: !_isFullScreen,
              maintainState: true,
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SyllabusAccordion(course: widget.course),
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
