import 'package:app/app/models/course.dart';
import 'package:flutter/material.dart';

class LanguageSelectorField extends StatelessWidget {
  const LanguageSelectorField({
    super.key,
    required this.language,
    this.course,
  });

  final ValueNotifier<String?> language;
  final Course? course;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      items: const [
        DropdownMenuItem(
          value: "தமிழ்",
          child: Text("தமிழ்"),
        ),
        DropdownMenuItem(
          value: "English",
          child: Text("English"),
        ),
        DropdownMenuItem(
          value: "සිංහල",
          child: Text("සිංහල"),
        ),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please choose the Course Language';
        }
        return null;
      },
      onChanged: (value) {
        language.value = value;
      },
      value: course?.language,
      decoration: const InputDecoration(labelText: "Language"),
      style: const TextStyle(
          fontSize: 12, fontWeight: FontWeight.w400, color: Colors.black),
    );
  }
}
