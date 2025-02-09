import 'package:app/src/models/announcement.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/generate_unique_file_name.dart';
import 'package:app/src/utils/result.dart';

class AnnouncementRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<Result> uploadAnnouncementImage(String filePath) async {
    return await _firebaseService.uploadFile(
      'announcements/${generateUniqueFileName(filePath.split('.').last)}',
      filePath,
    );
  }

  Future<List<Announcement>> getAllAnnouncements() async {
    return await _firebaseService.getCollection(
      collection: 'announcements',
      fromFirestore: Announcement.fromFirestore,
    );
  }

  Future<Result> addAnnouncement(Announcement announcement) async {
    return await _firebaseService.createDocument(
      collection: 'announcements',
      data: announcement.toFirestore(),
    );
  }

  Future<Result> updateAnnouncement(Announcement announcement) async {
    return await _firebaseService.updateDocument(
      collection: 'announcements',
      documentId: announcement.id,
      data: announcement.toFirestore(),
    );
  }

  Future<Result> deleteAnnouncement(String id) async {
    return await _firebaseService.deleteDocument(
      collection: 'announcements',
      documentId: id,
    );
  }

  Stream<List<Announcement>> announcementsStream() {
    return _firebaseService.getCollectionStream(
      collection: 'announcements',
      fromFirestore: Announcement.fromFirestore,
    );
  }
}
