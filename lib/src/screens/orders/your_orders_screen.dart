import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/models/order.dart' as order_model;
import 'package:app/src/repositories/order_repository.dart';
import 'package:app/src/repositories/user_repository.dart';
import 'package:app/src/screens/orders/order_details_screen.dart';
import 'package:app/src/utils/format_price.dart';
import 'package:app/src/widgets/course_card/course_card_image.dart';
import 'package:app/src/widgets/course_card/course_card_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class YourOrdersScreen extends StatefulWidget {
  const YourOrdersScreen({super.key});

  @override
  State<YourOrdersScreen> createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  final OrderRepository _orderRepository = OrderRepository();
  final UserRepository _userRepository = UserRepository();
  final List<order_model.Order> _orders = [];
  DocumentSnapshot? _lastDocument;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
  final int _limit = 10; // Number of orders to fetch per page

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchOrders({bool reset = false}) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    if (reset) {
      setState(() {
        _orders.clear();
        _lastDocument = null;
        _hasMore = true;
      });
    }

    try {
      final newOrders = await _orderRepository.getUserOrdersPaginated(
        _userRepository.currentUserUid,
        limit: _limit,
        lastDoc: _lastDocument,
      );

      if (newOrders.isNotEmpty) {
        setState(() {
          _orders.addAll(newOrders);
          _lastDocument = newOrders.last.snapshot;
        });
      } else {
        setState(() {
          _hasMore = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_hasMore && !_isLoading) {
        _fetchOrders();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      body: _orders.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders found.'))
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _orders.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _orders.length) {
                      return const Center(
                        heightFactor: 4,
                        child: CircularProgressIndicator(),
                      );
                    }

                    final order_model.Order order = _orders[index];
                    final Course courseData = order.course;

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(order: order),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        shadowColor: ThemeConstants.primaryShadowColor,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CourseCardImage(
                                imageUrl: courseData.image,
                                maxHeight: 180,
                                maxWidth: 110,
                                listMode: true,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CourseCardTitle(title: courseData.title),
                                      const SizedBox(height: 8),
                                      Text(
                                        DateFormat('dd MMM yyyy')
                                            .format(order.createdAt),
                                        style: const TextStyle(
                                          fontSize:
                                              ThemeConstants.fontSizeSmall,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            formatPrice(order.course.salePrice),
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
                                                  ThemeConstants.paddingSmall /
                                                      2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: order.status.color,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ThemeConstants
                                                    .borderRadiusSmall,
                                              ),
                                            ),
                                            child: Text(
                                              order.status.name.toUpperCase(),
                                              style: const TextStyle(
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
                    );
                  },
                ),
    );
  }
}
