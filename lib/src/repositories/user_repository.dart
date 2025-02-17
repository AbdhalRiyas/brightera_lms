import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart' as usermodal;
import '../services/firebase_service.dart';

class UserRepository {
  final FirebaseService _firebaseService = FirebaseService();

  // Future<User?> getUserById(String id) async {
  //   // Fetch user data from Firebase
  //   final userData = await _firebaseService.getUserData(id);
  //   if (userData != null) {
  //     return User(
  //       id: userData['id'],
  //       name: userData['name'],
  //       email: userData['email'],
  //     );
  //   }
  //   return null;
  // }

  String get currentUserUid {
    return _firebaseService.currentUser!.uid;
  }

  DocumentReference<Map<String, dynamic>> getUserReference(
      String documentPath) {
    return _firebaseService.getDocumentReference('users', documentPath);
  }

  Future<Result<String>> login(String phoneNumber) async {
    // Create a new user in Firebase
    var result = await _firebaseService.requestOtp("94$phoneNumber");
    return result;
  }

  Future<Result<String>> verifyPhoneNumber(
      String phoneNumber, String otp) async {
    // Create a new user in Firebase
    var result = await _firebaseService.validateOtp(phoneNumber, otp);
    return result;
  }

  Future<void> createUser(usermodal.User user, String password) async {
    // Create a new user in Firebase
    await _firebaseService.createUser(user, password);
  }

  Future<Result> updateUserName(String name) async {
    // Update the user name in Firebase
    return await _firebaseService.updateUserName(name);
  }

  Future<void> deleteUser(String id) async {
    // Delete a user from Firebase
    await _firebaseService.deleteUser(id);
  }

  Future<void> saveFcmToken(String userId) async {
    await _firebaseService.saveTokenToFirestore(userId);
  }
}
