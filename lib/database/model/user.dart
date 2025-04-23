import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Users {
  final String userId;
  final String name;
  final String email;
  final DateTime? dob;
  final String photoUrl;
  final String country;
  final DateTime? completedDailyDate;
  final bool completedWeekly;
  final int streak;
  final String weekLog;
  final int weekProgress;
  final List<Map<String, dynamic>> weekTasks;
  final String fcmToken;

  Users({
    required this.userId,
    required this.name,
    required this.email,
    this.dob,
    this.photoUrl = "",
    this.country = "",
    this.completedDailyDate,
    this.completedWeekly = false,
    this.streak = 0,
    this.weekLog = "",
    this.weekProgress = 0,
    this.weekTasks = const [],
    this.fcmToken = "",
  });

  // Convert to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'dob': dob != null ? DateFormat('dd/MM/yyyy').format(dob!) : null,
      'photoUrl': photoUrl,
      'country': country,
      'completedDailyDate': completedDailyDate != null
          ? Timestamp.fromDate(completedDailyDate!)
          : null,
      'completedWeekly': completedWeekly,
      'streak': streak,
      'weekLog': weekLog,
      'weekProgress': weekProgress,
      'weekTasks': weekTasks,
      'fcmToken': fcmToken,
    };
  }

  // Create a User instance from Firestore data + document ID
  factory Users.fromMap(Map<String, dynamic> map, String documentId) {
    DateTime? completedDailyDate;
    if (map['completedDailyDate'] != null) {
      completedDailyDate = (map['completedDailyDate'] as Timestamp).toDate();
    }

    DateTime? dob;
    if (map['dob'] != null && map['dob'].toString().isNotEmpty) {
      try {
        dob = DateFormat('dd/MM/yyyy').parse(map['dob']);
      } catch (e) {
        dob = null;
      }
    }

    return Users(
      userId: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dob: dob,
      photoUrl: map['photoUrl'] ?? "",
      country: map['country'] ?? "",
      completedDailyDate: completedDailyDate,
      completedWeekly: map['completedWeekly'] ?? false,
      streak: map['streak'] ?? 0,
      weekLog: map['weekLog'] ?? "",
      weekProgress: map['weekProgress'] ?? 0,
      weekTasks: List<Map<String, dynamic>>.from(map['weekTasks'] ?? []),
      fcmToken: map['fcmToken'] ?? "",
    );
  }
}
