class Notification {
  final String notificationId;
  final String userId;
  final String? description;
  final DateTime time;
  final String status;
  final bool isRead;

  Notification({
    required this.notificationId,
    required this.userId,
    this.description,
    required this.status,
    required this.isRead,
    required this.time
  });
}