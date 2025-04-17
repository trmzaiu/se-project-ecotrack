

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wastesortapp/database/model/evidence.dart';

import '../../database/model/notification.dart';

class NotificationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createNotification({
    required String status,
    required int point,
    bool isRead = false,
  }) async {
    { // Generate a unique notification ID using Firestore
      if(status == 'water'){
        point = 0;
      }
      String notificationId = _db
          .collection('notifications')
          .doc()
          .id;
      DateTime currentTime = DateTime.now();

      // Create a Notification model instance
      Notification notification = Notification(
        notificationId: notificationId,
        userId: _auth.currentUser!.uid,
        time: currentTime,
        status: status,
        isRead: isRead,
        point : point,
      );
      await _db.collection('notifications').doc(notificationId).set(notification.toMap());

      // Save the notification to Firestore

    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications(String userId) async {
    List<Map<String, dynamic>> notifications = [];

    // Fetch notifications for the given user and order by time descending
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .get();

    Map<String, List<Map<String, dynamic>>> groupedNotifications = {};

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      DateTime dateTime = DateTime.parse(data['time']);
      String date = "${dateTime.year}-${dateTime.month}-${dateTime.day}";

      if (!groupedNotifications.containsKey(date)) {
        groupedNotifications[date] = [];
      }

      groupedNotifications[date]!.add({
        "type": data['status'],
        "time": "${dateTime.hour}:${dateTime.minute}",
        "isRead": data['isRead'],
        "points": data['point']
      });
    }

    groupedNotifications.forEach((date, items) {
      notifications.add({
        "date": date,
        "items": items
      });
    });

    return notifications;
  }


  Stream<int> countUnreadNotifications() {
    // Get the current user's ID.
    String? userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value(0); // If no user is logged in, return a default stream with 0.
    }

    // Listen to changes in the notifications collection where isRead == false.
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length); // Map the snapshot to return the count.
  }


  Future<void> markAllNotificationsAsRead() async {
    try {
      // Get the current user's ID.
      String? userId = _auth.currentUser?.uid;
      if (userId == null) return;

      // Query for unread notifications for the current user.
      QuerySnapshot snapshot = await _db
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .get();

      // Create a batch update to mark all fetched notifications as read.
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

}




