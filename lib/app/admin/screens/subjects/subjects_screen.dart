// ignore_for_file: use_build_context_synchronously

import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/utils/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/add_edit_subject.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  final SubjectRepository _repository = SubjectRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subjects")),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addEditSubject(context, _repository),
      ),
      body: StreamBuilder<List<Subject>>(
        stream: _repository.getSubjectsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final subjects = snapshot.data!;
            return ListView.separated(
              itemBuilder: (context, i) {
                final subject = subjects[i];

                return Dismissible(
                  key: Key(subject
                      .id), // Ensure each item has a unique key (e.g., the item's ID)
                  direction:
                      DismissDirection.endToStart, // Swipe from right to left
                  confirmDismiss: (direction) async {
                    Result result = await _repository.deleteSubject(subject.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result.data ?? result.error),
                        backgroundColor:
                            result.isSuccess ? Colors.green : Colors.red,
                      ),
                    );

                    return result.isSuccess;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    leading: SvgPicture.network(
                      subject.icon,
                      height: 18,
                    ),
                    title: Text(subject.name),
                    onTap: () => addEditSubject(context, _repository, subject),
                  ),
                );
              },
              separatorBuilder: (context, i) => const Divider(),
              itemCount: subjects.length,
            );
          } else {
            return const Center(child: Text("No subjects have been added"));
          }
        },
      ),
    );
  }
}
