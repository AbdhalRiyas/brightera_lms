import 'package:app/src/models/app_banner.dart';
import 'package:app/src/utils/generate_unique_file_name.dart';
import 'package:app/src/utils/result.dart';

import '../services/firebase_service.dart';

class BannerRespository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<Result> uploadBannerImage(String filePath) async {
    return await _firebaseService.uploadFile(
      'banners/${generateUniqueFileName(filePath.split('.').last)}',
      filePath,
    );
  }

  Future<List<Appbanner>> getAllActiveBanners() async {
    // Fetch user data from Firebase
    final data = await _firebaseService.getAllBanners(activeOnly: true);
    final List<Appbanner> banners = [];

    // Ensure data is not null and iterate through documents
    if (data != null) {
      for (var doc in data.docs) {
        // Create a Subject object from each document
        banners.add(Appbanner(
          id: doc.id,
          imagePath: doc['image_path'],
          link: doc['link'],
          isHidden: doc['is_hidden'],
          order: doc['order'],
        ));
      }
    }
    return banners;
  }

  Future<Result> addBanner(Appbanner banner) async {
    return await _firebaseService.createDocument(
      collection: "banners",
      data: banner.toFirestore(),
    );
  }

  Future<Result> updateBanner(Appbanner banner) async {
    return await _firebaseService.updateDocument(
      collection: "banners",
      documentId: banner.id,
      data: banner.toFirestore(),
    );
  }

  Future<Result> deleteBanner(Appbanner banner) async {
    return await _firebaseService.deleteDocument(
      collection: "banners",
      documentId: banner.id,
    );
  }

  Future<List<Appbanner>> getAllBanners() async {
    // Fetch user data from Firebase
    final data = await _firebaseService.getAllBanners(activeOnly: false);
    final List<Appbanner> banners = [];

    // Ensure data is not null and iterate through documents
    if (data != null) {
      for (var doc in data.docs) {
        // Create a Subject object from each document
        banners.add(Appbanner(
          id: doc.id,
          imagePath: doc['image_path'],
          link: doc['link'],
          isHidden: doc['is_hidden'],
          order: doc['order'],
        ));
      }
    }
    return banners;
  }

  Stream<List<Appbanner>> getBannersStream() {
    return _firebaseService.getCollectionStream(
      collection: 'banners',
      fromFirestore: (doc) => Appbanner.fromFirestore(doc),
    );
  }
}
