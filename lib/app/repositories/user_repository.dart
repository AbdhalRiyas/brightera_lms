import '../models/user.dart';
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

  Future<void> createUser(User user, String password) async {
    // Create a new user in Firebase
    await _firebaseService.createUser(user, password);
  }

  // Future<void> updateUser(User user) async {
  //   // Update an existing user in Firebase
  //   await _firebaseService.updateUser(user);
  // }

  Future<void> deleteUser(String id) async {
    // Delete a user from Firebase
    await _firebaseService.deleteUser(id);
  }
}
