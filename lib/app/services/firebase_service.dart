import 'package:app/app/models/cours.dart';
import 'package:app/app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Banners Collection Begin ====================== **
  Future<QuerySnapshot<Map<String, dynamic>>?> getAllBanners(
      {bool activeOnly = false}) async {
    Query<Map<String, dynamic>> query = _firestore.collection('banners');

    if (activeOnly) {
      query = query.where('is_hidden', isEqualTo: false);
    }

    query = query.orderBy('order', descending: false);

    return await query.get();
  }
  // Banners Collection End ========================= **

  Future<QuerySnapshot<Map<String, dynamic>>?> getAllSubjects() async {
    final snapshot = await _firestore.collection('subjects').get();
    return snapshot;
  }

  Future<Map<String, dynamic>?> getUserData(String id) async {
    // Fetch user data from Firebase Firestore
    final snapshot = await _firestore.collection('users').doc(id).get();
    return snapshot.data();
  }

  Future<void> createUser(User user) async {
    // Create a new user in Firestore
    await _firestore.collection('users').doc(user.id).set({
      'id': user.id,
      'name': user.name,
      'email': user.email,
    });
  }

  Future<void> updateUser(User user) async {
    // Update an existing user in Firestore
    await _firestore.collection('users').doc(user.id).update({
      'name': user.name,
      'email': user.email,
    });
  }

  Future<void> deleteUser(String id) async {
    // Delete a user from Firestore
    await _firestore.collection('users').doc(id).delete();
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    // Fetch all courses from Firestore
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Map<String, dynamic>?> getCourseById(String id) async {
    // Fetch a specific course by ID from Firestore
    final snapshot = await _firestore.collection('courses').doc(id).get();
    return snapshot.data();
  }

  Future<void> createCourse(Course course) async {
    // Create a new course in Firestore
    await _firestore.collection('courses').doc(course.id).set({
      'id': course.id,
      'title': course.title,
      'description': course.description,
    });
  }

  Future<void> updateCourse(Course course) async {
    // Update an existing course in Firestore
    await _firestore.collection('courses').doc(course.id).update({
      'title': course.title,
      'description': course.description,
    });
  }

  Future<void> deleteCourse(String id) async {
    // Delete a course from Firestore
    await _firestore.collection('courses').doc(id).delete();
  }
}
