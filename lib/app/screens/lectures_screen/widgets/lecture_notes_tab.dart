import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
            child: Text("There are no notes available for this lesson."),
          )
        : SfPdfViewer.network(
            widget.pdfUrl,
          );
  }

  @override
  bool get wantKeepAlive => true;
}
