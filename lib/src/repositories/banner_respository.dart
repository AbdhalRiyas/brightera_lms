import 'package:app/src/models/app_banner.dart';

import '../services/firebase_service.dart';

class BannerRespository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Appbanner>> getAllActiveBanners() async {
    // Fetch user data from Firebase
    final data = await _firebaseService.getAllBanners(activeOnly: true);
    final List<Appbanner> banners = [];

    // Ensure data is not null and iterate through documents
    if (data != null) {
      for (var doc in data.docs) {
        // Create a Subject object from each document
        banners.add(Appbanner(
          imagePath: doc['image_path'],
          link: doc['link'],
          order: doc['order'],
        ));
      }
    }
    return banners;
  }
}
