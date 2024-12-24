import 'package:app/src/models/order.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/result.dart';

class OrderRepository {
  final FirebaseService _firebaseService = FirebaseService();

  final String collection = 'orders';

  Future<Result> createOrder(Order order) async {
    return await _firebaseService.createDocument(
      collection: collection,
      data: order.toFirestore(),
    );
  }

  //  Future<Result> uploadCourseCover(String filePath) async {
  //   return await _firebaseService.uploadFile(
  //       'images/${generateUniqueFileName(filePath.split('.').last)}', filePath);
  // }

  Future<Result> addPaymentProof(String orderId, String paymentProof) async {
    return await _firebaseService.updateDocument(
      collection: collection,
      documentId: orderId,
      data: {'paymentProof': paymentProof},
    );
  }

  Future<List<Order>> getUserOrders(String userId) async {
    final data = await _firebaseService.getCollection(
      collection: 'orders',
      fromFirestore: Order.fromFirestore,
      comparisonField: 'userId',
      referenceCollection: 'users',
      referenceId: userId,
    );

    return data;
  }
}
