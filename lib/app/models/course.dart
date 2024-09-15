import 'package:app/app/models/section.dart';
import 'package:app/app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String id;
  final String title;
  final String image;
  final String previewVideo;
  final String description;
  final String language;
  final DocumentReference? subject;
  final DocumentReference? instructor;
  final num salePrice;
  final num regularPrice;
  final num? durationInHours;
  final List<Section>? sections;
  final User? instructorInfo;
  final bool isFeatured, isPublished;

  Course({
    required this.id,
    required this.title,
    required this.language,
    this.previewVideo = '',
    this.image = '',
    this.description = '',
    required this.subject,
    this.instructor,
    this.regularPrice = 0,
    this.durationInHours,
    required this.salePrice,
    this.sections,
    this.instructorInfo,
    required this.isFeatured,
    required this.isPublished,
  });

  factory Course.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc,
      [List<Section>? sections]) {
    return Course(
      id: doc.id,
      title: doc.data()?['title'] ?? '',
      language: doc.data()?['language'] ?? 'Tamil',
      image: doc.data()?['image'] ?? '',
      description: doc.data()?['description'] ?? '',
      subject: doc.data()?['subject'],
      salePrice: doc.data()?['salePrice'] ?? 0,
      regularPrice: doc.data()?['regularPrice'] ?? 0,
      durationInHours: doc.data()?['durationInHours'],
      sections: sections,
      previewVideo: doc.data()?['previewVideo'] ?? '',
      instructor: doc.data()?['instructor'] ?? '',
      isFeatured: doc.data()?['isFeatured'] ?? false,
      isPublished: doc.data()?['isPublished'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'language': language,
      'image': image,
      'description': description,
      'subject': subject,
      'salePrice': salePrice,
      'regularPrice': regularPrice,
      'durationInHours': durationInHours,
      'previewVideo': previewVideo,
      'instructor': instructor,
      'isFeatured': isFeatured,
      'isPublished': isPublished,
    };
  }

  Course copyWith({
    String? id,
    String? title,
    String? image,
    String? previewVideo,
    String? description,
    DocumentReference? subject,
    DocumentReference? instructor,
    num? salePrice,
    num? regularPrice,
    num? durationInHours,
    String? language,
    User? instructorInfo,
    bool? isFeatured,
    bool? isPublished,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      previewVideo: previewVideo ?? this.previewVideo,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      instructor: instructor ?? this.instructor,
      salePrice: salePrice ?? this.salePrice,
      regularPrice: regularPrice ?? this.regularPrice,
      durationInHours: durationInHours ?? this.durationInHours,
      sections: sections,
      language: language ?? this.language,
      instructorInfo: instructorInfo ?? this.instructorInfo,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}
