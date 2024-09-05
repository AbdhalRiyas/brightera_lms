import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id, title, image;
  final String description;
  final DocumentReference? subject;
  final num salePrice, regularPrice;
  final num? durationInHours;

  const Course({
    required this.id,
    required this.title,
    this.image = '',
    this.description = '',
    required this.subject,
    this.regularPrice = 0,
    this.durationInHours,
    required this.salePrice,
  });
}
