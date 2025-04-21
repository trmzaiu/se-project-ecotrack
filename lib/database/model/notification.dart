import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String notificationId;
  final String userId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime time;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.time,
  });
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'isRead': isRead,
      'time': Timestamp.fromDate(time),
    };
  }

}