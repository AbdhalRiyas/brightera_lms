import 'package:app/src/models/course.dart';
import 'package:app/src/repositories/subject_repository.dart';
import 'package:flutter/material.dart';

class SubjectField extends StatelessWidget {
  const SubjectField({
    super.key,
    required this.subjectRepository,
    required this.subject,
    this.course,
  });

  final SubjectRepository subjectRepository;
  final ValueNotifier<String?> subject;
  final Course? course;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: subjectRepository.getAllSubjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasData) {
            return DropdownButtonFormField<String>(
              items: List.generate(
                snapshot.data!.length,
                (i) {
                  return DropdownMenuItem(
                    value: "subjects/${snapshot.data?[i].id}",
                    child: Text(snapshot.data?[i].name ?? ''),
                  );
                },
              ).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please choose the course subject';
                }
                return null;
              },
              onChanged: (value) {
                // Handle value change
                subject.value = value;
              },
              value: course?.subject?.path,
              decoration: const InputDecoration(labelText: "Subject"),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black),
            );
          } else {
            return const Center(child: Text("Couldn't fetch subjects"));
          }
        });
  }
}
