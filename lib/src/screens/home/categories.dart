import 'package:app/src/config/theme_constants.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      "Maths",
      "Science",
      "English",
      "History",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Categories",
              style: ThemeConstants.headingStyle,
            ),
            TextButton(
              onPressed: () {
                // Implement view all categories logic here
              },
              child: const Text(
                "View All",
                style: TextStyle(
                  color: ThemeConstants.primaryColor,
                ),
              ),
            ),
          ],
        ),
        Wrap(
          runSpacing: 5,
          spacing: 10,
          children: List.generate(
            categories.length,
            (index) => OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
              ),
              child: Text(categories[index]),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}
