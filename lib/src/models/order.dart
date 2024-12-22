import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  final String id;
  final String status;
  final DocumentReference userId;
  final DocumentReference courseId;
  final String paymentMethod;
  final String paymentStatus;
  final double total;
  final double discount;

  const Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.courseId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.total,
    this.discount = 0,
  });

  factory Order.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Order(
      id: doc.id,
      userId: data?['userId'] ?? '',
      status: data?['status'] ?? '',
      courseId: data?['course'] ?? '',
      paymentMethod: data?['paymentMethod'] ?? '',
      paymentStatus: data?['paymentStatus'] ?? '',
      total: data?['total'] ?? 0,
      discount: data?['discount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'status': status,
      'course': courseId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'total': total,
      'discount': discount,
    };
  }
}
