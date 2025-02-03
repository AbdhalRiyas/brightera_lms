import 'package:app/src/admin/screens/enrollments/enrollment_add_edit_dialog.dart';
import 'package:app/src/models/enrollment.dart';
import 'package:app/src/repositories/enrollment_repository.dart';
import 'package:flutter/material.dart';

class EnrollmentsScreen extends StatefulWidget {
  const EnrollmentsScreen({super.key});

  @override
  State<EnrollmentsScreen> createState() => _EnrollmentsScreenState();
}

class _EnrollmentsScreenState extends State<EnrollmentsScreen> {
  final EnrollmentRepository _repository = EnrollmentRepository();
  List<Enrollment> _enrollments = [];

  Future<void> _fetchEnrollments() async {
    final enrollments = await _repository.getAllEnrollments();
    setState(() {
      _enrollments = enrollments;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchEnrollments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
      ),
      body: ListView.builder(
        itemCount: _enrollments.length,
        itemBuilder: (_, index) {
          final enrollment = _enrollments[index];
          return ListTile(
            title: Text('Course: ${enrollment.courseInfo!.title}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User: ${enrollment.user.id}'),
                Text('Status: ${enrollment.status}'),
                Text(
                    'Enrolled At: ${enrollment.startDate.toDate().day}/${enrollment.startDate.toDate().month}/${enrollment.startDate.toDate().year}'),
                Text(
                    'Expires At: ${enrollment.endDate.toDate().day}/${enrollment.endDate.toDate().month}/${enrollment.endDate.toDate().year}'),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return EnrollmentAddEditDialog(
                    enrollment: enrollment,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const EnrollmentAddEditDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
