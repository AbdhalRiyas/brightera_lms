import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  final String id, title, type, source, pdfNotes;
  final bool freePreview, isLive;
  final int order, durationInSeconds;
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
    return Lecture(
      id: doc.id,
      title: doc.data()?['title'] ?? '',
      type: doc.data()?['type'] ?? 'video',
      source: doc.data()?['source'] ?? '',
      freePreview: doc.data()?['free_preview'] ?? false,
      isLive: doc.data()?['is_live'] ?? false,
      order: doc.data()?['order'] ?? 1,
      durationInSeconds: doc.data()?['durationInSeconds'] ?? 0,
      pdfNotes: doc.data()?['pdfNotes'] ?? '',
      downloads: doc.data()?['downloads'] ?? [],
    );
  }
}
