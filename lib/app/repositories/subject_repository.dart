import 'package:app/app/models/subject.dart';
import 'package:app/app/utils/generate_unique_file_name.dart';
import 'package:app/app/utils/result.dart';

import '../services/firebase_service.dart';

class SubjectRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<Result> uploadIcon(String filePath) async {
    return await _firebaseService.uploadFile(
        'icons/${generateUniqueFileName('svg')}', filePath);
  }

  Future<Result> updateSubject(Subject subject) async {
    return await _firebaseService.updateDocument(
        collection: 'subjects',
        documentId: subject.id,
        data: subject.toFirestoreJson());
  }

  Future<List<Subject>> getAllSubjects() async {
    // Fetch user data from Firebase
    final data = await _firebaseService.getCollection('subjects');
    final List<Subject> subjects = [];

    // Ensure data is not null and iterate through documents
    if (data != null) {
      for (var doc in data.docs) {
        // Create a Subject object from each document
        subjects.add(Subject.fromFirestore(doc));
      }
    }
    return subjects;
  }

  Stream<List<Subject>> getSubjectsStream() {
    return _firebaseService.getCollectionStream(
        collection: 'subjects', fromFirestore: Subject.fromFirestore);
  }
}
