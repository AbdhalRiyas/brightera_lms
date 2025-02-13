import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/active_lesson.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/models/lecture.dart';
import 'package:app/src/screens/courses/components/show_free_preview.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'lesson_duration.dart';

class SyllabusLesson extends StatefulWidget {
  final Course? course;
  final Lecture lecture;
  final YoutubePlayerController? youtubePlayerController;
  final ValueNotifier<ActiveLesson>? activeLesson;
  final int index;
  final int sectionIndex;
  final Box? courseProgressBox;

  const SyllabusLesson({
    super.key,
    required this.lecture,
    this.course,
    this.youtubePlayerController,
    this.activeLesson,
    this.courseProgressBox,
    required this.index,
    required this.sectionIndex,
  });

  @override
  State<SyllabusLesson> createState() => _SyllabusLessonState();
}

class _SyllabusLessonState extends State<SyllabusLesson> {
  final _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = YoutubePlayer.convertUrlToId(widget.lecture.source) ==
        widget.activeLesson?.value.source;
    return ListTile(
      tileColor: isActive ? ThemeConstants.lavenderMist : null,
      leading: Text(
        (widget.index + 1).toString(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: Text(
        widget.lecture.title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: LessonDuration(lecture: widget.lecture),
      contentPadding: const EdgeInsets.only(left: ThemeConstants.paddingLarge),
      trailing:
          widget.youtubePlayerController == null && widget.lecture.freePreview
              ? SvgPicture.asset(
                  'assets/icons/play-filled.svg',
                  height: 30,
                  colorFilter: const ColorFilter.mode(
                    ThemeConstants.primaryButtonColor,
                    BlendMode.srcIn,
                  ),
                )
              : _firebaseService.currentUser == null ||
                      widget.youtubePlayerController == null
                  ? null
                  : ValueListenableBuilder(
                      valueListenable: widget.courseProgressBox!.listenable(),
                      builder: (context, box, ch) {
                        final isChecked = box.get(widget.lecture.id) ?? false;

                        return IconButton(
                            onPressed: () {
                              if (isChecked) {
                                box.delete(widget.lecture.id);
                              } else {
                                box.put(widget.lecture.id, true);
                              }
                            },
                            icon: Icon(
                              isChecked
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: ThemeConstants.primaryButtonColor,
                            ));
                      }),
      onTap: isActive
          ? null
          : widget.youtubePlayerController == null && widget.lecture.freePreview
              ? () => showFreePreview(context, widget.lecture.source)
              : widget.youtubePlayerController != null
                  ? () async {
                      String videoId =
                          YoutubePlayer.convertUrlToId(widget.lecture.source) ??
                              '';

                      widget.activeLesson?.value = ActiveLesson.fromJson({
                        "source": videoId,
                        "lecture": widget.index,
                        "section": widget.sectionIndex,
                        "notes": widget.lecture.pdfNotes,
                        "downloads": widget.lecture.downloads,
                      });

                      widget.youtubePlayerController?.load(
                        videoId,
                        startAt: 0,
                      );

                      widget.courseProgressBox?.put(
                        "lastLecture",
                        {
                          "section": widget.sectionIndex,
                          "lecture": widget.index,
                        },
                      );
                    }
                  : null,
    );
  }
}
