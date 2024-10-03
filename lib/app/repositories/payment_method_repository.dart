import 'package:app/app/models/payment_method.dart';
import 'package:app/app/services/firebase_service.dart';

class PaymentMethodRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<PaymentMethod>> getActivePaymentMethods() async {
    final collection = await _firebaseService.getCollection('paymentMethods');

    List<PaymentMethod> paymentMethods = [];

    if (collection != null) {
      for (var doc in collection.docs) {
        paymentMethods.add(PaymentMethod.fromFireStore(doc));
      }
    }

    return paymentMethods;
  }
}
