import 'package:app/src/admin/screens/enrollments/enrollment_add_edit_dialog.dart';
import 'package:app/src/models/enrollment.dart';
import 'package:app/src/repositories/enrollment_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnrollmentsScreen extends StatefulWidget {
  const EnrollmentsScreen({super.key});

  @override
  State<EnrollmentsScreen> createState() => _EnrollmentsScreenState();
}

class _EnrollmentsScreenState extends State<EnrollmentsScreen> {
  final EnrollmentRepository _repository = EnrollmentRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
      ),
      body: StreamBuilder<List<Enrollment>>(
        stream: _repository.getEnrollmentsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No enrollments found"));
          }

          final enrollments = snapshot.data!;
          return ListView.builder(
            itemCount: enrollments.length,
            itemBuilder: (_, index) {
              final enrollment = enrollments[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(enrollment.user.id),
                    Text(enrollment.courseInfo!.title),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${enrollment.status}'),
                    Text(
                        'Enrolled At: ${DateFormat('dd MMM yyyy').format(enrollment.startDate.toDate())}'),
                    Text(
                        'Expires At: ${DateFormat('dd MMM yyyy').format(enrollment.endDate.toDate())}'),
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
