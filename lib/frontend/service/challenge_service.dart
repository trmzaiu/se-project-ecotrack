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
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));

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

    // Step 2: Check if any challenge has dateLog == yesterday (avoid repeat)
    final loggedYesterdayQuery = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'daily')
        .where('dateLog', isEqualTo: yesterday)
        .get();

    final usedYesterdayChallengeIds = loggedYesterdayQuery.docs.map((doc) => doc.id).toList();

    // Step 3: Get unused challenges
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

    // Step 4: Update dateLog to today (UTC+7)
    await _firestore.collection('challenges').doc(selectedId).update({
      'dateLog': today,
    });

    print('Selected challenge ID: $selectedId');

    return selectedDoc.data();
  }

  /// Check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    final d1 = date1.toUtc().add(const Duration(hours: 7));
    final d2 = date2.toUtc().add(const Duration(hours: 7));
    return d1.year == d2.year &&
        d1.month == d2.month &&
        d1.day == d2.day;
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
      final today = DateTime.now().toUtc().add(const Duration(hours: 7));

      return isSameDay(completedDate, today);
    });
  }

  /// Complete the daily challenge and update streak
  Future<void> completeChallenge(String userId) async {
    final today = DateTime.now().toUtc().add(const Duration(hours: 7));

    try {
      final userRef = _firestore.collection('users').doc(userId);

      await userRef.update({
        'completedDate': Timestamp.fromDate(today),
        'streak': FieldValue.increment(1),
      });

      await updateStreakChallengeProgress();

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
        await updateStreakChallengeProgress();
        return;
      }

      final today = DateTime.now().toUtc().add(const Duration(hours: 7));
      final yesterday = today.subtract(Duration(days: 1));

      final missedYesterday = !isSameDay(lastCompletedDate, yesterday) &&
                                    !isSameDay(lastCompletedDate, today);

      if (missedYesterday) {
        await userRef.update({'streak': 0});
        await updateStreakChallengeProgress();
      }
    } catch (e) {
      print("Error checking streak reset: $e");
    }
  }

  // --- Community Challenges ---
  /// Load all challenges by type
  Future<List<QueryDocumentSnapshot>> loadChallenges(String type) async {
    // Fetch the challenges based on the type
    final snapshot = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: type)
        .get();

    final docs = snapshot.docs;

    // Sort the challenges based on the start date in descending order
    docs.sort((a, b) {
      final aDate = (a['startDate'] as Timestamp).toDate();
      final bDate = (b['startDate'] as Timestamp).toDate();
      return bDate.compareTo(aDate);
    });

    return docs;
  }

  /// Load all challenges user joined
  Future<List<QueryDocumentSnapshot>> loadChallengesUserJoined(String userId) async {
    // Fetch challenges where the user is a participant and the type is "community"
    final snapshot = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'community')
        .where('participants', arrayContains: userId)
        .get();

    final docs = snapshot.docs;

    // Filter out ongoing challenges using Future.wait to handle asynchronous isOngoingChallenge calls
    final ongoingChallenges = await Future.wait(docs.map((doc) async {
      final challengeId = doc.id;
      final isOngoing = await isOngoingChallenge(challengeId);
      return isOngoing ? doc : null;
    }));

    // Remove null values from the list of ongoing challenges
    final filteredChallenges = ongoingChallenges.whereType<QueryDocumentSnapshot>().toList();

    // Sort challenges by start date in descending order
    filteredChallenges.sort((a, b) {
      final aDate = (a['startDate'] as Timestamp).toDate();
      final bDate = (b['startDate'] as Timestamp).toDate();
      return bDate.compareTo(aDate);
    });

    return filteredChallenges;
  }

  /// Load active challenges
  Future<List<QueryDocumentSnapshot>> loadChallengesActive() async {
    // Fetch challenges where the user is a participant and the type is "community"
    final snapshot = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'community')
        .get();

    final docs = snapshot.docs;

    // Filter out ongoing challenges using Future.wait to handle asynchronous isOngoingChallenge calls
    final ongoingChallenges = await Future.wait(docs.map((doc) async {
      final challengeId = doc.id;
      final isOngoing = await isOngoingChallenge(challengeId);
      return isOngoing ? doc : null;
    }));

    // Remove null values from the list of ongoing challenges
    final filteredChallenges = ongoingChallenges.whereType<QueryDocumentSnapshot>().toList();

    // Sort challenges by start date in descending order
    filteredChallenges.sort((a, b) {
      final aDate = (a['startDate'] as Timestamp).toDate();
      final bDate = (b['startDate'] as Timestamp).toDate();
      return bDate.compareTo(aDate);
    });

    return filteredChallenges;
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
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
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

    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final endDate = endTimestamp.toDate();

    return now.isAfter(endDate);
  }

  /// Check if the challenge start
  Future<bool> isOngoingChallenge(String challengeId) async {
    final doc = await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challengeId)
        .get();

    if (!doc.exists) return false;

    final startTimestamp = doc.data()?['startDate'] as Timestamp?;
    final endTimestamp = doc.data()?['endDate'] as Timestamp?;

    if (startTimestamp == null || endTimestamp == null) return false;

    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final startDate = startTimestamp.toDate();
    final endDate = endTimestamp.toDate();

    return now.isAfter(startDate) &&
        (now.isBefore(endDate) || now.isAtSameMomentAs(endDate));
  }

  /// Submit the user's form for a challenge
  Future<void> submitChallenge(String challengeId, String userId) async {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now().toUtc().add(const Duration(hours: 7)));

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

    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now().toUtc().add(const Duration(hours: 7)));

    return FirebaseFirestore.instance
        .collection('challengeSubmissions')
        .where('userId', isEqualTo: userId)
        .where('challengeId', isEqualTo: challengeId)
        .where('submittedDate', isEqualTo: formattedDate)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  /// Update the progress of a challenge
  Future<void> updateChallengeProgress(String subtype, int value) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;

    try {
      final querySnapshot = await _firestore
          .collection('challenges')
          .where('type', isEqualTo: 'community')
          .where('subtype', isEqualTo: subtype)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No active streak challenges found.");
        return;
      }

      for (final challengeDoc in querySnapshot.docs) {
        final challengeId = challengeDoc.id;

        bool isUserJoined = await isUserJoinedFuture(challengeId, userId);
        bool isOngoing = await isOngoingChallenge(challengeId);

        if (!isUserJoined) {
          print("User has not joined challenge $challengeId.");
          continue;
        }

        if (!isOngoing) {
          print("Challenge $challengeId is not active at the moment.");
          continue;
        }

        await _firestore
            .collection('challenges')
            .doc(challengeId)
            .update({'progress': FieldValue.increment(value)});

        await submitChallenge(challengeId, userId);

        await ChallengeService().rewardChallengeContributors(challengeId);
      }
    } catch (e) {
      debugPrint("Failed to update challenge progress: $e");
    }
  }

  Future<void> updateFormChallengeProgress(String challengeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userId = user.uid;

    try {
      bool isUserJoined = await isUserJoinedFuture(challengeId, userId);
      bool isOngoing = await isOngoingChallenge(challengeId);

      if (!isUserJoined) {
        print("User has not joined challenge $challengeId.");
        return;
      }

      if (!isOngoing) {
        print("Challenge $challengeId is not active at the moment.");
        return;
      }

      await _firestore
          .collection('challenges')
          .doc(challengeId)
          .update({'progress': FieldValue.increment(1)});

      await submitChallenge(challengeId, userId);

      await ChallengeService().rewardChallengeContributors(challengeId);
    } catch (e) {
      debugPrint("Failed to update challenge progress: $e");
    }
  }

  Future<void> updateStreakChallengeProgress() async {
    try {
      final querySnapshot = await _firestore
          .collection('challenges')
          .where('type', isEqualTo: 'community')
          .where('subtype', isEqualTo: 'streak')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No active streak challenges found.");
        return;
      }

      for (final challengeDoc in querySnapshot.docs) {
        final challengeId = challengeDoc.id;
        final challengeData = challengeDoc.data();

        bool isExpired = await isOngoingChallenge(challengeId);

        if (isExpired) {
          print("Challenge $challengeId is not active at the moment.");
          continue;
        }

        final participants = List<String>.from(challengeData['participants'] ?? []);
        final condition = challengeData['condition'] ?? 0;

        List<Future<int>> streakChecks = participants.map((userId) async {
          final userDoc = await _firestore.collection('users').doc(userId).get();
          final streak = userDoc.data()?['streak'] ?? 0;
          return streak >= condition ? 1 : 0;
        }).toList();

        final results = await Future.wait(streakChecks);
        final qualifiedCount = results.fold(0, (sum, value) => sum + value);

        await _firestore.collection('challenges').doc(challengeId).update({
          'progress': qualifiedCount,
        });

        await ChallengeService().rewardChallengeContributors(challengeId);
      }
    } catch (e) {
      print("Error updating streak challenges progress: $e");
    }
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

    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
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
        await TreeService().increaseDrops(userId, rewardPoint);

        rewardedUsers.add(userId);
        print('Rewarded $rewardPoint points to user: $userId');
      }
    }

    // Update rewardedUsers list in challenge
    await challengeRef.update({'rewardedUsers': rewardedUsers});
  }
}
