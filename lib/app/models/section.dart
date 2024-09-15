import 'package:app/app/models/lecture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Section {
  final String id;
  final String title;
  int order;
  List<Lecture> lectures;

  Section({
    required this.id,
    required this.title,
    required this.order,
    this.lectures = const [],
  });

  // Factory method to create a Section from Firestore document
  factory Section.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc,
      [List<Lecture>? lectures]) {
    return Section(
      id: doc.id,
      title: doc.data()?['title'] ?? '',
      order: doc.data()?['order'] ?? 0,
      lectures: lectures ?? [],
    );
  }
}
