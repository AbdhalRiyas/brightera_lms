import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  final String id;
  final String title;
  final String type;
  final String source;
  final bool freePreview;
  final bool isLive;
  final int order;
  final int durationInSeconds;

  const Lecture({
    required this.id,
    required this.title,
    required this.type,
    required this.source,
    required this.order,
    required this.durationInSeconds,
    this.freePreview = false,
    this.isLive = false,
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
    );
  }
}
