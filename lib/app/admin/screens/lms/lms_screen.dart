import 'package:app/app/admin/screens/subjects/subjects_screen.dart';
import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/widgets/custom_app_bar.dart';
import 'package:app/app/widgets/seperator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LmsScreen extends StatelessWidget {
  const LmsScreen({super.key});

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
      body: ListView.separated(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          leading: SvgPicture.asset('assets/icons/subjects.svg'),
          title: const Text("Subjects"),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SubjectsScreen(),
              ),
            );
          },
        ),
        separatorBuilder: (context, index) => const Seperator(),
      ),
    );
  }
}
