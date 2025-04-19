import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';

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

      await userRef.update({
        'completedDate': Timestamp.fromDate(today),
        'streak': FieldValue.increment(1),
      });

      await updateStreakChallengeProgress('UycmgdJDmMMaG4LEUrE9');

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

      if (lastCompletedDate == null) {
        await userRef.update({'streak': 0});
        await updateStreakChallengeProgress('UycmgdJDmMMaG4LEUrE9');
        return;
      }

      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));

      final missedYesterday = !isSameDay(lastCompletedDate, yesterday) &&
                                    !isSameDay(lastCompletedDate, today);

      if (missedYesterday) {
        await userRef.update({'streak': 0});
        await updateStreakChallengeProgress('UycmgdJDmMMaG4LEUrE9');
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

  Future<bool> isUserJoinedFuture(String challengeId, String userId) async {
    try {
      final doc = await _firestore.collection('challenges').doc(challengeId).get();
      if (!doc.exists) {
        return false;
      }

      final participants = List<String>.from(doc.data()?['participants'] ?? []);
      return participants.contains(userId);
    } catch (e) {
      print("Error checking user join status: $e");
      return false;
    }
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
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    await FirebaseFirestore.instance.collection('challengeSubmissions').add({
      'userId': userId,
      'challengeId': challengeId,
      'submittedDate': formattedDate,
    });
  }

  /// Check if the user has submitted the challenge for today
  Stream<bool> checkSubmissionToday(String challengeId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    return FirebaseFirestore.instance
        .collection('challengeSubmissions')
        .where('userId', isEqualTo: userId)
        .where('challengeId', isEqualTo: challengeId)
        .where('submittedDate', isEqualTo: formattedDate)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Update the progress of a challenge
  Future<void> updateChallengeProgress(String challengeId, int value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;

    try {
      bool isUserJoined = await isUserJoinedFuture(challengeId, userId);
      bool isExpired = await checkChallengeDeadline(challengeId);

      if (!isExpired && isUserJoined) {
        await _firestore
            .collection('challenges')
            .doc(challengeId)
            .update({'progress': FieldValue.increment(value)});

        await submitChallenge(challengeId, userId);
      }
      await ChallengeService().rewardChallengeContributors(challengeId);
    } catch (e) {
      debugPrint("Failed to update challenge progress: $e");
    }
  }

  Future<void> updateStreakChallengeProgress(String challengeId) async {
    final challengeRef = _firestore.collection('challenges').doc(challengeId);
    final challengeDoc = await challengeRef.get();

    if (!challengeDoc.exists) return;

    final participants = List<String>.from(challengeDoc.data()?['participants'] ?? []);

    List<Future<int>> streakChecks = participants.map((userId) async {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final streak = userDoc.data()?['streak'] ?? 0;
      return streak >= 7 ? 1 : 0;
    }).toList();

    final results = await Future.wait(streakChecks);
    final qualifiedCount = results.fold(0, (sum, value) => sum + value);

    await challengeRef.update({'progress': qualifiedCount});
    await ChallengeService().rewardChallengeContributors(challengeId);
    print('Updated progress to $qualifiedCount for challenge $challengeId');
  }

  Future<void> rewardChallengeContributors(String challengeId) async {
    final challengeRef = _firestore.collection('challenges').doc(challengeId);
    final challengeDoc = await challengeRef.get();

    if (!challengeDoc.exists) return;

    final data = challengeDoc.data()!;
    final int progress = data['progress'] ?? 0;
    final int target = data['target'] ?? 0;
    final Timestamp? endTimestamp = data['endDate'];
    final int rewardPoint = data['rewardPoints'] ?? 0;
    final List<String> participants = List<String>.from(data['participants'] ?? []);
    final List<String> rewardedUsers = List<String>.from(data['rewardedUsers'] ?? []);

    final now = DateTime.now();
    if (progress < target || (endTimestamp != null && now.isAfter(endTimestamp.toDate()))) {
      print("Challenge either not completed or expired.");
      return;
    }

    for (String userId in participants) {
      if (rewardedUsers.contains(userId)) continue;

      final hasContributed = await _firestore
          .collection('challengeSubmissions')
          .where('challengeId', isEqualTo: challengeId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (hasContributed.docs.isNotEmpty) {
        final userRef = _firestore.collection('users').doc(userId);

        await TreeService().increaseDrops(userId, rewardPoint);

        rewardedUsers.add(userId);
        print('Rewarded $rewardPoint points to user: $userId');
      }
    }

    // Update rewardedUsers list in challenge
    await challengeRef.update({'rewardedUsers': rewardedUsers});
  }
}
