import 'dart:io';

import 'package:app/src/models/course.dart';
import 'package:app/src/models/user.dart' as usermodal;
import 'package:app/src/services/auth_manager.dart';
import 'package:app/src/utils/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class FirebaseService {
  FirebaseService._privateConstructor();

  static final FirebaseService _instance =
      FirebaseService._privateConstructor();

  factory FirebaseService() {
    return _instance;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference _firebaseStorageRef = FirebaseStorage.instance.ref();
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Request a new OTP for the given phone number
  Future<Result<String>> requestOtp(String phoneNumber) async {
    try {
      String deviceId = await MobileDeviceIdentifier().getDeviceId() ?? '';
      final HttpsCallable callable = _functions
          .httpsCallable('requestOtp'); // Replace with your Cloud Function name
      await callable.call(<String, dynamic>{
        'phoneNumber': phoneNumber,
        'deviceId': deviceId,
      });

      return Result(data: 'OTP sent successfully');
    } on FirebaseFunctionsException catch (e) {
      String errorMessage = _handleFirebaseError(e);
      return Result(error: errorMessage);
    } catch (e) {
      return Result(error: 'Unexpected error: $e');
    }
  }

  /// Validate the OTP provided by the user
  Future<Result<String>> validateOtp(String phoneNumber, String otp) async {
    try {
      String deviceId = await MobileDeviceIdentifier().getDeviceId() ?? '';
      final HttpsCallable callable = _functions
          .httpsCallable('verifyOtp'); // Replace with your Cloud Function name
      final response = await callable.call(<String, dynamic>{
        'phoneNumber': phoneNumber,
        'otp': otp,
        'deviceId': deviceId,
      });

      // If OTP verification is successful, sign in the user
      final token = response.data['token'];
      // Sign in with the custom token
      await FirebaseAuth.instance.signInWithCustomToken(token);

      // After successful sign-in, retrieve and store user details
      final userDetails = await getCurrentUserDetails();
      AuthManager().setUserDetails(userDetails);

      return Result(data: 'Sign-in successful');
    } on FirebaseFunctionsException catch (e) {
      // String errorMessage = _handleFirebaseError(e);
      return Result(error: e.message);
    } catch (e) {
      return Result(error: 'Unexpected error: $e');
    }
  }

  String _handleFirebaseError(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'resource-exhausted':
        return 'Too many requests. Please try again later.';
      case 'invalid-argument':
        return 'Invalid argument provided.';
      case 'not-found':
        return 'Requested resource not found.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      case 'unauthenticated':
        return 'Authentication failed. Please check your credentials.';
      default:
        return 'Error: ${e.message}';
    }
  }

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
          debugPrint('User document does not exist');
          return null;
        }
      } catch (e) {
        debugPrint('Error fetching user details: $e');
        return null;
      }
    } else {
      debugPrint('No user is currently signed in.');
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

      debugPrint(results.data); // Handle success
    } catch (e) {
      debugPrint('Error creating user: $e');
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

  Stream<List<T>> getCollectionStream<T>({
    required String collection,
    required T Function(DocumentSnapshot<Map<String, dynamic>>) fromFirestore,
    String? comparisonField,
    String? comparisonValue,
    String? referenceCollection,
    String? referenceId,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    if (comparisonField != null) {
      if (referenceCollection != null && referenceId != null) {
        DocumentReference? docRef =
            _firestore.collection(referenceCollection).doc(referenceId);

        query = query.where(comparisonField, isEqualTo: docRef);
      } else {
        query = query.where(comparisonField, isEqualTo: comparisonValue);
      }
    }

    return query.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => fromFirestore(doc)).toList());
  }

  Future<List<T>> getCollection<T>({
    required String collection,
    required T Function(DocumentSnapshot<Map<String, dynamic>>) fromFirestore,
    String? comparisonField,
    String? comparisonValue,
    String? referenceCollection,
    String? referenceId,
  }) async {
    Query<Map<String, dynamic>> query = _firestore.collection(collection);

    if (comparisonField != null) {
      if (referenceCollection != null && referenceId != null) {
        DocumentReference? docRef =
            _firestore.collection(referenceCollection).doc(referenceId);

        query = query.where(comparisonField, isEqualTo: docRef);
      } else {
        query = query.where(comparisonField, isEqualTo: comparisonValue);
      }
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => fromFirestore(doc)).toList();
  }

  //get Document Stream
  Stream<T> getDocumentStream<T>({
    required String collection,
    required String documentId,
    required T Function(DocumentSnapshot<Map<String, dynamic>>) fromFirestore,
  }) {
    return _firestore
        .collection(collection)
        .doc(documentId)
        .snapshots()
        .map((snapshot) => fromFirestore(snapshot));
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getCoursesBySubject(
      String subjectId,
      [bool isFeatured = false]) async {
    try {
      // Create a reference to the specific subject document
      DocumentReference subjectRef =
          _firestore.collection('subjects').doc(subjectId);

      // Query the courses collection where the subject field matches the subject reference
      Query<Map<String, dynamic>> query = _firestore
          .collection('courses')
          .where('subject', isEqualTo: subjectRef);

      if (isFeatured) {
        query = query.where('isFeatured', isEqualTo: true);
      }

      return await query.get();
    } catch (e) {
      // Handle any errors here
      debugPrint('Error fetching courses by subject: $e');
      return null;
    }
  }

  // search courses by title
  Future<QuerySnapshot<Map<String, dynamic>>?> searchCoursesByTitle(
      String title) async {
    try {
      // Query the courses collection where the title field matches the search term
      Query<Map<String, dynamic>> query = _firestore
          .collection('courses')
          .where('title', isGreaterThanOrEqualTo: title)
          .where('title', isLessThanOrEqualTo: '$title\uf8ff');

      return await query.get();
    } catch (e) {
      // Handle any errors here
      debugPrint('Error searching courses by title: $e');
      return null;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getSectionsForCourse(
      String courseId) async {
    try {
      // Reference to the specific course document
      DocumentReference courseRef =
          _firestore.collection('courses').doc(courseId);

      // Query the sections sub-collection for the course
      Query<Map<String, dynamic>> query =
          courseRef.collection('sections').orderBy('order');

      // Get the sections
      return await query.get();
    } catch (e) {
      // Handle any errors
      debugPrint('Error fetching sections for course: $e');
      return null;
    }
  }

  DocumentReference<Map<String, dynamic>> getDocumentReference(
      String collectionPath, String documentPath) {
    return _firestore.collection(collectionPath).doc(documentPath);
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getCourseEnrollment(
      String courseId) async {
    if (currentUser == null) {
      // User is not signed in
      return null;
    }

    try {
      // Reference to the specific course document (if needed for queries)
      DocumentReference courseRef =
          _firestore.collection('courses').doc(courseId);

      DocumentReference userRef =
          _firestore.collection('users').doc(currentUser!.uid);

      // Query the subscriptions collection
      QuerySnapshot<Map<String, dynamic>> subscriptionSnapshot =
          await _firestore
              .collection('enrollments')
              .where('userId',
                  isEqualTo: userRef) // Use the user's UID directly
              .where('courseId',
                  isEqualTo: courseRef) // Compare course ID as a string
              .where('endDate',
                  isGreaterThan:
                      Timestamp.now()) // Ensure subscription is active
              .where('status', isEqualTo: 'active')
              .limit(
                  1) // Limit to one result as we only need to check existence
              .get();

      // Return the query snapshot
      return subscriptionSnapshot;
    } catch (e) {
      // Handle any errors
      debugPrint('Error checking subscription for course: $e');
      return null;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> getLecturesForSection(
      String courseId, String sectionId) async {
    try {
      // Reference to the specific section document
      DocumentReference sectionRef = _firestore
          .collection('courses')
          .doc(courseId)
          .collection('sections')
          .doc(sectionId);

      // Query the lectures sub-collection for the section
      Query<Map<String, dynamic>> query =
          sectionRef.collection('lectures').orderBy('order');

      // Get the lectures
      return await query.get();
    } catch (e) {
      // Handle any errors
      debugPrint('Error fetching lectures for section: $e');
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

  Future<Result<String>> createDocument({
    required String collection,
    String? documentId,
    required Map<String, dynamic> data,
    List<Map<String, String>>?
        subCollectionPaths, // List of subcollections and their document IDs
  }) async {
    try {
      // Add the document to Firestore and get a reference to the added document
      DocumentReference docRef = documentId != null
          ? _firestore.collection(collection).doc(documentId)
          : await _firestore.collection(collection).add(data);

      if (documentId != null &&
          subCollectionPaths != null &&
          subCollectionPaths.isNotEmpty) {
        for (var path in subCollectionPaths) {
          String subCollection = path['subCollection']!;
          String subDocumentId = path['subDocumentId']!;

          docRef = docRef
              .collection(subCollection)
              .doc(subDocumentId.isEmpty ? null : subDocumentId);
        }
      }

      if (documentId != null) {
        await docRef.set(data);
      }

      // Return the document ID or any other info inside Result
      return Result(data: docRef.id);
    } on FirebaseException catch (e) {
      return Result(error: "Failed to add document: ${e.message}");
    } catch (e) {
      return Result(error: "An unexpected error occurred: $e");
    }
  }

  Future<Result<String>> updateDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
    List<Map<String, String>>?
        subCollectionPaths, // List of subcollections and their document IDs
  }) async {
    try {
      // Start with the main document reference
      DocumentReference documentRef =
          _firestore.collection(collection).doc(documentId);

      // If there are subcollections, navigate through them
      if (subCollectionPaths != null && subCollectionPaths.isNotEmpty) {
        for (var path in subCollectionPaths) {
          // Each entry in subCollectionPaths contains the subcollection and document ID
          String subCollection = path['subCollection']!;
          String subDocumentId = path['subDocumentId']!;

          // Navigate to the next level
          documentRef =
              documentRef.collection(subCollection).doc(subDocumentId);
        }
      }

      // Update the final document
      await documentRef.update(data);

      return Result(data: "Updated successfully!");
    } on FirebaseException catch (e) {
      return Result(error: "Failed to update: ${e.message}");
    } catch (e) {
      return Result(error: "An unexpected error occurred: $e");
    }
  }

  Future<Result<String>> deleteDocument(
      {required String collection,
      required String documentId,
      String? referenceCollection, // The collection to check for references
      String?
          referenceField, // The field in the reference collection that holds the DocumentReference
      List<Map<String, String>>? subCollectionPaths}) async {
    try {
      DocumentReference docRef =
          _firestore.collection(collection).doc(documentId);

      // Create the DocumentReference for the document we want to delete
      if (referenceCollection != null && referenceField != null) {
        DocumentReference docRef =
            _firestore.collection(collection).doc(documentId);

        // Check if the DocumentReference is used in the reference collection
        QuerySnapshot querySnapshot = await _firestore
            .collection(referenceCollection)
            .where(referenceField, isEqualTo: docRef)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // The document is being referenced in another collection, prevent deletion
          return Result(
              error:
                  "Cannot delete: Some $referenceCollection belongs to this $referenceField.");
        }
      }

      // If there are subcollections, navigate through them
      if (subCollectionPaths != null && subCollectionPaths.isNotEmpty) {
        for (var path in subCollectionPaths) {
          // Each entry in subCollectionPaths contains the subcollection and document ID
          String subCollection = path['subCollection']!;
          String subDocumentId = path['subDocumentId']!;

          // Navigate to the next level
          docRef = docRef.collection(subCollection).doc(subDocumentId);
        }
      }

      // If not referenced, delete the document from Firestore
      await docRef.delete();

      return Result(data: "Deleted successfully!");
    } on FirebaseException catch (e) {
      return Result(error: "Failed to delete: ${e.message}");
    } catch (e) {
      return Result(error: "An unexpected error occurred: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getCourses() async {
    // Fetch all courses from Firestore
    final snapshot = await _firestore.collection('courses').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
      String id, String collection) async {
    // Fetch a specific course by ID from Firestore
    final snapshot = await _firestore.collection(collection).doc(id).get();
    return snapshot;
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

  Future<Result> uploadFile(String fbStoragePath, String filePath) async {
    final fileRef = _firebaseStorageRef.child(fbStoragePath);

    File file = File(filePath);

    try {
      await fileRef.putFile(file);
      return Result(data: await fileRef.getDownloadURL());
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return Result(error: e.message);
    }
  }

  // check document exists
  Future<Result> isDocumentExists({
    required String collection,
    required String documentId,
  }) async {
    try {
      final docRef = _firestore.collection(collection).doc(documentId);
      final snapshot = await docRef.get();
      return Result(data: snapshot.exists);
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return Result(error: e.message);
    }
  }
}
