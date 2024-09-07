import 'package:app/app/models/course.dart';
import 'package:app/app/models/lecture.dart';
import 'package:app/app/models/section.dart';

import '../services/firebase_service.dart';

class CourseRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Course>> getCoursesBySubject(String subjectId,
      [bool onlyFeatured = false]) async {
    // Fetch user data from Firebase
    final data =
        await _firebaseService.getCoursesBySubject(subjectId, onlyFeatured);
    final List<Course> courses = [];

    // Ensure data is not null and iterate through documents
    if (data != null) {
      for (var doc in data.docs) {
        // Create a Subject object from each document
        courses.add(Course(
          id: doc.id,
          image: doc['image'],
          title: doc['title'],
          description: doc['description'],
          salePrice: doc['salePrice'],
          regularPrice: doc['regularPrice'],
          subject: doc['subject'],
          durationInHours: doc['durationInHours'],
        ));
      }
    }
    return courses;
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
}
