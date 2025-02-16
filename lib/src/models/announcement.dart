import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String shortDescription;
  final String description;
  String? imageUrl;
  final DateTime createdAt;

  Announcement({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.description,
    this.imageUrl,
    required this.createdAt,
  });

  // fromFirestore
  factory Announcement.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Announcement(
      id: doc.id,
      title: data?['title'],
      shortDescription: data?['shortDescription'],
      description: data?['description'],
      imageUrl: data?['imageUrl'] ?? '',
      createdAt: data?['createdAt'].toDate(),
    );
  }

  // toFirestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'shortDescription': shortDescription,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
