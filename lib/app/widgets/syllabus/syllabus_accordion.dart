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
  });

  final Course course;
  final YoutubePlayerController? youtubePlayerController;

  @override
  State<SyllabusAccordion> createState() => _SyllabusAccordionState();
}

class _SyllabusAccordionState extends State<SyllabusAccordion>
    with AutomaticKeepAliveClientMixin {
  final CourseRepository _repository = CourseRepository();
  final ValueNotifier<String> _activeLessonVideoId = ValueNotifier('');

  List<Section> _sections = [];
  bool _isLoading = true;
  int _openedSection = 0;

  @override
  void initState() {
    _activeLessonVideoId.value =
        widget.youtubePlayerController?.initialVideoId ?? '';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_activeLessonVideoId.value.isEmpty) {}
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
                      child: ValueListenableBuilder<String>(
                        valueListenable: _activeLessonVideoId,
                        builder: (BuildContext context, String value,
                                Widget? child) =>
                            SyllabusLesson(
                          key: Key(_sections[i].lectures[j].id),
                          index: j,
                          lecture: _sections[i].lectures[j],
                          activeLessonVideoId: _activeLessonVideoId,
                          youtubePlayerController:
                              widget.youtubePlayerController,
                        ),
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
