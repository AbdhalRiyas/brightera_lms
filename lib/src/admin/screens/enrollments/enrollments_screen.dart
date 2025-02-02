import 'package:app/src/models/enrollment.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:flutter/material.dart';

class EnrollmentsScreen extends StatefulWidget {
  const EnrollmentsScreen({super.key});

  @override
  State<EnrollmentsScreen> createState() => _EnrollmentsScreenState();
}

class _EnrollmentsScreenState extends State<EnrollmentsScreen> {
  final CourseRepository _repository = CourseRepository();
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
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Course: ${enrollment.course.id}'),
                Text('User: ${enrollment.user.id}'),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
