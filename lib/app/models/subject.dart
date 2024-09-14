import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  final String id, name;
  final bool isActive;
  final String icon;

  const Subject(
      {required this.id,
      required this.name,
      required this.isActive,
      this.icon = ''});

  static Subject fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Subject(
      id: doc.id,
      isActive: data['isActive'] ?? false,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
    );
  }

  Map<String, dynamic> toFirestoreJson() => {
        'name': name,
        'icon': icon,
        'isActive': isActive,
      };

  Subject copyWith({
    String? name,
    bool? isActive,
    String? icon,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
    );
  }
}
