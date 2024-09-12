import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class LectureNotesTab extends StatefulWidget {
  const LectureNotesTab({
    super.key,
    this.pdfUrl = '',
  });

  final String pdfUrl;

  @override
  State<LectureNotesTab> createState() => _LectureNotesTabState();
}

class _LectureNotesTabState extends State<LectureNotesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.pdfUrl.isEmpty
        ? const Center(
            child: Text("There are no notes available for this lecture."),
          )
        : const PDF().cachedFromUrl(
            widget.pdfUrl,
            placeholder: (progress) => Center(child: Text('$progress %')),
            errorWidget: (error) => Center(child: Text(error.toString())),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
