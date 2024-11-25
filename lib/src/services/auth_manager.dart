import 'package:app/src/services/firebase_service.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  Map<String, dynamic>? userDetails;

  void setUserDetails(Map<String, dynamic>? details) {
    userDetails = details;
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    if (FirebaseService().currentUser != null && userDetails == null) {
      final details = await FirebaseService().getCurrentUserDetails();
      setUserDetails(details);
    }
    return userDetails;
  }
}
