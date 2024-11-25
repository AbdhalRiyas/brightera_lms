import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  final String id, title, type, source, pdfNotes;
  final bool freePreview, isLive;
  int order;
  final num durationInSeconds;
  final List<dynamic> downloads;

  Lecture({
    required this.id,
    required this.title,
    required this.type,
    required this.source,
    required this.order,
    required this.durationInSeconds,
    this.freePreview = false,
    this.isLive = false,
    this.pdfNotes = '',
    this.downloads = const [],
  });

  factory Lecture.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Lecture(
      id: doc.id,
      title: data?['title'] ?? '',
      type: data?['type'] ?? 'video',
      source: data?['source'] ?? '',
      freePreview: data?['free_preview'] ?? false,
      isLive: data?['is_live'] ?? false,
      order: data?['order'] ?? 1,
      durationInSeconds: data?['durationInSeconds'] ?? 0,
      pdfNotes: data?['pdfNotes'] ?? '',
      downloads: data?['downloads'] ?? [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'type': type,
      'source': source,
      'free_preview': freePreview,
      'is_live': isLive,
      'order': order,
      'durationInSeconds': durationInSeconds,
      'pdfNotes': pdfNotes,
      'downloads': downloads,
    };
  }

  Lecture copyWith({
    String? id,
    String? title,
    String? type,
    String? source,
    bool? freePreview,
    bool? isLive,
    int? order,
    int? durationInSeconds,
    String? pdfNotes,
    List<dynamic>? downloads,
  }) {
    return Lecture(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      source: source ?? this.source,
      freePreview: freePreview ?? this.freePreview,
      isLive: isLive ?? this.isLive,
      order: order ?? this.order,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      pdfNotes: pdfNotes ?? this.pdfNotes,
      downloads: downloads ?? this.downloads,
    );
  }
}
