import 'package:cloud_firestore/cloud_firestore.dart';

class Evidence {
  final String userId;
  final String evidenceId;
  final String category;
  final List<String> url;
  final String? description;
  final DateTime? date;

  Evidence({
    required this.userId,
    required this.evidenceId,
    required this.category,
    required this.url,
    this.description,
    this.date,
  });

  // Convert User object to a Map for Firestore
  // Use to store date to Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'evidenceId': evidenceId,
      'category': category,
      'url': url,
      'description': description,
      'date': date != null ? Timestamp.fromDate(date!) : null,
    };
  }
}