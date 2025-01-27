import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/active_lesson.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/models/section.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/widgets/syllabus/syllabus_lesson.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SyllabusAccordion extends StatefulWidget {
  const SyllabusAccordion({
    super.key,
    required this.course,
    this.youtubePlayerController,
    this.activeLesson,
    this.courseProgressBox,
    this.syllabusScrollController,
    ScrollPhysics? scrollPhysics,
  }) : _scrollPhysics = scrollPhysics;

  final Course course;
  final YoutubePlayerController? youtubePlayerController;
  final ValueNotifier<ActiveLesson>? activeLesson;
  final Box? courseProgressBox;
  final ScrollController? syllabusScrollController;
  final ScrollPhysics? _scrollPhysics;

  @override
  State<SyllabusAccordion> createState() => SyllabusAccordionState();
}

class SyllabusAccordionState extends State<SyllabusAccordion>
    with AutomaticKeepAliveClientMixin {
  final CourseRepository _repository = CourseRepository();

  List<Section> _sections = [];
  bool _isLoading = true;
  int _openedSection = 0;

  @override
  void initState() {
    if (_isLoading) {
      _fetchSectionsAndLectures();
    }

    super.initState();
  }

  void _changeOpenedIndex(int i) {
    if (_openedSection != i) {
      setState(() {
        _openedSection = i;
      });
    }
  }

  void _fetchSectionsAndLectures() async {
    _sections = await _repository.fetchSectionsForCourse(widget.course.id);

    Map<dynamic, dynamic>? lastLectureDetail =
        widget.courseProgressBox?.get("lastLecture");

    int lastSection =
        lastLectureDetail == null ? 0 : lastLectureDetail['section'];
    int lastLecture =
        lastLectureDetail == null ? 0 : lastLectureDetail['lecture'];

    if (lastSection >= _sections.length) {
      lastSection = 0;
      lastLecture = 0;
    }

    if (lastLecture >= _sections[lastSection].lectures.length) {
      lastLecture = 0;
    }

    String videoId = YoutubePlayer.convertUrlToId(
            _sections[lastSection].lectures[lastLecture].source) ??
        '';

    _openedSection = lastSection;

    final lectures = _sections[lastSection].lectures;

    widget.activeLesson?.value = ActiveLesson.fromJson({
      "section": lastSection,
      "lecture": lastLecture,
      "source": YoutubePlayer.convertUrlToId(videoId),
      "notes":
          lectures.length > lastLecture ? lectures[lastLecture].pdfNotes : "",
      "downloads":
          lectures.length > lastLecture ? lectures[lastLecture].downloads : [],
    });

    setState(() {
      _isLoading = false;
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      widget.youtubePlayerController?.load(videoId);
    });
  }

  void _changeLesson(int lectureDelta) {
    ActiveLesson activeLesson = widget.activeLesson!.value;
    int currentSection = activeLesson.section;
    int currentLecture = activeLesson.lecture;

    bool isChangesMade = false;

    int newLecture = currentLecture + lectureDelta;
    int newSection = currentSection;

    if (newLecture < 0) {
      newSection -= 1;
      if (newSection >= 0 && _sections[newSection].lectures.isNotEmpty) {
        newLecture = _sections[newSection].lectures.length - 1;
        isChangesMade = true;
      }
    } else if (newLecture >= _sections[currentSection].lectures.length) {
      newSection += 1;
      if (newSection < _sections.length &&
          _sections[newSection].lectures.isNotEmpty) {
        newLecture = 0;
        isChangesMade = true;
      }
    } else {
      newLecture = currentLecture + lectureDelta;
      isChangesMade = true;
    }

    if (isChangesMade) {
      widget.activeLesson!.value = ActiveLesson.fromJson({
        'section': newSection,
        'lecture': newLecture,
        'source': YoutubePlayer.convertUrlToId(
            _sections[newSection].lectures[newLecture].source),
        'notes': _sections[newSection].lectures[newLecture].pdfNotes,
        'downloads': _sections[newSection].lectures[newLecture].downloads,
      });

      if (currentSection != newSection) {
        _changeOpenedIndex(newSection);
      }

      widget.youtubePlayerController?.load(widget.activeLesson!.value.source);
    }
  }

  void prevLesson() {
    _changeLesson(-1);
  }

  void nextLesson() {
    _changeLesson(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget._scrollPhysics is NeverScrollableScrollPhysics
        ? Column(children: _buildSyllubusList)
        : ListView(
            physics: widget._scrollPhysics,
            shrinkWrap: true,
            controller: widget.syllabusScrollController,
            children: _buildSyllubusList,
          );
  }

  List<Widget> get _buildSyllubusList {
    return [
      _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : Accordion(
              paddingListTop: 0,
              contentVerticalPadding: ThemeConstants.paddingSmall,
              disableScrolling: true,
              rightIcon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 22,
              ),
              headerBorderRadius: ThemeConstants.borderRadiusSmall,
              headerBorderWidth: 0,
              paddingListHorizontal: 0,
              headerBorderColorOpened: Colors.transparent,
              headerBackgroundColor: Colors.transparent,
              headerBackgroundColorOpened: Colors.transparent,
              contentBackgroundColor: Colors.transparent,
              contentBorderWidth: 0,
              contentHorizontalPadding: 0,
              scaleWhenAnimating: false,
              openAndCloseAnimation: true,
              headerPadding: const EdgeInsets.symmetric(vertical: 7),
              sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
              sectionClosingHapticFeedback: SectionHapticFeedback.light,
              children: List.generate(
                _sections.length,
                (i) => AccordionSection(
                  contentBackgroundColor: ThemeConstants.backgroundColor,
                  onOpenSection: () {
                    _changeOpenedIndex(i);
                  },
                  key: Key(_sections[i].id),
                  isOpen: i == _openedSection,
                  contentVerticalPadding: ThemeConstants.paddingSmall,
                  header: Text(
                    _sections[i].title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  content: widget._scrollPhysics is NeverScrollableScrollPhysics
                      ? Column(
                          children: _buildSubList(i),
                        )
                      : ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: _buildSubList(i),
                        ),
                ),
              ),
            ),
    ];
  }

  List<Widget> _buildSubList(int i) {
    return List.generate(
      _sections[i].lectures.length,
      (j) => Material(
        child: widget.activeLesson != null
            ? ValueListenableBuilder<ActiveLesson>(
                valueListenable: widget.activeLesson!,
                builder:
                    (BuildContext context, ActiveLesson value, Widget? child) =>
                        SyllabusLesson(
                  key: Key(_sections[i].lectures[j].id),
                  courseProgressBox: widget.courseProgressBox,
                  course: widget.course,
                  index: j,
                  sectionIndex: i,
                  lecture: _sections[i].lectures[j],
                  activeLesson: widget.activeLesson,
                  youtubePlayerController: widget.youtubePlayerController,
                ),
              )
            : SyllabusLesson(
                key: Key(_sections[i].lectures[j].id),
                courseProgressBox: widget.courseProgressBox,
                course: widget.course,
                index: j,
                sectionIndex: i,
                lecture: _sections[i].lectures[j],
                activeLesson: widget.activeLesson,
                youtubePlayerController: widget.youtubePlayerController,
              ),
      ),
    );
  }

  @override
  void dispose() {
    widget.courseProgressBox
        ?.close(); // close the box when the lecture screen closes
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
