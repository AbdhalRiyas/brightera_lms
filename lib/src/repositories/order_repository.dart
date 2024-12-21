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
}
