class Notification {
  final String notid;
  final String uid;
  final String? description;

  Notification({
    required this.notid,
    required this.uid,
    this.description
  });
}