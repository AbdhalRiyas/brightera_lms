import 'package:app/src/models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String status;
  final DocumentReference userId;
  final DocumentReference courseId;
  final DateTime createdAt;
  final String paymentMethod;
  final String paymentStatus;
  final double total;
  final double discount;
  final String? paymentProof;
  final Course course;

  const Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.courseId,
    required this.createdAt,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.total,
    this.discount = 0,
    this.paymentProof,
    required this.course,
  });

  factory Order.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Order(
      id: doc.id,
      userId: data?['userId'] ?? '',
      status: data?['status'] ?? '',
      courseId: data?['courseId'] ?? '',
      createdAt: data?['createdAt']?.toDate() ?? '',
      paymentMethod: data?['paymentMethod'] ?? '',
      paymentStatus: data?['paymentStatus'] ?? '',
      total: data?['total'] ?? 0,
      discount: data?['discount'] ?? 0,
      paymentProof: data?['paymentProof'],
      course: doc.data()?['course'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'status': status,
      'courseId': courseId,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
      'paymentStatus': paymentStatus,
      'total': total,
      'discount': discount,
      'paymentProof': paymentProof,
      'course': course.toFirestore(),
    };
  }

  Order copyWith({
    String? id,
    String? status,
    DocumentReference? userId,
    DocumentReference? courseId,
    DateTime? createdAt,
    String? paymentMethod,
    String? paymentStatus,
    double? total,
    double? discount,
    String? paymentProof,
    Course? course,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      courseId: courseId ?? this.courseId,
      createdAt: createdAt ?? this.createdAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      total: total ?? this.total,
      discount: discount ?? this.discount,
      paymentProof: paymentProof ?? this.paymentProof,
      course: course ?? this.course,
    );
  }
}
