import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/repositories/course_repository.dart';
import 'package:app/app/utils/int_extension.dart';
import 'package:app/app/utils/string_extension.dart';
import 'package:flutter/material.dart';

class SyllabusAccordion extends StatefulWidget {
  const SyllabusAccordion({
    super.key,
    required this.course,
  });

  final Course course;

  @override
  State<SyllabusAccordion> createState() => _SyllabusAccordionState();
}

class _SyllabusAccordionState extends State<SyllabusAccordion> {
  final CourseRepository _repository = CourseRepository();
  bool _isLoading = true;
  List<Section> _sections = [];

  @override
  void initState() {
    if (_isLoading) {
      _fetchSectionsAndLectures();
    }
    super.initState();
  }

  void _fetchSectionsAndLectures() async {
    _sections = await _repository.fetchSectionsForCourse(widget.course.id);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            maxOpenSections: 100,
            children: List.generate(
              _sections.length,
              (i) => AccordionSection(
                isOpen: true,
                contentVerticalPadding: ThemeConstants.paddingSmall,
                header: Text(
                  _sections[i].title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(
                      _sections[i].lectures.length,
                      (j) => ListTile(
                            leading: Text(
                              (j + 1).toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            title: Text(
                              _sections[i].lectures[j].title,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              "${_sections[i].lectures[j].type.capitalize()} - ${_sections[i].lectures[j].durationInSeconds.toMinutes()}",
                              style: const TextStyle(fontSize: 11),
                            ),
                            contentPadding: const EdgeInsets.only(
                                left: ThemeConstants.paddingLarge),
                            trailing: _sections[i].lectures[j].freePreview
                                ? Material(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(
                                          ThemeConstants.borderRadiusLarge),
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.play_circle_outline_sharp,
                                        color:
                                            ThemeConstants.primaryButtonColor,
                                      ),
                                    ),
                                  )
                                : null,
                          )),
                ),
              ),
            ),
          );
  }
}
