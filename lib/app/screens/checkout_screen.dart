import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: ThemeConstants.paddingSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Payment method",
              style: _buildSubHeadingStyles(),
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
    );
  }

  TextStyle _buildSubHeadingStyles() {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
