import 'package:app/src/models/coupon.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CouponRepository {
  final FirebaseService _firebaseService = FirebaseService();
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final String collection = 'coupons';

  Future<Result> createCoupon(Coupon coupon) async {
    return await _firebaseService.createDocument(
      collection: collection,
      data: coupon.toFireStore(),
    );
  }

  Future<List<Coupon>> getCoupons() async {
    final data = await _firebaseService.getCollection(
      collection: collection,
      fromFirestore: (doc) => Coupon.fromFirestore(doc),
    );
    return data;
  }

  Stream<List<Coupon>> getCouponsStream() {
    return _firebaseService.getCollectionStream(
      collection: collection,
      fromFirestore: (doc) => Coupon.fromFirestore(doc),
    );
  }

  Future<Result> updateCoupon(Coupon coupon) async {
    return await _firebaseService.updateDocument(
      collection: collection,
      documentId: coupon.id,
      data: coupon.toFireStore(),
    );
  }

  Future<Result> deleteCoupon(String couponId) async {
    return await _firebaseService.deleteDocument(
      collection: collection,
      documentId: couponId,
    );
  }

  Future<Result> applyCoupon(String couponCode, String courseId) async {
    final HttpsCallable callable = _functions
        .httpsCallable('applyCoupon'); // Replace with your Cloud Function name
    final result = await callable.call(<String, dynamic>{
      'couponCode': couponCode,
      'courseId': courseId,
    });

    return result.data;
  }
}
