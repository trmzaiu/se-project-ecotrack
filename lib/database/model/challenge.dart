import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final String type;
  final int goal;
  final int progress;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> participants;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.goal,
    required this.progress,
    required this.startDate,
    required this.endDate,
    required this.participants,
  });

  // 🔄 From Firestore (JSON → Object)
  factory Challenge.fromMap(String id, Map<String, dynamic> map) {
    return Challenge(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'daily',
      goal: map['goal'] ?? 0,
      progress: map['progress'] ?? 0,
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      participants: List<String>.from(map['participants'] ?? []),
    );
  }

  // 🔄 To Firestore (Object → JSON)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'goal': goal,
      'progress': progress,
      'startDate': startDate,
      'endDate': endDate,
      'participants': participants,
    };
  }
}
