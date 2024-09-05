import 'package:app/app/models/course.dart';

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
          title: doc['title'],
          description: doc['description'], // Corrected the typo 'is_hideen'
          price: doc['price'], subject: doc['subject'],
        ));
      }
    }
    return courses;
  }
}
