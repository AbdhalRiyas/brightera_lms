import 'package:cloud_firestore/cloud_firestore.dart';

enum DiscountType { percentage, fixedAmount }

class Coupon {
  final String code;
  final DiscountType type;
  final double discount;
  final bool isActive;
  final int usageCount;
  final DateTime? createdAt;
  final DateTime? expiryDate;
  final int? maxUsage;
  final List<String>? courseIds;
  final List<String>? studentIds;

  Coupon({
    required this.code,
    required this.discount,
    required this.type,
    required this.isActive,
    this.usageCount = 0,
    this.createdAt,
    this.expiryDate,
    this.courseIds,
    this.studentIds,
    this.maxUsage,
  });

  //from firestore
  factory Coupon.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Coupon(
      code: doc.id,
      discount: data?['discount'],
      type: DiscountType.values[data?['type']],
      usageCount: data?['usageCount'] ?? 0,
      createdAt: (data?['createdAt'] as Timestamp?)?.toDate(),
      isActive: data?['isActive'],
      expiryDate: (data?['expiryDate'] as Timestamp?)?.toDate(),
      courseIds: List<String>.from(data?['courseIds'] ?? []),
      studentIds: List<String>.from(data?['studentIds'] ?? []),
      maxUsage: data?['maxUsage'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'discount': discount,
      'type': type.index,
      'usageCount': usageCount,
      'isActive': isActive,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'expiryDate': expiryDate != null ? Timestamp.fromDate(expiryDate!) : null,
      'courseIds': courseIds ?? [],
      'studentIds': studentIds ?? [],
      'maxUsage': maxUsage ?? 0,
    };
  }
}
