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
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendNotificationToUser({
    String notificationId ='',
    required String receiverUserId,
    required String title,
    required String body,
    required String type,
  }) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUserId)
        .get();

    final token = userDoc.data()?['fcmToken'];

    if (type != 'evidence') {
      notificationId = _db.collection('notifications').doc().id;
    }

    if (token != null) {
      await _db.collection('notifications').doc(notificationId).set({
        'notificationId': notificationId,
        'title': title,
        'body': body,
        'type': type,
        'time': DateTime.now(),
        'userId': receiverUserId,
        'token': token,
        'isRead': false,
      });
    }

    showNotification(title: title, body: body);
  }

  Stream<List<Map<String, dynamic>>> fetchNotifications(String userId) {
    return _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      final rawList = snapshot.docs.map((doc) {
        final data = doc.data();
        data['notificationId'] = doc.id;
        return data;
      }).toList();

      return rawList;
    });
  }

  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (response) {
          if (response.payload == 'notification-page') {
            navigatorKey.currentState?.pushNamed('/notification');
          }
        });
  }

  static Future<void> showNotification({required String title, required String body}) async {
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

  static Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

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

  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({'isRead': true});
  }

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
