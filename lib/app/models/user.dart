enum UserRole { student, instructor }

class User {
  final String id, name, mobileNumber;
  final UserRole userRole;

  User({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.userRole,
  });

  // Add methods for serialization and deserialization
}
