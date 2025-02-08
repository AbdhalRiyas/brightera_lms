import 'package:cloud_firestore/cloud_firestore.dart';

class Appbanner {
  final String id;
  final String imagePath;
  final String? link;
  final bool isHidden;
  final int order;

  const Appbanner({
    required this.id,
    required this.imagePath,
    required this.link,
    required this.isHidden,
    required this.order,
  });

  // fromFirestore method
  factory Appbanner.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return Appbanner(
      id: doc.id,
      imagePath: data?['image_path'] ?? '',
      link: data?['link'],
      isHidden: data?['is_hidden'],
      order: data?['order'] ?? 1,
    );
  }

  // toFirestore method
  Map<String, dynamic> toFirestore() {
    return {
      'image_path': imagePath,
      'link': link,
      'is_hidden': isHidden,
      'order': order,
    };
  }

  // copyWith method
  Appbanner copyWith({
    String? id,
    String? imagePath,
    String? link,
    bool? isHidden,
    int? order,
  }) {
    return Appbanner(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      link: link ?? this.link,
      isHidden: isHidden ?? this.isHidden,
      order: order ?? this.order,
    );
  }
}
