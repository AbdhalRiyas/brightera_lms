import 'package:app/src/models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Enrollment {
  final String id;
  final DocumentReference course;
  final DocumentReference user;
  final Timestamp startDate;
  final Timestamp endDate;
  final String status;
  final DocumentSnapshot? snapshot;
  final Course? courseInfo;

  Enrollment({
    required this.id,
    required this.course,
    required this.user,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.snapshot,
    this.courseInfo,
  });

  factory Enrollment.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Enrollment(
      id: doc.id,
      course: doc.data()?['courseId'] as DocumentReference,
      user: doc.data()?['userId'] as DocumentReference,
      startDate: doc.data()?['startDate'],
      endDate: doc.data()?['endDate'],
      status: doc.data()?['status'],
      snapshot: doc,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'courseId': course,
      'userId': user,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }

  Enrollment copyWith({
    String? id,
    DocumentReference? course,
    DocumentReference? user,
    Timestamp? startDate,
    Timestamp? endDate,
    String? status,
    DocumentSnapshot? snapshot,
    Course? courseInfo,
  }) {
    return Enrollment(
      id: id ?? this.id,
      course: course ?? this.course,
      user: user ?? this.user,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      courseInfo: courseInfo ?? this.courseInfo,
    );
  }
}
