import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { student, instructor, admin }

class User {
  final String id, name, mobileNumber;
  final UserRole userRole;
  String? fcmToken;

  User({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.userRole,
    this.fcmToken,
  });

  // Add methods for serialization and deserialization

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    UserRole getUserRole(String userRole) {
      switch (userRole) {
        case 'instructor':
          return UserRole.instructor;
        case 'admin':
          return UserRole.admin;
        default:
          return UserRole.student;
      }
    }

    return User(
      id: doc.id,
      name: doc.data()?['name'] ?? '',
      mobileNumber: doc.data()?['mobileNumber'] ?? '',
      userRole: getUserRole(doc.data()?['userRole']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'mobileNumber': mobileNumber,
      'userRole': userRole.toString().split('.').last,
      'fcmToken': fcmToken,
    };
  }

  User copyWith({
    String? name,
    String? mobileNumber,
    UserRole? userRole,
    String? fcmToken,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      userRole: userRole ?? this.userRole,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
