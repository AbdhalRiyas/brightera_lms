import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/enrollment.dart';
import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/repositories/enrollment_repository.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';

class OrderApproveScreen extends StatefulWidget {
  const OrderApproveScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderApproveScreen> createState() => _OrderApproveScreenState();
}

class _OrderApproveScreenState extends State<OrderApproveScreen> {
  final OrderRepository _orderRepository = OrderRepository();
  final EnrollmentRepository _enrollmentRepository = EnrollmentRepository();
  final CourseRepository _courseRepository = CourseRepository();

  final ValueNotifier<OrderStatus> _status = ValueNotifier(OrderStatus.pending);

  @override
  void initState() {
    super.initState();
    _status.value = widget.order.status;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve Order'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeConstants.primaryButtonColor,
        onPressed: _saveOrder,
        child: const Text('Save'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    Icons.book, "Course", widget.order.course.title),
                _buildDetailRow(Icons.attach_money, "Amount",
                    widget.order.total.toString()),
                _buildDetailRow(
                    Icons.person, "User ID", widget.order.userId.id),
                const SizedBox(height: 12),
                _buildPaymentProof(widget.order.paymentProof),
                const SizedBox(height: 16),
                ValueListenableBuilder<OrderStatus>(
                  valueListenable: _status,
                  builder: (context, status, child) {
                    return DropdownButtonFormField<OrderStatus>(
                      value: status,
                      items: const [
                        DropdownMenuItem(
                          value: OrderStatus.pending,
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: OrderStatus.processing,
                          child: Text('Processing'),
                        ),
                        DropdownMenuItem(
                          value: OrderStatus.completed,
                          child: Text('Completed'),
                        ),
                        DropdownMenuItem(
                          value: OrderStatus.cancelled,
                          child: Text('Cancelled'),
                        ),
                        DropdownMenuItem(
                          value: OrderStatus.refunded,
                          child: Text('Refunded'),
                        ),
                        DropdownMenuItem(
                          value: OrderStatus.failed,
                          child: Text('Failed'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        labelText: "Order Status",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _status.value = value!;
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Helper function to build order details row
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ThemeConstants.primaryColor),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper function to handle payment proof UI
  Widget _buildPaymentProof(String? paymentProofUrl) {
    if (paymentProofUrl == null) {
      return const Text(
        'No payment proof attached',
        style: TextStyle(color: Colors.red),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        paymentProofUrl,
        height: 400,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  /// Function to save order status and enroll user if order is completed
  Future<void> _saveOrder() async {
    final order = widget.order.copyWith(status: _status.value);
    await _orderRepository.updateOrder(order);

    // If order is completed from pending or processing status then enroll user
    if (_status.value == OrderStatus.completed &&
        widget.order.status != OrderStatus.completed) {
      final enrollment = Enrollment(
        id: '',
        course: order.courseId,
        user: order.userId,
        startDate: firestore.Timestamp.fromDate(DateTime.now()),
        endDate: firestore.Timestamp.fromDate(
            DateTime.now().add(const Duration(days: 30))),
      );
      await _enrollmentRepository.addEnrollment(enrollment);
      await _enrollmentRepository.checkExistingEnrollment(
        enrollment.user.id,
        enrollment.course.id,
      );
    }
    Navigator.pop(context);
  }
}
