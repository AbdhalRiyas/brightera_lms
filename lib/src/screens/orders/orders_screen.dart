import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:app/src/repositories/user_repository.dart';
import 'package:app/src/screens/orders/order_details_screen.dart';
import 'package:app/src/utils/format_price.dart';
import 'package:app/src/widgets/course_card/course_card_image.dart';
import 'package:app/src/widgets/course_card/course_card_title.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  Future<List<Order>> _fetchOrders() async {
    final userRepository = UserRepository();
    final orderRepository = OrderRepository();
    final userOrders =
        await orderRepository.getUserOrders(userRepository.currentUserUid);
    return userOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder<List<Order>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No orders found.'),
            );
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                final Map<String, dynamic> courseData = order.course;
                return InkWell(
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: ThemeConstants.primaryShadowColor,
                    color: Colors.white,
                    child: InkWell(
                      // onTap: onTap,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            CourseCardImage(
                              imageUrl: courseData['image'],
                              maxHeight: 180,
                              maxWidth: 110,
                              listMode: true,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CourseCardTitle(title: courseData['title']),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "by Mohamed",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withAlpha(150),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          courseData['durationInHours'] != null
                                              ? '${courseData['durationInHours']} hours'
                                              : '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withAlpha(150),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatPrice(
                                              order.course['salePrice']),
                                          style: const TextStyle(
                                            fontSize:
                                                ThemeConstants.fontSizeSmall,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal:
                                                ThemeConstants.paddingSmall,
                                            vertical:
                                                ThemeConstants.paddingSmall / 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              ThemeConstants.borderRadiusSmall,
                                            ),
                                          ),
                                          child: const Text(
                                            'Purchased',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(order: order),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
