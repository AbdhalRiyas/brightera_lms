import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:flutter/material.dart';

class OrderApproveScreen extends StatefulWidget {
  const OrderApproveScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderApproveScreen> createState() => _OrderApproveScreenState();
}

class _OrderApproveScreenState extends State<OrderApproveScreen> {
  final OrderRepository _orderRepository = OrderRepository();

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
      // form to approve order
      body: Padding(
        padding: const EdgeInsets.all(
          ThemeConstants.paddingMedium,
        ),
        child: ListView(
          children: [
            Text(
              'Course: ${widget.order.course.title}',
              style: ThemeConstants.headingStyle,
            ),
            Text(
              'Amount: ${widget.order.total}',
              style: ThemeConstants.headingStyle,
            ),
            Text(
              'User ID: ${widget.order.userId.id}',
              style: ThemeConstants.headingStyle,
            ),
            widget.order.paymentProof != null
                ? Image.network(
                    widget.order.paymentProof!,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )
                : const Text('No payment proof attached'),
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
                  ),
                  onChanged: (value) {
                    _status.value = value!;
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final order = widget.order.copyWith(
                  status: _status.value,
                );
                await _orderRepository.updateOrder(order);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
