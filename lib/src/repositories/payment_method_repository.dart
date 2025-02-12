import 'package:app/src/models/payment_method.dart';
import 'package:app/src/services/firebase_service.dart';

class PaymentMethodRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<PaymentMethod>> getActivePaymentMethods() async {
    final collection = await _firebaseService.getCollection(
      collection: 'paymentMethods',
      fromFirestore: PaymentMethod.fromFireStore,
      comparisonField: 'is_active',
      comparisonValue: true,
    );

    return collection;
  }
}
