import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/active_lesson.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/screens/lectures_screen/widgets/downloads_tab.dart';
import 'package:app/app/screens/lectures_screen/widgets/lecture_notes_tab.dart';
import 'package:app/app/widgets/bottom_navigation_icon.dart';
import 'package:app/app/widgets/syllabus/syllabus_accordion.dart';
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
  final GlobalKey<SyllabusAccordionState> _syllabusKey =
      GlobalKey<SyllabusAccordionState>();
  final ScrollController _syllabusScrollController = ScrollController();
  final ValueNotifier<ActiveLesson> _activeLessonVideoId =
      ValueNotifier(const ActiveLesson());
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  final PageController _pageController = PageController();

  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  double _syllabusScrollViewOffset = 0.00;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.course.previewVideo) ?? '',
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
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

  void _switchTab(int index) {
    if (index != _selectedIndex.value) {
      _selectedIndex.value = index;

      _pageController.jumpToPage(index);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_ytPlayerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        right: !_isFullScreen,
        left: !_isFullScreen,
        bottom: !_isFullScreen,
        top: !_isFullScreen,
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Flexible(
                flex: _isFullScreen
                    ? int.parse((constraints.maxHeight).toStringAsFixed(0))
                    : int.parse(
                        (constraints.maxHeight * 0.8).toStringAsFixed(0)),
                child: YoutubePlayerWidget(
                  controller: _controller,
                  nextVideo: () {
                    _syllabusKey.currentState?.nextLesson();
                  },
                ),
              ),
              Flexible(
                flex: _isFullScreen
                    ? 0
                    : constraints.maxHeight < 540
                        ? int.parse(
                            (constraints.maxHeight * 1).toStringAsFixed(0))
                        : int.parse(
                            (constraints.maxHeight * 1.6).toStringAsFixed(0)),
                child: Visibility(
                  visible: !_isFullScreen,
                  maintainState: true,
                  child: Padding(
                    padding: const EdgeInsets.all(ThemeConstants.paddingSmall),
                    child: ValueListenableBuilder<int>(
                        valueListenable: _selectedIndex,
                        builder: (context, selectedIndex, child) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ListView(
                                  controller: _syllabusScrollController,
                                  children: [
                                    SyllabusAccordion(
                                      key: _syllabusKey,
                                      course: widget.course,
                                      youtubePlayerController: _controller,
                                      activeLessonVideoId: _activeLessonVideoId,
                                    ),
                                  ],
                                ),
                                ValueListenableBuilder<ActiveLesson>(
                                    valueListenable: _activeLessonVideoId,
                                    builder: (context, value, ch) {
                                      return LectureNotesTab(
                                        pdfUrl: value.notes,
                                      );
                                    }),
                                ValueListenableBuilder<ActiveLesson>(
                                    valueListenable: _activeLessonVideoId,
                                    builder: (context, value, ch) {
                                      return DownloadsTab(
                                        downloads: value.downloads,
                                      );
                                    }),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: Visibility(
        visible: !_isFullScreen,
        maintainState: true,
        child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (context, selectedIndex, child) {
              return BottomNavigationBar(
                useLegacyColorScheme: false,
                selectedLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
                backgroundColor: ThemeConstants.backgroundColor,
                elevation: 0,
                type: BottomNavigationBarType.fixed,
                currentIndex: selectedIndex,
                onTap: (value) => _switchTab(value),
                items: [
                  BottomNavigationBarItem(
                    icon: BottomNavigationIcon(
                      path: "assets/icons/play.svg",
                      isActive: selectedIndex == 0,
                    ),
                    label: 'Lectures',
                  ),
                  BottomNavigationBarItem(
                      icon: ValueListenableBuilder<ActiveLesson>(
                          valueListenable: _activeLessonVideoId,
                          builder: (context, value, ch) {
                            return BottomNavigationIcon(
                              hasNotes: value.notes.isNotEmpty,
                              path: "assets/icons/notes.svg",
                              isActive: selectedIndex == 1,
                            );
                          }),
                      label: 'Notes'),
                  BottomNavigationBarItem(
                      icon: ValueListenableBuilder<ActiveLesson>(
                          valueListenable: _activeLessonVideoId,
                          builder: (context, value, ch) {
                            return BottomNavigationIcon(
                              hasNotes: value.downloads.isNotEmpty,
                              path: "assets/icons/downloads.svg",
                              isActive: selectedIndex == 2,
                            );
                          }),
                      label: 'Downloads'),
                ],
              );
            }),
      ),
    );
  }
}

class LecturesArguments {
  final Course course;

  const LecturesArguments({required this.course});
}
