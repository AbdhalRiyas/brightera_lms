import 'package:app/app/models/course.dart';
import 'package:app/app/models/lecture.dart';
import 'package:app/app/models/section.dart';
import 'package:app/app/models/user.dart';
import 'package:app/app/services/auth_manager.dart';
import 'package:app/app/utils/generate_unique_file_name.dart';
import 'package:app/app/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../services/firebase_service.dart';

class CourseRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<Result> uploadCourseCover(String filePath) async {
    return await _firebaseService.uploadFile(
        'images/${generateUniqueFileName(filePath.split('.').last)}', filePath);
  }

  Future<Result> createCourse(Course course) async {
    return await _firebaseService.addDocument(
      collection: 'courses',
      data: course.toFirestore(),
    );
  }

  Future<Result> updateCourse(Course course) async {
    return await _firebaseService.updateDocument(
        collection: 'courses',
        documentId: course.id,
        data: course.toFirestore());
  }

  Future<List<Course>> getCoursesBySubject(String subjectId,
      [bool onlyFeatured = false]) async {
    // Fetch user data from Firebase
    final data =
        await _firebaseService.getCoursesBySubject(subjectId, onlyFeatured);
    final List<Course> courses = [];

    // Ensure data is not null and iterate through documents
    if (data != null) {
      for (var doc in data.docs) {
        // Create a Course object from the document
        Course course = Course.fromFirestore(doc);

        // Fetch the instructor data
        if (course.instructor != null) {
          User? instructor = await _getInstructorInfo(course.instructor!);
          // Add instructor data to the course if needed
          course = course.copyWith(instructorInfo: instructor);
        }

        courses.add(course);
      }
    }
    return courses;
  }

  Stream<List<Course>> getCoursesStream() {
    final userDetails = AuthManager().userDetails;
    return _firebaseService.getCollectionStream(
      collection: 'courses',
      fromFirestore: Course.fromFirestore,
      comparisonField:
          userDetails?['userRole'] != UserRole.admin ? 'instructor' : null,
      referenceCollection: 'users',
      referenceId: userDetails?['userRole'] != UserRole.admin
          ? _firebaseService.currentUser?.uid
          : null,
    );
  }

  Future<bool> checkActiveEnrollment(String courseId) async {
    final enrollmentData = await _firebaseService.getCourseEnrollment(courseId);
    return enrollmentData?.docs.isNotEmpty ?? false;
  }

  Future<List<Section>> fetchSectionsForCourse(String courseId) async {
    final sectionsData = await _firebaseService.getSectionsForCourse(courseId);
    final List<Section> sections = [];

    if (sectionsData != null) {
      for (var sectionDoc in sectionsData.docs) {
        // Fetch lectures for each section
        final lectures =
            await _fetchLecturesForSection(courseId, sectionDoc.id);

        sections.add(Section.fromFirestore(sectionDoc, lectures));
      }
    }
    return sections;
  }

  Future<List<Lecture>> _fetchLecturesForSection(
      String courseId, String sectionId) async {
    final lecturesData =
        await _firebaseService.getLecturesForSection(courseId, sectionId);
    final List<Lecture> lectures = [];

    if (lecturesData != null) {
      for (var lectureDoc in lecturesData.docs) {
        lectures.add(Lecture.fromFirestore(lectureDoc));
      }
    }
    return lectures;
  }

  Future<User?> _getInstructorInfo(DocumentReference instructorRef) async {
    try {
      // Fetch the document snapshot
      DocumentSnapshot<Map<String, dynamic>> doc =
          await instructorRef.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (doc.exists) {
        return User.fromFirestore(doc);
      } else {
        debugPrint('Instructor document does not exist');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching instructor data: $e');
      return null;
    }
  }
}
