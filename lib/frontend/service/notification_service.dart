import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../database/model/notification.dart';
import '../screen/user/notification_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  // Singleton pattern for shared instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sends a notification to a specific user and stores it in Firestore
  Future<void> sendNotificationToUser({
    String notificationId = '',
    required String receiverUserId,
    required String title,
    required String body,
    required String type,
  }) async {
    final userDoc = await _db.collection('users').doc(receiverUserId).get();
    final token = userDoc.data()?['fcmToken'];

    // Generate a new notification ID unless it's for an 'evidence' update
    if (type != 'evidence') {
      notificationId = _db.collection('notifications').doc().id;
    }

    if (token != null) {
      final notification = Notifications(
        notificationId: notificationId,
        userId: receiverUserId,
        title: title,
        body: body,
        type: type,
        isRead: false,
        time: DateTime.now(),
        token: token,
      );

      await _db
          .collection('notifications')
          .doc(notificationId)
          .set(notification.toMap());

      showNotification(title: title, body: body);
    }
  }

  /// Fetches real-time notifications for the current user
  Stream<List<Notifications>> fetchNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Notifications.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  /// Initializes the local notification system
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Navigate to notification page when clicked
        if (response.payload == 'notification-page') {
          navigatorKey.currentState?.pushNamed('/notification');
        }
      },
    );
  }

  /// Displays a local notification
  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'User Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: 'notification_payload',
    );
  }

  /// Requests notification permissions from the user
  static Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  /// Returns the number of unread notifications for the current user
  Stream<int> countUnreadNotifications() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value(0);

    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }


  /// Marks all notifications as read for the current user
  Future<void> markAllNotificationsAsRead() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _db.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }


  /// Marks a specific notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    await _db
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  /// Deletes all notifications for the current user
  Future<bool> deleteAllNotifications() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final snapshot = await _db
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .get();

      final batch = _db.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      print("Notification Error: $e");
      return false;
    }
  }
}
