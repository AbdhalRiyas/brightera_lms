import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id, title, description;
  final DocumentReference? subject;
  final num? price;

  const Course(
      {required this.id,
      required this.title,
      required this.description,
      required this.subject,
      required this.price});
}
