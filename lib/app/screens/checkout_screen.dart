import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/models/payment_method.dart';
import 'package:app/app/repositories/payment_method_repository.dart';
import 'package:app/app/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _paymentMethodRepository = PaymentMethodRepository();

  late Future<List<PaymentMethod>> _paymentMethods;

  @override
  void initState() {
    _paymentMethods = _paymentMethodRepository.getActivePaymentMethods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.paddingSmall),
          child: ListView(
            children: [
              Text(
                "Payment method",
                style: _buildSubHeadingStyles(),
              ),
              FutureBuilder(
                future: _paymentMethods,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for the data
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Handle the error state
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    // Handle the case where there's no data
                    return const Text('No payment methods available');
                  } else {
                    // Assuming snapshot.data is a List<PaymentMethod>
                    final List<PaymentMethod> paymentMethods = snapshot.data!;

                    // Map each payment method to a Text widget or any other widget you want
                    return Column(
                      children: paymentMethods.map<Widget>((paymentMethod) {
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.radio_button_checked),
                              SvgPicture.network(
                                paymentMethod.icon,
                              ),
                            ],
                          ),
                          title: Text(
                            paymentMethod.name,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            height: 30,
                            child: ListView.separated(
                              addAutomaticKeepAlives: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: paymentMethod.images.length,
                              itemBuilder: (context, index) => ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                                child: (paymentMethod.images[index]
                                        .toString()
                                        .endsWith('.svg')
                                    ? SvgPicture.network(
                                        paymentMethod.images[index],
                                        height: 18,
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: paymentMethod.images[index],
                                        height: 18,
                                      )),
                              ),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(
                                width: ThemeConstants.paddingSmall,
                              ),
                            ),
                          ),
                          onTap: () {},
                        ); // Use the actual property
                      }).toList(),
                    );
                  }
                },
              ),
              const SizedBox(height: ThemeConstants.paddingSmall),
              Text(
                "Order details",
                style: _buildSubHeadingStyles(),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                leading: CachedNetworkImage(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/arzam-physics-app.appspot.com/o/images%2F1726386727792_469221.jpeg?alt=media&token=0dbbe78f-dab9-4c49-a978-161ef47d6785",
                  width: 50,
                  height: 50,
                ),
                title: const Text(
                  "Complete English Course: Master English Beginner to Advanced",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Rs.3000",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      "Rs.5000",
                      style: TextStyle(decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: ThemeConstants.paddingSmall),
              Text(
                "Promotions",
                style: _buildSubHeadingStyles(),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Expanded(
                      child: TextField(
                        maxLength: 25,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          counterText: '',
                          hintText: "Enter Coupon",
                          contentPadding: EdgeInsets.all(
                            ThemeConstants.paddingSmall,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                ThemeConstants.borderRadiusSmall,
                              ),
                              bottomLeft: Radius.circular(
                                ThemeConstants.borderRadiusSmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                ThemeConstants.borderRadiusSmall,
                              ),
                              bottomRight: Radius.circular(
                                ThemeConstants.borderRadiusSmall,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text("Apply"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            top: ThemeConstants.paddingSmall,
            left: ThemeConstants.paddingSmall,
            right: ThemeConstants.paddingSmall,
            bottom: ThemeConstants.paddingSmall +
                MediaQuery.paddingOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total:",
                    style: _buildSubHeadingStyles(),
                  ),
                  Text(
                    "Rs.3000",
                    style: _buildSubHeadingStyles(),
                  ),
                ],
              ),
              const SizedBox(height: ThemeConstants.paddingSmall),
              const Text(
                "By completing your purchase you agree to these Terms of Service",
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: ThemeConstants.paddingSmall),
              PrimaryButton(
                text: "Proceed",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle _buildSubHeadingStyles() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
