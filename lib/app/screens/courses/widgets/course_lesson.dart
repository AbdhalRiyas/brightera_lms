import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/lecture.dart';
import 'package:app/app/screens/courses/widgets/show_free_preview.dart';
import 'package:app/app/utils/int_extension.dart';
import 'package:app/app/utils/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseLesson extends StatelessWidget {
  final Lecture lecture;
  final YoutubePlayerController? youtubePlayerController;
  final ValueNotifier<String>? activeLessonVideoId;
  final int index;

  const CourseLesson(
      {super.key,
      required this.lecture,
      this.youtubePlayerController,
      this.activeLessonVideoId,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: YoutubePlayer.convertUrlToId(lecture.source) ==
              activeLessonVideoId?.value
          ? ThemeConstants.lavenderMist
          : null,
      leading: Text(
        (index + 1).toString(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: Text(
        lecture.title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        "${lecture.type.capitalize()} - ${lecture.durationInSeconds.toMinutes()}",
        style: const TextStyle(fontSize: 11),
      ),
      contentPadding: const EdgeInsets.only(left: ThemeConstants.paddingLarge),
      trailing: youtubePlayerController == null && lecture.freePreview
          ? const Icon(
              Icons.play_circle_outline_sharp,
              color: ThemeConstants.primaryButtonColor,
            )
          : null,
      onTap: youtubePlayerController == null && lecture.freePreview
          ? () => showFreePreview(context, lecture.source)
          : youtubePlayerController != null
              ? () {
                  String videoId =
                      YoutubePlayer.convertUrlToId(lecture.source) ?? '';

                  activeLessonVideoId?.value = videoId;

                  youtubePlayerController?.load(
                    videoId,
                    startAt: 0,
                  );
                }
              : null,
    );
  }
}
