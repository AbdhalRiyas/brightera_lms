import 'package:app/app/models/section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id, title, image;
  final String description;
  final DocumentReference? subject;
  final num salePrice, regularPrice;
  final num? durationInHours;
  List<Section>? sections;

  Course({
    required this.id,
    required this.title,
    this.image = '',
    this.description = '',
    required this.subject,
    this.regularPrice = 0,
    this.durationInHours,
    required this.salePrice,
    this.sections,
  });

  // Factory method to create a Course from Firestore document
  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc,
      [List<Section>? sections]) {
    return Course(
      id: doc.id,
      title: doc.data()?['title'] ?? '',
      image: doc.data()?['image'] ?? '',
      description: doc.data()?['description'] ?? '',
      subject: doc.data()?['subject'],
      salePrice: doc.data()?['salePrice'] ?? 0,
      regularPrice: doc.data()?['regularPrice'] ?? 0,
      durationInHours: doc.data()?['durationInHours'],
      sections: sections,
    );
  }
}
