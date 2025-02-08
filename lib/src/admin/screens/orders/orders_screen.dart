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
          final orders = snapshot.data;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final Order order = orders[index];
              return ListTile(
                title: Text(order.id),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Course: ${order.course.title}"),
                    Text("Amount: ${order.total}"),
                    Text("Status: ${order.status}"),
                    Text("Created At: ${order.createdAt}"),
                    Text("Payment Method: ${order.paymentMethod}"),
                    Text("User ID: ${order.userId.id}"),
                    Text(order.paymentProof != null
                        ? "Payment Proof: Attached"
                        : "Payment Proof: No proof attached"),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderApproveScreen(order: order),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
