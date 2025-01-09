import 'package:app/src/models/order.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/generate_unique_file_name.dart';
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

  Future<Result> updateOrder(Order order) async {
    return await _firebaseService.updateDocument(
      collection: collection,
      documentId: order.id,
      data: order.toFirestore(),
    );
  }

  Future<Result> addPaymentProof(String filePath) async {
    return await _firebaseService.uploadFile(
      'paymentProofs/${generateUniqueFileName(filePath.split('.').last)}',
      filePath,
    );
  }

  Future<List<Order>> getUserOrders(String userId) async {
    final data = await _firebaseService.getCollection(
      collection: collection,
      fromFirestore: Order.fromFirestore,
      comparisonField: 'userId',
      referenceCollection: 'users',
      referenceId: userId,
    );
    return data;
  }

  Stream<Order> getOrderStream(String orderId) {
    return _firebaseService.getDocumentStream(
      collection: collection,
      documentId: orderId,
      fromFirestore: Order.fromFirestore,
    );
  }
}
