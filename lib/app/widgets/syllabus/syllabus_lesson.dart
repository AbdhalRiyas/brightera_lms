import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/active_lesson.dart';
import 'package:app/app/models/course.dart';
import 'package:app/app/models/lecture.dart';
import 'package:app/app/screens/courses/widgets/show_free_preview.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:app/app/utils/int_extension.dart';
import 'package:app/app/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SyllabusLesson extends StatefulWidget {
  final Course? course;
  final Lecture lecture;
  final YoutubePlayerController? youtubePlayerController;
  final ValueNotifier<ActiveLesson>? activeLessonVideoId;
  final int index;
  final int sectionIndex;

  const SyllabusLesson({
    super.key,
    required this.lecture,
    this.course,
    this.youtubePlayerController,
    this.activeLessonVideoId,
    required this.index,
    required this.sectionIndex,
  });

  @override
  State<SyllabusLesson> createState() => _SyllabusLessonState();
}

class _SyllabusLessonState extends State<SyllabusLesson> {
  final _firebaseService = FirebaseService();
  late final String _boxName;

  @override
  void initState() {
    _boxName = "${_firebaseService.currentUser?.uid}_${widget.course?.id}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isActive = YoutubePlayer.convertUrlToId(widget.lecture.source) ==
        widget.activeLessonVideoId?.value.source;
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
      subtitle: Text(
        widget.lecture.isLive
            ? "Live video"
            : "${widget.lecture.type.capitalize()} - ${widget.lecture.durationInSeconds.toMinutes()}",
        style: const TextStyle(fontSize: 11),
      ),
      contentPadding: const EdgeInsets.only(left: ThemeConstants.paddingLarge),
      trailing:
          widget.youtubePlayerController == null && widget.lecture.freePreview
              ? const Icon(
                  Icons.play_circle_outline_sharp,
                  color: ThemeConstants.primaryButtonColor,
                )
              : _firebaseService.currentUser == null ||
                      widget.youtubePlayerController == null
                  ? null
                  : ValueListenableBuilder(
                      valueListenable: Hive.box(_boxName).listenable(),
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
                  ? () {
                      String videoId =
                          YoutubePlayer.convertUrlToId(widget.lecture.source) ??
                              '';

                      widget.activeLessonVideoId?.value =
                          ActiveLesson.fromJson({
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
                    }
                  : null,
    );
  }
}
