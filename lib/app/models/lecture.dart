enum LectureType { video, article }

class Lecture {
  final String id, title, source;
  final bool isLive, freePreview;
  final LectureType type;

  const Lecture(
      {required this.id,
      required this.title,
      required this.source,
      required this.isLive,
      required this.freePreview,
      required this.type});
}
