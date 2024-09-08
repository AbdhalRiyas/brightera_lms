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
  final PageStorageKey _syllabusKey = const PageStorageKey('syllabus_key');
  final ScrollController _syllabusScrollController = ScrollController();
  double _syllabusScrollViewOffset = 0.00;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.course.previewVideo) ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _controller.addListener(_ytPlayerListener);
    _syllabusScrollController.addListener(_syllabusScrollListener);
  }

  void _ytPlayerListener() {
    if (mounted) {
      if (_controller.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller.value.isFullScreen;
        });

        if (!_controller.value.isFullScreen) {
          _syllabusScrollController.animateTo(
            _syllabusScrollViewOffset,
            curve: Curves.bounceIn,
            duration: const Duration(milliseconds: 500),
          );
        }
      }
    }
  }

  void _syllabusScrollListener() {
    _syllabusScrollViewOffset = _syllabusScrollController.offset;
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
              flex: 4,
              child: YoutubePlayerWidget(
                controller: _controller,
                onReplayBackward: _replayBackward,
                onSkipForward: _skipForward,
              ),
            ),
            Flexible(
              flex: _isFullScreen ? 0 : 8,
              child: Visibility(
                visible: !_isFullScreen,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
                  child: ListView(
                    controller: _syllabusScrollController,
                    shrinkWrap: true,
                    children: [
                      SyllabusAccordion(
                        key: _syllabusKey,
                        course: widget.course,
                        youtubePlayerController: _controller,
                      ),
                    ],
                  ),
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
