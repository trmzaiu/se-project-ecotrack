import 'package:cloud_firestore/cloud_firestore.dart';

class Evidence {
  final String userId;
  final String evidenceId;
  final String? category;
  final List<String> imagesUrl;
  final String? description;
  final DateTime? date;
  final String status;

  Evidence({
    required this.userId,
    required this.evidenceId,
    this.category,
    required this.imagesUrl,
    this.description,
    this.date,
    required this.status,
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
      'date': date != null ? Timestamp.fromDate(date!) : null,
      'status': status,
    };
  }
}