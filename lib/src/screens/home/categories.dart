import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/models/subject.dart';
import 'package:app/src/repositories/subject_repository.dart';
import 'package:app/src/route/screen_exports.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final SubjectRepository _repository = SubjectRepository();
  List<Subject> _categories = [];

  Future<void> fetchCategories() async {
    final categories = await _repository.getAllSubjects();
    setState(() {
      _categories = categories;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Categories",
          style: ThemeConstants.headingStyle,
        ),
        const SizedBox(height: 10),
        Wrap(
          runSpacing: 5,
          spacing: 10,
          children: List.generate(
            _categories.length,
            (index) => OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
              ),
              child: Text(_categories[index].name),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/all-courses',
                  arguments: ListOfCoursesScreenArguments(
                    subject: _categories[index],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
