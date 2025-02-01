import 'package:flutter/material.dart';

class EnrollmentsScreen extends StatelessWidget {
  const EnrollmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
      ),
      body: const Center(
        child: Text('Enrollments Screen'),
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
