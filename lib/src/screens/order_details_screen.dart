import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final Order order;

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
            _buildOrderDetailRow('Order ID', order.id),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Status', order.status),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Payment Method', order.paymentMethod),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Payment Status', order.paymentStatus),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
                'Total', '\$${order.total.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
                'Discount', '\$${order.discount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Created At', order.createdAt.toString()),

            // Payment Proof Section
            order.paymentProof != null
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
                      Image.network(order.paymentProof!),
                    ],
                  )
                : TextButton(
                    onPressed: () {
                      OrderRepository()
                          .addPaymentProof(order.id, 'paymentProof');
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
