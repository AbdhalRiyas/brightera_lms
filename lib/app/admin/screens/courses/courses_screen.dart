import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomAppBar(),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: ThemeConstants.cardElevation,
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      body: const Placeholder(),
    );
  }
}
