import 'package:app/app/models/course.dart';
import 'package:app/app/models/user.dart' as usermodal;
import 'package:app/app/services/auth_manager.dart';
import 'package:app/app/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  FirebaseService._privateConstructor();

  static final FirebaseService _instance =
      FirebaseService._privateConstructor();

  factory FirebaseService() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<Result<String>> signInWithCustomToken(
      String indexNumber, String password) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('customAuth');
      final response = await callable.call(<String, dynamic>{
        'indexNumber': indexNumber,
        'password': password,
      });

      final token = response.data['token'];

      // Sign in with the custom token
      await FirebaseAuth.instance.signInWithCustomToken(token);

      // After successful sign-in, retrieve and store user details
      final userDetails = await getCurrentUserDetails();
      AuthManager().setUserDetails(userDetails);

      return Result(data: 'Sign-in successful');
    } on FirebaseFunctionsException catch (e) {
      String errorMessage = '';
      if (e.code == 'resource-exhausted') {
        errorMessage = 'Too many requests. Please try again later.';
      } else if (e.code == 'unauthenticated') {
        errorMessage = 'Invalid index number or password.';
      } else {
        errorMessage = 'Error: ${e.message}';
      }

      return Result(error: errorMessage);
    } catch (e) {
      return Result(error: 'Unexpected error: $e');
    }
  }

  // Method to get the current user's details from Firestore
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    // Check if the user is signed in
    if (currentUser != null) {
      try {
        // Retrieve the user document from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser?.uid).get();

        if (userDoc.exists) {
          // Get the user data
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;

          // Remove the password field if it exists
          userData.remove('password');

          // Return the filtered user data
          return userData;
        } else {
          print('User document does not exist');
          return null;
        }
      } catch (e) {
        print('Error fetching user details: $e');
        return null;
      }
    } else {
      print('No user is currently signed in.');
      return null;
    }
  }

  Future<void> createUser(usermodal.User user, String plainPassword) async {
    try {
      final HttpsCallable callable = _functions.httpsCallable('createUser');
      final results = await callable.call(<String, dynamic>{
        'indexNumber': user.id,
        'plainPassword': plainPassword,
        'name': user.name,
        'mobileNumber':
            user.mobileNumber, // Assuming mobile number is stored as email
        'userRole': user.userRole.name,
      });

      print(results.data); // Handle success
    } catch (e) {
      print('Error creating user: $e');
      // Handle error
    }
  }

  Future<void> singOut() async {
    await _auth.signOut();
  }

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

  Future<QuerySnapshot<Map<String, dynamic>>?> getCoursesBySubject(
      String subjectId) async {
    try {
      // Create a reference to the specific subject document
      DocumentReference subjectRef =
          _firestore.collection('subjects').doc(subjectId);

      // Query the courses collection where the subject field matches the subject reference
      final coursesSnapshot = await _firestore
          .collection('courses')
          .where('subject', isEqualTo: subjectRef)
          .get();

      return coursesSnapshot;
    } catch (e) {
      // Handle any errors here
      print('Error fetching courses by subject: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserData(String id) async {
    // Fetch user data from Firebase Firestore
    final snapshot = await _firestore.collection('users').doc(id).get();
    return snapshot.data();
  }

  // Future<void> createUser(User user) async {
  //   // Create a new user in Firestore
  //   await _firestore.collection('users').doc(user.id).set({
  //     'id': user.id,
  //     'name': user.name,
  //     'email': user.email,
  //   });
  // }

  // Future<void> updateUser(User user) async {
  //   // Update an existing user in Firestore
  //   await _firestore.collection('users').doc(user.id).update({
  //     'name': user.name,
  //     'email': user.email,
  //   });
  // }

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
