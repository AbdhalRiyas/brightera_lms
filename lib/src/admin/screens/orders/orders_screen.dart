import 'package:app/src/admin/screens/orders/order_approve_screen.dart';
import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderRepository _orderRepository = OrderRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: StreamBuilder(
        stream: _orderRepository.getOrdersStream(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('An error occurred'));
          }
          final List orders = snapshot.data;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final Order order = orders[index];
              return orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User ID: ${order.userId.id}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Course: ${order.course.title}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              "Total: ${order.total}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildDetailRow(Icons.book, "Order Id", order.id),
                            _buildDetailRow(
                              Icons.check_circle,
                              "Status",
                              order.status.name,
                              statusColor(
                                order.status,
                              ), // Dynamic color based on status
                            ),
                            _buildDetailRow(
                              Icons.calendar_today,
                              "Created At",
                              order.createdAt.toString(),
                            ),
                            _buildDetailRow(Icons.payment, "Payment Method",
                                order.paymentMethod),
                            _buildDetailRow(
                              order.paymentProof != null
                                  ? Icons.attachment
                                  : Icons.warning,
                              "Payment Proof",
                              order.paymentProof != null
                                  ? "Attached"
                                  : "No proof attached",
                              order.paymentProof != null
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderApproveScreen(order: order),
                            ),
                          );
                        },
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}

Widget _buildDetailRow(IconData icon, String label, String value,
    [Color? color]) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 18, color: color ?? Colors.black54),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: color ?? Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Color statusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orange;
    case OrderStatus.processing:
      return Colors.blue;
    case OrderStatus.completed:
      return Colors.green;
    case OrderStatus.refunded:
      return Colors.grey;
    case OrderStatus.cancelled:
      return Colors.red;
    case OrderStatus.failed:
      return Colors.red;
  }
}
