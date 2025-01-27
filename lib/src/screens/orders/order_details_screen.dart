import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/course.dart';
import 'package:app/src/models/order.dart';
import 'package:app/src/repositories/order_repository.dart';
import 'package:app/src/screens/orders/widgets/pick_payment_proof.dart';
import 'package:app/src/utils/format_price.dart';
import 'package:app/src/widgets/course_card/course_card_image.dart';
import 'package:app/src/widgets/course_card/course_card_subtitle.dart';
import 'package:app/src/widgets/course_card/course_card_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  // final CourseRepository _courseRepository = CourseRepository();
  final OrderRepository _orderRepository = OrderRepository();
  Course? course;
  FilePickerResult? paymentProof;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchCourse();
  // }

  // void _fetchCourse() async {
  //   try {
  //     final fetchedCourse =
  //         await _courseRepository.getCourseDetails(widget.order.courseId.id);
  //     setState(() {
  //       course = fetchedCourse;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to fetch course: $e'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: StreamBuilder<Order>(
        stream: _orderRepository.getOrderStream(widget.order.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Order not found.'));
          }

          final order = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCourseDetails(context),
                const SizedBox(height: 24),
                _buildOrderSummary(context, order),
                const SizedBox(height: 24),
                _buildPaymentProofSection(context, order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseDetails(BuildContext context) {
    final Map<String, dynamic> courseData = widget.order.course;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      // CourseCardSubtitle(course: courseData),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // return Card(
    //   elevation: 4,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //   child: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Row(
    //       children: [
    //         CachedNetworkImage(
    //           imageUrl: courseData['image'] ?? '',
    //           width: 60,
    //           height: 60,
    //           placeholder: (context, url) => const CircularProgressIndicator(),
    //           errorWidget: (context, url, error) =>
    //               const Icon(Icons.error, size: 60),
    //         ),
    //         const SizedBox(width: 16),
    //         Expanded(
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 courseData['title'] ?? 'No title available',
    //                 style: const TextStyle(
    //                   fontSize: 16,
    //                   fontWeight: FontWeight.w600,
    //                 ),
    //                 maxLines: 2,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //               const SizedBox(height: 8),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text(
    //                     formatPrice(courseData['salePrice'] ?? 0.00),
    //                     style: const TextStyle(
    //                       fontSize: 14,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.green,
    //                     ),
    //                   ),
    //                   if ((courseData['regularPrice'] ?? 0.00) != 0.00)
    //                     Text(
    //                       formatPrice(courseData['regularPrice']),
    //                       style: const TextStyle(
    //                         fontSize: 12,
    //                         decoration: TextDecoration.lineThrough,
    //                         color: Colors.grey,
    //                       ),
    //                     ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _buildOrderSummary(BuildContext context, Order order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ThemeConstants.borderRadiusLarge,
        ),
        boxShadow: const [
          BoxShadow(
            color: ThemeConstants.primaryShadowColor,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Order Summary', style: ThemeConstants.headingStyle),
            ),
            const SizedBox(height: 24),
            _buildOrderDetailRow('Order ID', order.id),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Status', order.status),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Payment Method', order.paymentMethod),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Payment Status', order.paymentStatus),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
                'Total', 'LKR ${order.total.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildOrderDetailRow(
                'Discount', 'LKR ${order.discount.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            _buildOrderDetailRow('Created At', order.createdAt.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentProofSection(BuildContext context, Order order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          ThemeConstants.borderRadiusLarge,
        ),
        boxShadow: const [
          BoxShadow(
            color: ThemeConstants.primaryShadowColor,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: order.paymentProof != null &&
                order.paymentProof!.startsWith('https')
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Payment Proof',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CachedNetworkImage(
                    imageUrl: order.paymentProof!,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ],
              )
            : Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final result = await pickPaymentProof(context);

                      if (result != null && result.files.single.path != null) {
                        final filePath = result.files.single.path!;

                        final uploadResult =
                            await _orderRepository.addPaymentProof(filePath);

                        await _orderRepository.updateOrder(
                          order.copyWith(paymentProof: uploadResult.data),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Payment proof uploaded successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error uploading payment proof: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('Add Payment Proof'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
      ),
    );
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
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
