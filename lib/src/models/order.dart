class Order {
  final String id;
  final String userId;
  final String status;
  final String courseId;
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

  factory Order.fromFirestore(Map<String, dynamic> data) {
    return Order(
      id: data['id'],
      userId: data['userId'],
      status: data['status'],
      courseId: data['course'],
      paymentMethod: data['paymentMethod'],
      paymentStatus: data['paymentStatus'],
      total: data['total'],
      discount: data['discount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
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
