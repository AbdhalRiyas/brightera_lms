import 'package:app/src/models/course.dart';
import 'package:app/src/models/enrollment.dart';
import 'package:app/src/repositories/course_repository.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnrollmentRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final CourseRepository _courseRepository = CourseRepository();

  Future<List<Enrollment>> getAllEnrollments() async {
    final data = await _firebaseService.getCollection(
        collection: 'enrollments',
        fromFirestore: Enrollment.fromFirestore,
        orderByField: 'startDate',
        descending: true);
    final List<Enrollment> enrollments = [];
    for (var doc in data) {
      Enrollment enrollment = doc;
      Course? course =
          await _courseRepository.getCourseDetails(enrollment.course.id);
      enrollment = enrollment.copyWith(courseInfo: course);
      enrollments.add(enrollment);
    }
    return enrollments;
  }

  Future<List<Enrollment>> getUserEnrollments(String activeStatus,
      {int limit = 10, DocumentSnapshot? lastDoc}) async {
    final data = await _firebaseService.getCollection(
      collection: 'enrollments',
      fromFirestore: Enrollment.fromFirestore,
      comparisonField: 'userId',
      referenceCollection: 'users',
      referenceId: _firebaseService.currentUser?.uid,
      // filters: {'status': activeStatus},
      limit: limit,
      lastDocument: lastDoc,
    );
    final List<Enrollment> enrollments = [];
    for (var doc in data) {
      Enrollment enrollment = doc;
      Course? course =
          await _courseRepository.getCourseDetails(enrollment.course.id);
      if (course != null) {
        enrollment = enrollment.copyWith(courseInfo: course);
        enrollments.add(enrollment);
      }
    }
    return enrollments;
  }

  Future<Result> addEnrollment(Enrollment enrollment) async {
    final result = await _firebaseService.createDocument(
      collection: 'enrollments',
      data: enrollment.toFirestore(),
    );
    return result;
  }

  Future<Result> updateEnrollment(Enrollment enrollment) async {
    final result = await _firebaseService.updateDocument(
      collection: 'enrollments',
      documentId: enrollment.id,
      data: enrollment.toFirestore(),
    );
    return result;
  }

  Stream<List<Enrollment>> getEnrollmentsStream(
      {int limit = 10, DocumentSnapshot? startAfter}) {
    return _firebaseService
        .getCollectionStream(
      collection: 'enrollments',
      fromFirestore: Enrollment.fromFirestore,
      orderByField: 'startDate',
      descending: true,
      limit: limit,
      startAfterDocument: startAfter,
    )
        .asyncMap((docs) async {
      List<Enrollment> enrollments = [];
      for (var doc in docs) {
        Enrollment enrollment = doc;
        Course? course =
            await _courseRepository.getCourseDetails(enrollment.course.id);
        if (course != null) {
          enrollments.add(enrollment.copyWith(courseInfo: course));
        }
      }
      return enrollments;
    });
  }

  // delete existing enrollment
  Future<Result> deleteEnrollment(String enrollmentId) async {
    return await _firebaseService.deleteDocument(
      collection: 'enrollments',
      documentId: enrollmentId,
    );
  }

  Future<bool> checkExistingEnrollment(String courseId, String userId) async {
    DocumentReference courseRef =
        FirebaseFirestore.instance.collection('courses').doc(courseId);

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Query the subscriptions collection
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('enrollments')
        .where('userId', isEqualTo: userRef) // Use the user's UID directly
        .where('courseId',
            isEqualTo: courseRef) // Compare course ID as a string
        .get();

    if (snapshot.docs.isNotEmpty) {
      for (var doc in snapshot.docs) {
        await _firebaseService.deleteDocument(
          collection: 'enrollments',
          documentId: doc.id,
        );
      }
      return true;
    }
    return false;
  }
}
