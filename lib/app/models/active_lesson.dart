class ActiveLesson {
  final int section, lecture;
  final String source, notes;

  const ActiveLesson({
    this.section = 0,
    this.lecture = 0,
    this.source = '',
    this.notes = '',
  });

  factory ActiveLesson.fromJson(Map<String, dynamic> json) => ActiveLesson(
        section: json['section'] ?? 0,
        lecture: json['lecture'] ?? 0,
        source: json['source'] ?? '',
        notes: json['notes'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'section': section,
        'lecture': lecture,
        'source': source,
        'notes': notes
      };
}
