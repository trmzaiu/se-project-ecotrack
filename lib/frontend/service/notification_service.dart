import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wastesortapp/database/model/evidence.dart';
import '../../database/model/notification.dart'; // Your Notification model



class NotificationService {
  // Firestore related fields.
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  // Private named constructor.
  NotificationService._internal();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<void> createNotification({
    required String status,
    required int point,
    bool isRead = false,
  }) async {
    // If the status is 'water', reset points to 0.
    if (status == 'water') {
      point = 0;
    }
    // Generate a unique notification ID.
    String notificationId = _db.collection('notifications').doc().id;
    DateTime currentTime = DateTime.now();

    // Create your Notification model instance.
    Notification notification = Notification(
      notificationId: notificationId,
      userId: _auth.currentUser!.uid,
      time: currentTime,
      status: status,
      isRead: isRead,
      point: point,
    );

    // Save the notification to Firestore.
    await _db.collection('notifications').doc(notificationId).set(notification.toMap());
  }

  Stream<List<Map<String, dynamic>>> fetchNotificationsStream(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      // Group notifications by date.
      Map<String, List<Map<String, dynamic>>> groupedNotifications = {};

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // If 'time' is stored in Firestore as a Timestamp, use:
        DateTime dateTime;
        if (data['time'] is Timestamp) {
          dateTime = (data['time'] as Timestamp).toDate();
        } else {
          // Otherwise assume it's a string.
          dateTime = DateTime.parse(data['time']);
        }
        String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

        // Trigger local notification immediately for new/unread notifications.
        // (Be cautious: This may trigger multiple pop-ups if the stream updates repeatedly.)

        // Group notification by date.
        if (!groupedNotifications.containsKey(date)) {
          groupedNotifications[date] = [];
        }
        groupedNotifications[date]!.add({
          "type": data['status'],
          "time": "${dateTime.hour}:${dateTime.minute}",
          "isRead": data['isRead'],
          "points": data['point'],
        });
      }

      // Convert grouped data to a list.
      List<Map<String, dynamic>> notifications = [];
      groupedNotifications.forEach((date, items) {
        notifications.add({
          "date": date,
          "items": items,
        });
      });

      return notifications;
    });
  }


  Stream<int> countUnreadNotifications() {
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(0);
    }
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;

      QuerySnapshot snapshot = await _db
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      WriteBatch batch = _db.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      print("Error updating notifications: $e");
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _db.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });
      print("Notification $notificationId marked as read.");
    } catch (error) {
      print("Error marking notification $notificationId as read: $error");
    }
  }

  Stream<bool> deleteAllNotifications() async* {
    try {
      String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        yield false;
        return;
      }

      QuerySnapshot snapshot = await _db
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      WriteBatch batch = _db.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      yield true;
    } catch (e) {
      print("Error while deleting notifications: $e");
      yield false;
    }
  }



}
