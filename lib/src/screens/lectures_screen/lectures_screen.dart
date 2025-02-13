import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/active_lesson.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/screens/lectures_screen/widgets/downloads_tab.dart';
import 'package:app/src/screens/lectures_screen/widgets/lecture_notes_tab.dart';
import 'package:app/src/screens/lectures_screen/widgets/lecture_tab_bar.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/widgets/syllabus/syllabus_accordion.dart';
import 'package:app/src/screens/lectures_screen/widgets/youtube_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LecturesArguments {
  final Course course;

  const LecturesArguments({required this.course});
}

class LecturesScreen extends StatefulWidget {
  const LecturesScreen({super.key, required this.course});

  final Course course;

  @override
  State<LecturesScreen> createState() => _LecturesScreenState();
}

class _LecturesScreenState extends State<LecturesScreen>
    with TickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  final GlobalKey<SyllabusAccordionState> _syllabusKey =
      GlobalKey<SyllabusAccordionState>();

  final ScrollController _syllabusScrollController = ScrollController();
  final PageController _pageController = PageController();
  late TabController _tabController;

  final ValueNotifier<ActiveLesson> _activeLesson =
      ValueNotifier(const ActiveLesson());
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  bool _isFullScreen = false;
  double _syllabusScrollViewOffset = 0.00;

  Future<Box>? _courseProgressBox;

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _courseProgressBox = Hive.openBox(
        "${_firebaseService.currentUser?.uid}_${widget.course.id}"); // used to store student's progress locally

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        right: !_isFullScreen,
        left: !_isFullScreen,
        bottom: !_isFullScreen,
        top: !_isFullScreen,
        child: FutureBuilder(
          future: _courseProgressBox,
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          Flexible(
                            flex: _isFullScreen
                                ? int.parse(
                                    (constraints.maxHeight).toStringAsFixed(0))
                                : int.parse((constraints.maxHeight * 0.8)
                                    .toStringAsFixed(0)),
                            child: YoutubePlayerWidget(
                              controller: _controller,
                              prevVideo: () =>
                                  _syllabusKey.currentState?.prevLesson(),
                              nextVideo: () =>
                                  _syllabusKey.currentState?.nextLesson(),
                            ),
                          ),
                          if (!_isFullScreen)
                            Padding(
                              padding: const EdgeInsets.all(
                                ThemeConstants.paddingSmall,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.course.title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: ThemeConstants.paddingSmall),
                                  if (widget.course.instructorInfo != null)
                                    Text(
                                      "By - ${widget.course.instructorInfo?.name}",
                                      style: TextStyle(
                                        fontSize: ThemeConstants.fontSizeSmall,
                                        color: Colors.black.withAlpha(120),
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          if (!_isFullScreen)
                            Padding(
                              padding: const EdgeInsets.all(
                                ThemeConstants.paddingSmall,
                              ),
                              child: ValueListenableBuilder<int>(
                                valueListenable: _selectedIndex,
                                builder: (context, value, child) {
                                  return TabBarContainer(
                                    selectedIndex: _selectedIndex,
                                    tabController: _tabController,
                                    onTabSelected: _switchTab,
                                    activeLesson: _activeLesson,
                                  );
                                },
                              ),
                            ),
                          Flexible(
                            flex: _isFullScreen
                                ? 0
                                : constraints.maxHeight < 540
                                    ? int.parse((constraints.maxHeight * 1)
                                        .toStringAsFixed(0))
                                    : int.parse((constraints.maxHeight * 1.6)
                                        .toStringAsFixed(0)),
                            child: Visibility(
                              visible: !_isFullScreen,
                              maintainState: true,
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    ThemeConstants.paddingSmall),
                                child: ValueListenableBuilder<int>(
                                  valueListenable: _selectedIndex,
                                  builder: (context, selectedIndex, child) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: PageView(
                                        controller: _pageController,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        children: [
                                          SyllabusAccordion(
                                            key: _syllabusKey,
                                            course: widget.course,
                                            courseProgressBox: snapshot.data,
                                            youtubePlayerController:
                                                _controller,
                                            activeLesson: _activeLesson,
                                            syllabusScrollController:
                                                _syllabusScrollController,
                                          ),
                                          LectureNotesTab(
                                              activeLesson: _activeLesson),
                                          DownloadsTab(
                                              activeLesson: _activeLesson),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
          },
        ),
      ),
      // bottomNavigationBar: Visibility(
      //   visible: !_isFullScreen,
      //   maintainState: true,
      //   child: CustomBottomNavigationBar(
      //     selectedIndex: _selectedIndex,
      //     switchTab: _switchTab,
      //     activeLesson: _activeLesson,
      //   ),
      // ),
    );
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
}
