class Notification {
  final String notificationId;
  final String userId;
  final DateTime time;
  final String status;
  final bool isRead;
  final int point;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.status,
    required this.isRead,
    required this.time,
    required this.point
  });
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'time': time.toIso8601String(),
      'status': status,
      'isRead': isRead,
      'point': point,
    };
  }

}