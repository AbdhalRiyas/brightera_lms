import 'package:app/src/models/subject.dart';
import 'package:app/src/utils/generate_unique_file_name.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firebase_service.dart';

class SubjectRepository {
  final FirebaseService _firebaseService = FirebaseService();

  DocumentReference<Map<String, dynamic>> getSubjectReference(
      String documentPath) {
    return _firebaseService.getDocumentReference('subjects', documentPath);
  }

  Future<Result> uploadIcon(String filePath) async {
    return await _firebaseService.uploadFile(
        'icons/${generateUniqueFileName('svg')}', filePath);
  }

  Future<Result> createSubject(Subject subject) async {
    return await _firebaseService.createDocument(
      collection: 'subjects',
      data: subject.toFirestoreJson(),
    );
  }

  Future<Result> updateSubject(Subject subject) async {
    return await _firebaseService.updateDocument(
        collection: 'subjects',
        documentId: subject.id,
        data: subject.toFirestoreJson());
  }

  Future<Result> deleteSubject(String subjectId) async {
    return await _firebaseService.deleteDocument(
      collection: 'subjects',
      documentId: subjectId,
      referenceCollection: 'courses',
      referenceField: 'subject',
    );
  }

  Future<List<Subject>> getAllSubjects() async {
    // Fetch user data from Firebase
    final data = await _firebaseService.getCollection(
        collection: 'subjects', fromFirestore: Subject.fromFirestore);

    return data;
  }

  Stream<List<Subject>> getSubjectsStream() {
    return _firebaseService.getCollectionStream(
        collection: 'subjects', fromFirestore: Subject.fromFirestore);
  }
}
