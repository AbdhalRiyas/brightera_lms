import 'package:app/app/models/subject.dart';

import '../services/firebase_service.dart';

class SubjectRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Subject>> getAllSubjects() async {
    // Fetch user data from Firebase
    final data = await _firebaseService.getAllSubjects();
    final List<Subject> subjects = [];

    // Ensure data is not null and iterate through documents
    if (data != null) {
      for (var doc in data.docs) {
        // Create a Subject object from each document
        subjects.add(Subject(
          id: doc.id,
          isActive: doc['is_active'],
          isHidden: doc['is_hidden'], // Corrected the typo 'is_hideen'
          name: doc['name'],
          icon: doc['icon'],
        ));
      }
    }
    return subjects;
  }
}
