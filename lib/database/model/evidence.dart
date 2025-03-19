
import 'package:cloud_firestore/cloud_firestore.dart';

class Evidence {
  final String userId;
  final String evidenceId;
  final String category;
  final List<String> imagesUrl;
  final String? description;
  final DateTime date;
  final String status;
  final int point;

  Evidence({
    required this.userId,
    required this.evidenceId,
    required this.category,
    required this.imagesUrl,
    this.description,
    required this.date,
    required this.status,
    required this.point,
  });

  // Convert User object to a Map for Firestore
  // Use to store date to Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'evidenceId': evidenceId,
      'category': category,
      'imagesUrl': imagesUrl,
      'description': description,
      'date':  Timestamp.fromDate(date),
      'status': status,
      'point': point,
    };
  }

  factory Evidence.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Evidence(
      userId: data['userId'],
      evidenceId: doc.id,
      category: data['category'],
      imagesUrl: List<String>.from(data['imagesUrl']),
      description: data['description'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
      status: data['status'],
      point: data['point'],
    );
  }
}