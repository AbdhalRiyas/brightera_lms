import 'package:app/src/models/section.dart';
import 'package:app/src/models/subject.dart';
import 'package:app/src/models/user.dart';
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
  final Subject? subjectInfo;
  final User? instructorInfo;
  final bool isFeatured, isPublished;
  final int expiresInDays;
  final int totalStudent;

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
    this.subjectInfo,
    this.instructorInfo,
    required this.isFeatured,
    required this.isPublished,
    required this.expiresInDays,
    this.totalStudent = 0,
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
      expiresInDays: doc.data()?['expiresInDays'] ?? 0,
      totalStudent: doc.data()?['totalStudent'] ?? 0,
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
      'expiresInDays': expiresInDays,
      'totalStudent': totalStudent,
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
    Subject? subjectInfo,
    User? instructorInfo,
    bool? isFeatured,
    bool? isPublished,
    int? expiresInDays,
    int? totalStudent,
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
      subjectInfo: subjectInfo ?? this.subjectInfo,
      instructorInfo: instructorInfo ?? this.instructorInfo,
      isFeatured: isFeatured ?? this.isFeatured,
      isPublished: isPublished ?? this.isPublished,
      expiresInDays: expiresInDays ?? this.expiresInDays,
      totalStudent: totalStudent ?? this.totalStudent,
    );
  }

  factory Course.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw ArgumentError("Course data is null");
    }

    return Course(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      language: data['language'] ?? 'Tamil',
      image: data['image'] ?? '',
      description: data['description'] ?? '',
      subject: data['subject'],
      salePrice: data['salePrice'] ?? 0,
      regularPrice: data['regularPrice'] ?? 0,
      durationInHours: data['durationInHours'],
      sections: null, // Sections should be loaded separately if needed
      previewVideo: data['previewVideo'] ?? '',
      instructor: data['instructor'],
      isFeatured: data['isFeatured'] ?? false,
      isPublished: data['isPublished'] ?? false,
      expiresInDays: data['expiresInDays'] ?? 0,
      totalStudent: data['totalStudent'] ?? 0,
    );
  }
}
