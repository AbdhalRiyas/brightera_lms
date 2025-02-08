import 'package:app/src/models/order.dart' as order_model;
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/generate_unique_file_name.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderRepository {
  final FirebaseService _firebaseService = FirebaseService();

  final String collection = 'orders';

  Future<Result> createOrder(order_model.Order order) async {
    return await _firebaseService.createDocument(
      collection: collection,
      data: order.toFirestore(),
    );
  }

  Future<Result> updateOrder(order_model.Order order) async {
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

  Future<List<order_model.Order>> getUserOrders(String userId) async {
    final data = await _firebaseService.getCollection(
      collection: collection,
      fromFirestore: order_model.Order.fromFirestore,
      comparisonField: 'userId',
      referenceCollection: 'users',
      referenceId: userId,
    );
    return data;
  }

  Future<List<order_model.Order>> getUserOrdersPaginated(
    String userId, {
    int limit = 10,
    DocumentSnapshot? lastDoc,
  }) async {
    final data = await _firebaseService.getCollection(
      collection: collection,
      fromFirestore: order_model.Order.fromFirestore,
      comparisonField: 'userId',
      referenceCollection: 'users',
      referenceId: userId,
      limit: limit,
      lastDocument: lastDoc,
    );

    return data;
  }

  Stream<order_model.Order> getOrderStream(String orderId) {
    return _firebaseService.getDocumentStream(
      collection: collection,
      documentId: orderId,
      fromFirestore: order_model.Order.fromFirestore,
    );
  }

  Stream<List<order_model.Order>> getOrdersStream() {
    return _firebaseService.getCollectionStream(
      collection: collection,
      fromFirestore: order_model.Order.fromFirestore,
    );
  }
}
