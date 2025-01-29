import 'package:cloud_firestore/cloud_firestore.dart';

class Enrollment {
  final DocumentReference course;
  final DocumentReference user;
  final Timestamp startDate;
  final Timestamp endDate;
  final String status;

  Enrollment(
      {required this.course,
      required this.user,
      required this.startDate,
      required this.endDate,
      required this.status});

  factory Enrollment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Enrollment(
      course: doc.data()?['course'] as DocumentReference,
      user: doc.data()?['user'] as DocumentReference,
      startDate: doc.data()?['startDate'],
      endDate: doc.data()?['endDate'],
      status: doc.data()?['status'],
    );
  }
}
