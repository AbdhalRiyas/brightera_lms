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
  });

  factory Order.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Order(
      id: doc.id,
      userId: data?['userId'] ?? '',
      status: data?['status'] ?? '',
      courseId: data?['course'] ?? '',
      createdAt: data?['createdAt']?.toDate() ?? '',
      paymentMethod: data?['paymentMethod'] ?? '',
      paymentStatus: data?['paymentStatus'] ?? '',
      total: data?['total'] ?? 0,
      discount: data?['discount'] ?? 0,
      paymentProof: data?['paymentProof'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'status': status,
      'course': courseId,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
      'paymentStatus': paymentStatus,
      'total': total,
      'discount': discount,
      'paymentProof': paymentProof,
    };
  }
}
