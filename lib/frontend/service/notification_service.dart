import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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

  Stream<List<Map<String, dynamic>>> fetchNotifications(String userId) {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots() // ✅ Converts to real-time updates
        .map((snapshot) {
      // Group notifications by date
      Map<String, List<Map<String, dynamic>>> groupedNotifications = {};

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();

        // Convert Firestore Timestamp or ensure valid parsing
        DateTime dateTime;
        if (data['time'] is Timestamp) {
          dateTime = (data['time'] as Timestamp).toDate();
        } else {
          dateTime = DateTime.parse(data['time']);
        }

        // Format the date ("yyyy-MM-dd")
        String date = DateFormat('yyyy-MM-dd').format(dateTime);

        if (!groupedNotifications.containsKey(date)) {
          groupedNotifications[date] = [];
        }

        // Format the time ("HH:mm")
        String formattedTime = DateFormat("HH:mm").format(dateTime);
        groupedNotifications[date]!.add({
          "type": data['status'],
          "time": formattedTime,
          "points": data['point'],
          "isRead": data['isRead'],
          "notificationId": doc.id
        });
      }

      // Convert grouped data into a list
      List<Map<String, dynamic>> notifications = [];
      groupedNotifications.forEach((date, items) {
        notifications.add({
          "date": date,
          "items": items
        });
      });

      // Sort notifications by date descending
      notifications.sort((a, b) => b['date'].compareTo(a['date']));
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

  Future<void> deleteAllNotifications(String userId) async {
    try {
      // Reference to 'notifications' collection in Firestore
      CollectionReference notificationsRef = FirebaseFirestore.instance.collection('notifications');

      // Fetch all notifications for the current user
      QuerySnapshot snapshot = await notificationsRef.where('userId', isEqualTo: userId).get();

      if (snapshot.docs.isEmpty) {
        print("✅ No notifications found for user: $userId");
        return;
      }

      // Batch delete to improve performance
      WriteBatch batch = FirebaseFirestore.instance.batch();
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      // Execute batch deletion
      await batch.commit();
      print("✅ Successfully deleted all notifications for user: $userId");

    } catch (e) {
      print("❌ Error deleting notifications: $e");
    }
  }





}
