import 'package:app/src/models/course.dart';
import 'package:app/src/models/lecture.dart';
import 'package:app/src/models/section.dart';
import 'package:app/src/models/user.dart';
import 'package:app/src/services/auth_manager.dart';
import 'package:app/src/utils/generate_unique_file_name.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../services/firebase_service.dart';

class CourseRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<Result> uploadCourseCover(String filePath) async {
    return await _firebaseService.uploadFile(
        'images/${generateUniqueFileName(filePath.split('.').last)}', filePath);
  }

  DocumentReference<Map<String, dynamic>> getCourseReference(
      String documentPath) {
    return _firebaseService.getDocumentReference('courses', documentPath);
  }

  Future<Result> createCourse(Course course) async {
    return await _firebaseService.createDocument(
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

  Future<Result> createSection(
      {required String courseId, required Section section}) async {
    return await _firebaseService.createDocument(
      collection: 'courses',
      subCollectionPaths: [
        {"subCollection": "sections", "subDocumentId": ""},
      ],
      documentId: courseId,
      data: section.toFirestore(),
    );
  }

  Future<Result> updateSection(
      {required String courseId, required Section section}) async {
    return await _firebaseService.updateDocument(
      collection: 'courses',
      subCollectionPaths: [
        {"subCollection": "sections", "subDocumentId": section.id},
      ],
      documentId: courseId,
      data: section.toFirestore(),
    );
  }

  Future<Result> deleteSection({
    required String courseId,
    required String sectionId,
  }) async {
    return await _firebaseService.deleteDocument(
      collection: 'courses',
      documentId: courseId,
      subCollectionPaths: [
        {"subCollection": "sections", "subDocumentId": sectionId},
      ],
    );
  }

  Future<Result> createLecture(
      {required String courseId,
      required String sectionId,
      required Lecture lecture}) async {
    return await _firebaseService.createDocument(
      collection: 'courses',
      subCollectionPaths: [
        {"subCollection": "sections", "subDocumentId": sectionId},
        {"subCollection": "lectures", "subDocumentId": ""}
      ],
      documentId: courseId,
      data: lecture.toFirestore(),
    );
  }

  Future<Result> updateLecture(
      {required String courseId,
      required String sectionId,
      required Lecture lecture}) async {
    return await _firebaseService.updateDocument(
        collection: 'courses',
        subCollectionPaths: [
          {"subCollection": "sections", "subDocumentId": sectionId},
          {"subCollection": "lectures", "subDocumentId": lecture.id}
        ],
        documentId: courseId,
        data: lecture.toFirestore());
  }

  Future<Result> deleteLecture({
    required String courseId,
    required String sectionId,
    required Lecture lecture,
  }) async {
    return await _firebaseService.deleteDocument(
      collection: 'courses',
      documentId: courseId,
      subCollectionPaths: [
        {"subCollection": "sections", "subDocumentId": sectionId},
        {"subCollection": "lectures", "subDocumentId": lecture.id}
      ],
    );
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

  Future<Course?> getCourseDetails(String courseId) async {
    final courseData =
        await _firebaseService.getDocumentById(courseId, 'courses');
    final course = Course.fromFirestore(courseData);
    if (course.instructor != null) {
      final instructor = await _getInstructorInfo(course.instructor!);
      return course.copyWith(instructorInfo: instructor);
    }
    return course;
  }

  Future<List<Course>> getCourses() {
    // final userDetails = AuthManager().userDetails;
    return _firebaseService.getCollection(
      collection: 'courses',
      fromFirestore: Course.fromFirestore,
      // comparisonField:
      //     userDetails?['userRole'] != UserRole.admin ? 'instructor' : null,
      // referenceCollection: 'users',
      // referenceId: userDetails?['userRole'] != UserRole.admin
      //     ? _firebaseService.currentUser?.uid
      //     : null,
    );
  }

  Future<List<String>> getHomeCourseIds(
    String documentId,
  ) async {
    final popularCourseIds =
        await _firebaseService.getDocumentById(documentId, 'home');
    return popularCourseIds.data()?['courseIds']?.cast<String>() ?? [];
  }

  Future<Result> updateHomeCourses(
    List<String> courseIds,
    String documentId,
  ) async {
    return await _firebaseService.updateDocument(
      collection: "home",
      documentId: documentId,
      data: {'courseIds': courseIds},
    );
  }

  Future<Result> removeCourseFromHome(
    String courseId,
    String documentId,
  ) async {
    final courseIds = await getHomeCourseIds(documentId);
    courseIds.remove(courseId);
    return await updateHomeCourses(courseIds, documentId);
  }

  Future<List<Course>> getHomeCourses(
    String documentId,
  ) async {
    final homeCourseIds = await getHomeCourseIds(
      documentId,
    );
    final List<Course> homeCourses = [];

    for (var courseId in homeCourseIds) {
      final course = await getCourseDetails(courseId);
      if (course != null) {
        homeCourses.add(course);
      }
    }
    return homeCourses;
  }

  // get home courses by language
  Future<List<Course>> getFeaturedCoursesByLanguage(String language) async {
    final homeCourses = await getHomeCourses(
      'featuredCourses',
    );
    return language == 'All'
        ? homeCourses
        : homeCourses.where((course) => course.language == language).toList();
  }

  Future<List<Course>> getCoursesByLanguage(String language) {
    return _firebaseService.getCollection(
      collection: 'courses',
      fromFirestore: Course.fromFirestore,
      comparisonField: language == 'All' ? null : 'language',
      comparisonValue: language,
    );
  }

  // search courses by title
  Future<List<Course>> searchCourses(String query) async {
    final data = await _firebaseService.searchCoursesByTitle(query);
    final List<Course> courses = [];

    if (data != null) {
      for (var doc in data.docs) {
        Course course = Course.fromFirestore(doc);
        if (course.instructor != null) {
          User? instructor = await _getInstructorInfo(course.instructor!);
          course = course.copyWith(instructorInfo: instructor);
        }
        courses.add(course);
      }
    }
    return courses;
  }

  Future<List<Map<String, dynamic>>> getEnrollments(String activeStatus,
      {int limit = 10, DocumentSnapshot? lastDoc}) async {
    return await _firebaseService.getCollection(
      collection: 'enrollments',
      fromFirestore: (doc) => doc.data()!,
      comparisonField: 'userId',
      referenceCollection: 'users',
      referenceId: _firebaseService.currentUser?.uid,
      filters: {'status': activeStatus},
      limit: limit,
      lastDocument: lastDoc,
    );
  }

  Future<List<Course>> getEnrolledCourses(String activeStatus,
      {int limit = 10, DocumentSnapshot? lastDoc}) async {
    final enrollments =
        await getEnrollments(activeStatus, limit: limit, lastDoc: lastDoc);
    final List<Course> courses = [];

    for (var enrollment in enrollments) {
      final courseId = enrollment['courseId'].id;
      final course = await getCourseDetails(courseId);
      if (course != null) {
        courses.add(course);
      }
    }
    return courses;
  }
}
