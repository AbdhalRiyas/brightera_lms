import 'package:app/app/models/active_lesson.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class LectureNotesTab extends StatefulWidget {
  const LectureNotesTab({
    super.key,
    required this.activeLesson,
  });

  final ValueListenable<ActiveLesson> activeLesson;

  @override
  State<LectureNotesTab> createState() => _LectureNotesTabState();
}

class _LectureNotesTabState extends State<LectureNotesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder<ActiveLesson>(
        valueListenable: widget.activeLesson,
        builder: (context, value, ch) {
          return value.notes.isEmpty
              ? const Center(
                  child: Text("There are no notes available for this lecture."),
                )
              : const PDF().cachedFromUrl(
                  value.notes,
                  placeholder: (progress) => Center(child: Text('$progress %')),
                  errorWidget: (error) => Center(child: Text(error.toString())),
                );
        });
  }

  @override
  bool get wantKeepAlive => true;
}
