import 'package:cloud_firestore/cloud_firestore.dart';

class Evidences {
  final String evidenceId;
  final String userId;
  final String category;
  final List<String> imagesUrl;
  final String? description;
  final DateTime date;
  final String status;
  final int point;

  Evidences({
    required this.evidenceId,
    required this.userId,
    required this.category,
    required this.imagesUrl,
    this.description,
    required this.date,
    required this.status,
    required this.point,
  });

  // Convert to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'category': category,
      'imagesUrl': imagesUrl,
      'description': description,
      'date': Timestamp.fromDate(date),
      'status': status,
      'point': point,
    };
  }

  // Create an Evidence instance from Firestore data + document ID
  factory Evidences.fromMap(Map<String, dynamic> map, String documentId) {
    return Evidences(
      evidenceId: documentId,
      userId: map['userId'] ?? '',
      category: map['category'] ?? '',
      imagesUrl: List<String>.from(map['imagesUrl'] ?? []),
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] ?? '',
      point: map['point'] ?? 0,
    );
  }
}
