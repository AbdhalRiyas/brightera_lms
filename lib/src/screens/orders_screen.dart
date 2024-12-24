import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:app/src/repositories/user_repository.dart';
import 'package:app/src/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final DateFormat formatter = DateFormat('MMMM dd, yyyy');
  final UserRepository userRepository = UserRepository();
  final OrderRepository orderRepository = OrderRepository();
  final List<Order> orders = [];

  void getAllOrders() async {
    final List<Order> res =
        await orderRepository.getUserOrders(userRepository.currentUserUid);
    setState(() {
      orders.addAll(res);
    });
  }

  @override
  void initState() {
    super.initState();
    getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final Order order = orders[index];
          return Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: ListTile(
              title: Text('Order ID: ${order.id}'),
              subtitle: Text(formatter.format(order.createdAt)),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(order: order),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
