import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  final String id, name;
  final bool isActive, isHidden;
  final String icon;

  const Subject(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.isHidden,
      this.icon = ''});

  static Subject fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Subject(
      id: doc.id,
      isActive: data['isActive'] ?? false,
      isHidden: data['isHidden'] ?? false,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
    );
  }

  Map<String, dynamic> toFirestoreJson() => {
        'name': name,
        'icon': icon,
        'isActive': isActive,
        'isHidden': isHidden,
      };

  Subject copyWith({
    String? name,
    bool? isActive,
    bool? isHidden,
    String? icon,
  }) {
    return Subject(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}
