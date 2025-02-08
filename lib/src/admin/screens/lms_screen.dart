import 'package:app/src/admin/screens/banners/banners_screen.dart';
import 'package:app/src/admin/screens/coupons/coupons_screen.dart';
import 'package:app/src/admin/screens/courses/courses_screen.dart';
import 'package:app/src/admin/screens/enrollments/enrollments_screen.dart';
import 'package:app/src/admin/screens/featured_courses/featured_courses_screen.dart';
import 'package:app/src/admin/screens/orders/orders_screen.dart';
import 'package:app/src/admin/screens/popular_courses/popular_courses_screen.dart';
import 'package:app/src/admin/screens/subjects/subjects_screen.dart';
import 'package:app/src/widgets/custom_app_bar.dart';
import 'package:app/src/widgets/seperator.dart';
import 'package:flutter/material.dart';

class LmsScreen extends StatefulWidget {
  const LmsScreen({super.key});

  @override
  State<LmsScreen> createState() => _LmsScreenState();
}

class _LmsScreenState extends State<LmsScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      "title": "Subjects",
      "icon": Icons.subject,
      "navigation": const SubjectsScreen(),
    },
    {
      "title": "Courses",
      "icon": Icons.book,
      "navigation": const CoursesScreen(),
    },
    {
      "title": "Coupons",
      "icon": Icons.card_giftcard,
      "navigation": const CouponsScreen(),
    },
    {
      "title": "Featured Courses",
      "icon": Icons.book,
      "navigation": const FeaturedCoursesScreen(),
    },
    {
      "title": "Popular Courses",
      "icon": Icons.star,
      "navigation": const PopularCoursesScreen(),
    },
    {
      "title": "Enrollments",
      "icon": Icons.highlight,
      "navigation": const EnrollmentsScreen(),
    },
    {
      "title": "Banners",
      "icon": Icons.image,
      "navigation": const BannersScreen(),
    },
    {
      "title": "Orders",
      "icon": Icons.storage,
      "navigation": const OrdersScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(),
      ),
      body: ListView.separated(
        itemCount: _items.length,
        itemBuilder: (context, i) => ListTile(
          leading: Icon(_items[i]['icon']),
          title: Text(_items[i]['title']),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _items[i]['navigation'],
              ),
            );
          },
        ),
        separatorBuilder: (context, index) => const Seperator(),
      ),
    );
  }
}
