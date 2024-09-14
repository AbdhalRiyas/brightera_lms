import 'package:app/app/models/subject.dart';
import 'package:app/app/repositories/subject_repository.dart';
import 'package:app/app/widgets/seperator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/edit_subject.dart';

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
        onPressed: () {
          // Add new subject logic
        },
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
              itemBuilder: (context, i) => ListTile(
                leading: SvgPicture.network(
                  subjects[i].icon,
                  height: 18,
                ),
                title: Text(subjects[i].name),
                onTap: () => editSubject(context, _repository, subjects[i]),
              ),
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
