import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final CourseRepository _courseRepository = CourseRepository();

  @override
  void initState() {
    _fetchCourse();
    super.initState();
  }

  void _fetchCourse() async {
    final course =
        await _courseRepository.getCourseDetails(widget.order.courseId.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Center(
              child: Text(
                'Order Summary',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
              ),
            ),
            const Divider(
              height: 32,
              thickness: 1,
            ),
            // Order Details Section
            _buildOrderDetailRow('Order ID', widget.order.id),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Status', widget.order.status),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Payment Method', widget.order.paymentMethod),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Payment Status', widget.order.paymentStatus),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
                'Total', '\$${widget.order.total.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
                'Discount', '\$${widget.order.discount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
                'Created At', widget.order.createdAt.toString()),

            // Payment Proof Section
            widget.order.paymentProof != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Payment Proof',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                        ),
                      ),
                      const Divider(
                        height: 32,
                        thickness: 1,
                      ),
                      Image.network(widget.order.paymentProof!),
                    ],
                  )
                : TextButton(
                    onPressed: () {
                      OrderRepository()
                          .addPaymentProof(widget.order.id, 'paymentProof');
                    },
                    child: const Text('Add Payment Proof'),
                  ),
          ],
        ),
      ),
    );
  }
}

Widget _buildOrderDetailRow(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    ],
  );
}
