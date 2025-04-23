import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String notificationId;
  final String userId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime time;
  final String token;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.time,
    required this.token,
  });

  // Converts Notification object to Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'isRead': isRead,
      'time': Timestamp.fromDate(time),
      'token': token,
    };
  }

  // Converts Firestore document data to Notification object
  static Notification fromMap(Map<String, dynamic> data, String id) {
    return Notification(
      notificationId: id,
      userId: data['userId'],
      title: data['title'],
      body: data['body'],
      type: data['type'],
      isRead: data['isRead'],
      time: (data['time'] as Timestamp).toDate(),
      token: data['token'],
    );
  }
}
