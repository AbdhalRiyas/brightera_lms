import 'package:app/src/admin/screens/enrollments/enrollment_add_edit_dialog.dart';
import 'package:app/src/models/enrollment.dart';
import 'package:app/src/repositories/enrollment_repository.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnrollmentsScreen extends StatefulWidget {
  const EnrollmentsScreen({super.key});

  @override
  State<EnrollmentsScreen> createState() => _EnrollmentsScreenState();
}

class _EnrollmentsScreenState extends State<EnrollmentsScreen> {
  final EnrollmentRepository _repository = EnrollmentRepository();
  final ScrollController _scrollController = ScrollController();
  final List<Enrollment> _enrollments = [];
  bool _isLoading = false;
  bool _hasMore = true;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _loadMoreEnrollments();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _loadMoreEnrollments();
      }
    });
  }

  Future<void> _loadMoreEnrollments() async {
    setState(() {
      _isLoading = true;
    });

    final newEnrollments = await _repository
        .getEnrollmentsStream(
          limit: 10,
          startAfter: _lastDocument,
        )
        .first;

    setState(() {
      _enrollments.addAll(newEnrollments);
      _isLoading = false;
      if (newEnrollments.isNotEmpty) {
        _lastDocument = newEnrollments.last.snapshot;
      } else {
        _hasMore = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
      ),
      body: _enrollments.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : ListView.separated(
              controller: _scrollController,
              itemCount: _enrollments.length + (_hasMore ? 1 : 0),
              itemBuilder: (_, index) {
                if (index == _enrollments.length) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                final enrollment = _enrollments[index];
                return Dismissible(
                  key: Key(enrollment.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    Result result =
                        await _repository.deleteEnrollment(enrollment.id);

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
                  ),
                );
              },
              separatorBuilder: (context, i) => const Divider(),
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
