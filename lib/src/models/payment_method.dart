import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethod {
  final String id, name, description, icon;
  final List<dynamic> images;
  final bool isActive;
  final String type; // we support bank, payhere

  PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.images,
    required this.isActive,
    required this.type,
  });

  factory PaymentMethod.fromFireStore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    return PaymentMethod(
      id: doc.id,
      name: data?['name'] ?? '',
      description: data?['description'] ?? '',
      icon: data?['icon'] ?? '',
      images: data?['images'] ?? [],
      isActive: data?['is_active'] ?? false,
      type: data?['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "icon": icon,
        "images": images,
        "is_active": isActive,
        "type": type,
      };
}
