import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/widgets/syllabus/course_lesson.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SyllabusAccordion extends StatefulWidget {
  const SyllabusAccordion({
    super.key,
    required this.course,
    this.youtubePlayerController,
    this.activeLessonVideoId,
  });

  final Course course;
  final YoutubePlayerController? youtubePlayerController;
  final ValueNotifier<Map<String, dynamic>>? activeLessonVideoId;

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
    widget.activeLessonVideoId?.value = {
      "section": 0,
      "lecture": 0,
      "source": YoutubePlayer.convertUrlToId(widget.course.previewVideo),
    };
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

    setState(() {
      _isLoading = false;
    });
  }

  void nextLesson() {
    Map<String, dynamic> activeLesson = widget.activeLessonVideoId!.value;
    int currentSection = activeLesson['section'];
    int currentLecture = activeLesson['lecture'];

    if (_sections[currentSection].lectures.length > currentLecture) {
      currentLecture += 1;
    } else {
      if (_sections.length > currentSection) {
        currentSection += 1;
        currentLecture = 0;
      }
    }

    widget.activeLessonVideoId!.value = {
      'section': currentSection,
      'lecture': currentLecture,
      'source': YoutubePlayer.convertUrlToId(
          _sections[currentSection].lectures[currentLecture].source),
    };

    widget.youtubePlayerController
        ?.load(widget.activeLessonVideoId!.value['source']);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isLoading
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
                content: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(
                    _sections[i].lectures.length,
                    (j) => Material(
                      child: widget.activeLessonVideoId != null
                          ? ValueListenableBuilder<Map<String, dynamic>>(
                              valueListenable: widget.activeLessonVideoId!,
                              builder: (BuildContext context,
                                      Map<String, dynamic> value,
                                      Widget? child) =>
                                  SyllabusLesson(
                                key: Key(_sections[i].lectures[j].id),
                                index: j,
                                sectionIndex: i,
                                lecture: _sections[i].lectures[j],
                                activeLessonVideoId: widget.activeLessonVideoId,
                                youtubePlayerController:
                                    widget.youtubePlayerController,
                              ),
                            )
                          : SyllabusLesson(
                              key: Key(_sections[i].lectures[j].id),
                              index: j,
                              sectionIndex: i,
                              lecture: _sections[i].lectures[j],
                              activeLessonVideoId: widget.activeLessonVideoId,
                              youtubePlayerController:
                                  widget.youtubePlayerController,
                            ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
