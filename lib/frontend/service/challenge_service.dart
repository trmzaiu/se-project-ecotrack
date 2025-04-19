import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChallengeService {
  final _firestore = FirebaseFirestore.instance;

  ChallengeService();

  // --- Daily Challenges ---
  /// Load the daily challenge for today
  Future<Map<String, dynamic>> loadDailyChallenge() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1)));

    // Step 1: Check if any challenge has dateLog == today
    final loggedTodayQuery = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'daily')
        .where('dateLog', isEqualTo: today)
        .get();

    if (loggedTodayQuery.docs.isNotEmpty) {
      print('Found daily challenge for today');
      return loggedTodayQuery.docs.first.data();
    }

    // Step 2: Check if any challenge has dateLog == yesterday (to avoid repeating yesterday's challenge)
    final loggedYesterdayQuery = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'daily')
        .where('dateLog', isEqualTo: yesterday)
        .get();

    final usedYesterdayChallengeIds = loggedYesterdayQuery.docs.map((doc) => doc.id).toList();

    // Step 3: Pick a random daily challenge that's not used today or yesterday
    final querySnap = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'daily')
        .get();

    final unusedChallenges = querySnap.docs
        .where((doc) => doc.data()['dateLog'] != today && !usedYesterdayChallengeIds.contains(doc.id))
        .toList();

    if (unusedChallenges.isEmpty) {
      throw Exception('No unused daily challenges available.');
    }

    final randomIndex = Random().nextInt(unusedChallenges.length);
    final selectedDoc = unusedChallenges[randomIndex];
    final selectedId = selectedDoc.id;

    // Step 4: Update dateLog field for today's challenge
    await _firestore.collection('challenges').doc(selectedId).update({
      'dateLog': today,
    });

    print('Selected challenge ID: $selectedId');

    return selectedDoc.data();
  }

  /// Check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.toUtc().year == date2.toUtc().year &&
        date1.toUtc().month == date2.toUtc().month &&
        date1.toUtc().day == date2.toUtc().day;
  }

  /// Check if the user has completed the daily challenge today
  Stream<bool> hasCompletedToday(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((docSnap) {
      final data = docSnap.data();
      final timestamp = data?['completedDate'] as Timestamp?;

      if (timestamp == null) return false;

      final completedDate = timestamp.toDate();
      final today = DateTime.now();

      return isSameDay(completedDate, today);
    });
  }

  /// Complete the daily challenge and update streak
  Future<void> completeChallenge(String userId) async {
    final today = DateTime.now();

    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      final timestamp = userDoc.data()?['completedDate'];

      if (timestamp == null || isSameDay(today, (timestamp as Timestamp).toDate())) return;

      await userRef.update({
        'completedDate': Timestamp.fromDate(today),
        'streak': FieldValue.increment(1),
      });

    } catch (e) {
      print("Error completing daily challenge: $e");
    }
  }

  /// Checks if the user missed completing the daily challenge yesterday
  Future<void> checkMissedDay(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      final timestamp = userDoc.data()?['completedDate'];
      final lastCompletedDate = timestamp != null ? (timestamp as Timestamp).toDate() : null;

      if (lastCompletedDate == null) return;

      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));

      final missedYesterday = !isSameDay(lastCompletedDate, yesterday) &&
          !isSameDay(lastCompletedDate, today);

      if (missedYesterday) {
        await userRef.update({'streak': 0});
      }
    } catch (e) {
      print("Error checking streak reset: $e");
    }
  }

  // --- Community Challenges ---
  /// Load all challenges by type
  Stream<QuerySnapshot> loadChallenges(String type) {
    return _firestore
        .collection('challenges')
        .where('type', isEqualTo: type)
        .snapshots();
  }

  /// Add the user to a specific challenge
  Future<void> joinChallenge(String challengeId, String userId) async {
    final ref = _firestore.collection('challenges').doc(challengeId);
    await ref.update({
      'participants': FieldValue.arrayUnion([userId])
    });
  }

  /// Check if the user has already joined the challenge
  Stream<bool> isUserJoined(String challengeId, String userId) {
    return _firestore
        .collection('challenges')
        .doc(challengeId)
        .snapshots()
        .map((doc) {
      final participants = List<String>.from(doc.data()?['participants'] ?? []);
      return participants.contains(userId);
    });
  }

  /// Check if a challenge has expired based on its end date
  bool isChallengeExpired(Timestamp endTimestamp) {
    final now = DateTime.now();
    final endDate = endTimestamp.toDate();
    return now.isAfter(endDate);
  }

  /// Check if the challenge deadline has passed
  Future<bool> checkChallengeDeadline(String challengeId) async {
    final doc = await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challengeId)
        .get();

    if (!doc.exists) return true;

    final endTimestamp = doc.data()?['endDate'] as Timestamp?;
    if (endTimestamp == null) return true;

    final now = DateTime.now();
    final endDate = endTimestamp.toDate();

    return now.isAfter(endDate);
  }

  /// Submit the user's form for a challenge
  Future<void> submitChallenge(String challengeId, String userId) async {
    await FirebaseFirestore.instance.collection('challengeSubmissions').add({
      'userId': userId,
      'challengeId': challengeId,
      'submittedDate': Timestamp.now(),
    });
  }

  /// Check if the user has submitted the challenge for today
  Stream<bool> checkSubmissionToday(String challengeId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    return FirebaseFirestore.instance
        .collection('challengeSubmissions')
        .where('userId', isEqualTo: userId)
        .where('challengeId', isEqualTo: challengeId)
        .where('submittedDate', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .where('submittedDate', isLessThan: Timestamp.fromDate(todayEnd))
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Update the progress of a challenge
  Future<void> updateChallengeProgress(String challengeId) async {
    await _firestore.collection('challenges')
        .doc(challengeId)
        .update({'progress': FieldValue.increment(1)});
  }
}
