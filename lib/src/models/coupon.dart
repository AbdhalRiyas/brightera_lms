import 'package:cloud_firestore/cloud_firestore.dart';

enum CouponType { percentage, fixedAmount }

class Coupon {
  final String id;
  final String code;
  final int maxUsage;
  final List<String> appliesTo;
  final double discount;
  final CouponType type;
  final DateTime? expiryDate;

  Coupon({
    required this.id,
    required this.code,
    required this.discount,
    required this.maxUsage,
    required this.appliesTo,
    required this.type,
    this.expiryDate,
  });

  //from firestore
  factory Coupon.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return Coupon(
      id: doc.id,
      code: doc.data()?['code'] ?? '',
      discount: doc.data()?['discount'] ?? 0,
      maxUsage: doc.data()?['maxUsage'] ?? 0,
      appliesTo: List<String>.from(doc.data()?['appliesTo'] ?? []),
      type: doc.data()?['type'] == 'percentage'
          ? CouponType.percentage
          : CouponType.fixedAmount,
      expiryDate: doc.data()?['expiryDate'] != null
          ? (doc.data()?['expiryDate']).toDate()
          : null,
    );
  }

  //to firestore
  Map<String, dynamic> toFireStore() {
    return {
      'code': code,
      'discount': discount,
      'expiryDate': expiryDate,
      'maxUsage': maxUsage,
      'appliesTo': appliesTo,
      'type': type == CouponType.percentage ? 'percentage' : 'fixedAmount',
    };
  }
}
