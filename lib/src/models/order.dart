import 'package:app/src/models/course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//Pending, Processing, Completed, Refunded, Cancelled,Failed
enum OrderStatus {
  pending(name: 'Pending', color: Colors.orange),
  processing(name: 'Processing', color: Colors.blue),
  completed(name: 'Completed', color: Colors.green),
  refunded(name: 'Refunded', color: Colors.grey),
  cancelled(name: 'Cancelled', color: Colors.red),
  failed(name: 'Failed', color: Colors.red);

  final String name;
  final Color color;

  const OrderStatus({
    required this.name,
    required this.color,
  });
}

class Order {
  final String id;
  final OrderStatus status;
  final DocumentReference userId;
  final DocumentReference courseId;
  final DateTime createdAt;
  final String paymentMethod;
  final double total;
  final double discount;
  final String? paymentProof;
  final Course course;
  final DocumentSnapshot? snapshot;

  const Order({
    required this.id,
    required this.userId,
    required this.status,
    required this.courseId,
    required this.createdAt,
    required this.paymentMethod,
    required this.total,
    this.discount = 0,
    this.paymentProof,
    required this.course,
    this.snapshot,
  });

  factory Order.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return Order(
      id: doc.id,
      userId: data?['userId'] ?? '',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data?['status'],
      ),
      courseId: data?['courseId'] ?? '',
      createdAt: data?['createdAt']?.toDate() ?? '',
      paymentMethod: data?['paymentMethod'] ?? '',
      total: data?['total'] ?? 0,
      discount: data?['discount'] ?? 0,
      paymentProof: data?['paymentProof'],
      course: data?['course'] != null
          ? Course.fromMap(data?['course'])
          : throw ArgumentError("Course data is null"),
      snapshot: doc,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'status': status.name,
      'courseId': courseId,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt,
      'total': total,
      'discount': discount,
      'paymentProof': paymentProof,
      'course': course.toFirestore(),
    };
  }

  Order copyWith({
    String? id,
    OrderStatus? status,
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
      total: total ?? this.total,
      discount: discount ?? this.discount,
      paymentProof: paymentProof ?? this.paymentProof,
      course: course ?? this.course,
    );
  }
}
