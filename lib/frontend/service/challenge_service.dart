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
  bool _isSameDay(DateTime date1, DateTime date2) {
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
      final timestamp = data?['completedDailyDate'] as Timestamp?;

      if (timestamp == null) return false;

      final completedDailyDate = timestamp.toDate();
      final today = DateTime.now().toUtc().add(const Duration(hours: 7));

      return _isSameDay(completedDailyDate, today);
    });
  }

  /// Update daily completion
  Future<void> _completeDailyChallenge(DocumentReference userRef, DateTime today) async {
    await userRef.update({
      'completedDailyDate': Timestamp.fromDate(today),
      'streak': FieldValue.increment(1),
    });
  }

  /// Complete the daily challenge and update streak
  Future<void> completeChallenge(String userId) async {
    final today = DateTime.now().toUtc().add(const Duration(hours: 7));

    try {
      final userRef = _firestore.collection('users').doc(userId);

      // Update daily completion
      await _completeDailyChallenge(userRef, today);

      // Updates the progress of challenge type streak
      await updateStreakChallengeProgress();

      // Check and update progressTask
      await updateWeeklyProgressForTasks(userId, 'daily');

    } catch (e) {
      print("Error completing daily challenge: $e");
    }
  }

  /// Checks if the user missed completing the daily challenge yesterday
  Future<void> checkMissedDay(String userId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userDoc = await userRef.get();

      final timestamp = userDoc.data()?['completedDailyDate'];
      final lastcompletedDailyDate = timestamp != null ? (timestamp as Timestamp).toDate() : null;

      if (lastcompletedDailyDate == null) {
        await userRef.update({'streak': 0});
        await updateStreakChallengeProgress();
        return;
      }

      final today = DateTime.now().toUtc().add(const Duration(hours: 7));
      final yesterday = today.subtract(Duration(days: 1));

      final missedYesterday = !_isSameDay(lastcompletedDailyDate, yesterday) &&
                                    !_isSameDay(lastcompletedDailyDate, today);

      if (missedYesterday) {
        await userRef.update({'streak': 0});
        await updateStreakChallengeProgress();
      }
    } catch (e) {
      print("Error checking streak reset: $e");
    }
  }

  // --- Weekly Challenges ---
  /// Load the weekly challenge for week
  Future<Map<String, dynamic>> loadWeeklyChallenge(String userId) async {
    final weekLog = getCurrentWeekLog();
    final userRef = _firestore.collection('users').doc(userId);

    // Step 1: Check if a weekly challenge already assigned this week
    final existingChallengeQuery = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'weekly')
        .where('weekLog', isEqualTo: weekLog)
        .get();

    if (existingChallengeQuery.docs.isNotEmpty) {
      print('✅ Found weekly challenge for this week');
      final selectedChallenge = existingChallengeQuery.docs.first.data();

      // Ensure user data is in sync
      await setupUserWeeklyChallenge(userRef, selectedChallenge, weekLog);

      return selectedChallenge;
    }

    // Step 2: Pick a random challenge from unassigned ones
    final allTemplatesQuery = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'weekly')
        .get();

    if (allTemplatesQuery.docs.isEmpty) {
      return {'error': 'No weekly challenge templates available'};
    }

    final randomDoc = allTemplatesQuery.docs[Random().nextInt(allTemplatesQuery.docs.length)];
    final selectedChallenge = randomDoc.data();

    // Step 3: Mark the selected challenge as assigned for this week
    await _firestore.collection('challenges').doc(randomDoc.id).update({
      'weekLog': weekLog,
    });

    print('🎯 Random weekly challenge assigned for week $weekLog');

    // Step 4: Setup user progress
    await setupUserWeeklyChallenge(userRef, selectedChallenge, weekLog);

    return selectedChallenge;
  }

  /// Setup user's weekly challenge progress if not already set
  Future<void> setupUserWeeklyChallenge(DocumentReference userRef, Map<String, dynamic> challenge, String weekLog) async {
    final userDoc = await userRef.get();
    final userData = userDoc.data() as Map<String, dynamic>?;

    // Only initialize if user's current weekLog is different
    if (userData == null || userData['weekLog'] != weekLog) {
      final challengeTasks = challenge['weekTasks'] as List<dynamic>? ?? [];

      // Create initial task progress list
      final userTasks = challengeTasks.map((task) => {
        'taskId': task['index'],
        'completed': false,
        'progressTask': 0,
        'subtype': task['subtype'] ?? ''
      }).toList();

      // Save progress to user document
      await userRef.set({
        'weekLog': weekLog,
        'tasks': userTasks,
        'weekProgress': 0,
        'completedWeekly': false
      }, SetOptions(merge: true));

      print('✅ Weekly challenge progress initialized for user');
    }
  }

  /// Generate a string key for the current year-week (e.g., 2025-16)
  String getCurrentWeekLog() {
    final now = DateTime.now().toUtc().add(Duration(hours: 7));
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final daysSinceFirstDay = now.difference(firstDayOfYear).inDays;

    // Calculate week number in year
    final weekNumber = ((daysSinceFirstDay + firstDayOfYear.weekday - 1) / 7).floor() + 1;

    return '${now.year}-$weekNumber';
  }

  /// Stream task status (progress & completion) for a specific task index
  Stream<Map<String, dynamic>> getTaskStatus(String userId, int taskIndex) {
    return _firestore.collection('users').doc(userId).snapshots().map((userDoc) {
      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      final List<dynamic> weekTasks = userDoc.data()?['weekTasks'] ?? [];

      // Return the task status if it exists
      if (taskIndex < weekTasks.length) {
        final taskData = weekTasks[taskIndex] as Map<String, dynamic>;

        final int progressTask = taskData['progressTask'] ?? 0;
        final bool isCompleted = taskData['completed'] ?? false;

        return {
          'progressTask': progressTask,
          'isCompleted': isCompleted,
        };
      }

      // Fallback if task not found
      return {
        'progressTask': 0,
        'isCompleted': false,
      };
    }).handleError((e) {
      print('Error fetching task status stream: $e');
      return {
        'progressTask': 0,
        'isCompleted': false,
      };
    });
  }

  /// Mark a weekly task as completed and update user's week progress
  Future<void> completeWeeklyTask(String userId, int taskIndex, int taskPoint) async {
    final userRef = _firestore.collection('users').doc(userId);
    final userDoc = await userRef.get();

    final List<dynamic> tasksData = userDoc['weekTasks'] ?? [];

    if (taskIndex >= tasksData.length) {
      print("⚠️ Task index $taskIndex is out of range");
      return;
    }

    final Map<String, dynamic> task = Map<String, dynamic>.from(tasksData[taskIndex]);

    if (task['completed'] == true) {
      print("✅ Task $taskIndex already completed");
      return;
    }

    // Mark task as completed
    task['completed'] = true;
    tasksData[taskIndex] = task;

    // Update total weekly progress
    final newWeekProgress = (userDoc['weekProgress'] ?? 0) + taskPoint;

    await userRef.update({
      'weekTasks': tasksData,
      'weekProgress': newWeekProgress,
    });

    print("✅ Task $taskIndex marked completed, +$taskPoint points");

    // Check if challenge completed
    bool isSame = await compareUserWeekProgressWithTarget(userId);
    if (isSame) {
      await setWeeklyChallengeCompleted(userId, true);
    }
  }

  /// Compare user's current weekly progress with the challenge target
  Future<bool> compareUserWeekProgressWithTarget(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data();

      if (userData == null) {
        throw Exception('User not found');
      }

      final String userWeekLog = userData['weekLog'];
      final int userProgress = userData['weekProgress'] ?? 0;

      // Get the weekly challenge assigned for current week
      final querySnapshot = await _firestore
          .collection('challenges')
          .where('type', isEqualTo: 'weekly')
          .where('weekLog', isEqualTo: userWeekLog)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No matching weekly challenge found');
      }

      final challengeData = querySnapshot.docs.first.data();
      final int target = challengeData['target'] ?? 0;

      return userProgress >= target;
    } catch (e) {
      print('Error comparing week progress with target: $e');
      return false;
    }
  }

  /// Stream whether the weekly challenge is completed by the user
  Stream<bool> isWeeklyChallengeCompleted(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      return data?['completedWeekly'] ?? false;
    });
  }

  /// Update user's completion status for the weekly challenge
  Future<void> setWeeklyChallengeCompleted(String userId, bool status) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'completedWeekly': status,
      });
    } catch (e) {
      print('Error updating completedWeekly: $e');
    }
  }

  /// Update task progress
  Future<void> updateWeeklyProgressForTasks(
      String userId,
      String taskSubtype, {
        String? category, // optional, required only for "evidence"
      }) async {
    final weekLog = getCurrentWeekLog();

    // Step 1: Query the weekly challenge for the given weekLog
    final weeklyQuery = await _firestore
        .collection('challenges')
        .where('type', isEqualTo: 'weekly')
        .where('weekLog', isEqualTo: weekLog)
        .get();

    if (weeklyQuery.docs.isNotEmpty) {
      final weeklyChallenge = weeklyQuery.docs.first.data();
      final List<dynamic> weekTasks = weeklyChallenge['tasks'] ?? [];

      // Step 2: Find all task indexes that match the given subtype (and category if subtype == evidence)
      final taskIndexes = _getTaskIndexesBySubtype(
        weekTasks,
        taskSubtype,
        category: category?.toLowerCase(),
      );

      if (taskIndexes.isNotEmpty) {
        final userRef = _firestore.collection('users').doc(userId);
        final userDoc = await userRef.get();
        final userData = userDoc.data();

        if (userData != null && userData['weekLog'] == weekLog) {
          final List<dynamic> userWeekTasks = userData['weekTasks'] ?? [];
          final int userStreak = userData['streak'] ?? 0;

          for (final taskIndex in taskIndexes) {
            if (taskIndex < userWeekTasks.length && taskIndex < weekTasks.length) {
              final Map<String, dynamic> userTask = Map<String, dynamic>.from(userWeekTasks[taskIndex]);
              final Map<String, dynamic> challengeTask = Map<String, dynamic>.from(weekTasks[taskIndex]);

              final int progress = userTask['progressTask'] ?? 0;
              final int target = challengeTask['targetValue'] ?? 1;

              // If the subtype is "streak", we need to check if the user's streak matches the dayStreak in the challenge
              if (taskSubtype == 'streak' && userStreak >= challengeTask['dayStreak']) {
                // Only update if progress is less than the target
                if (progress < target) {
                  userTask['progressTask'] = progress + 1;
                  userWeekTasks[taskIndex] = userTask;
                }
              } else if (taskSubtype != 'streak') {
                // For other subtypes, continue with the regular logic
                if (progress < target) {
                  userTask['progressTask'] = progress + 1;
                  userWeekTasks[taskIndex] = userTask;
                }
              }
            }
          }

          await userRef.update({
            'weekTasks': userWeekTasks,
          });

          print('📈 Updated progressTask for weekly tasks (subtype: $taskSubtype)');
        }
      }
    }
  }

  /// Get task index by  subtype
  List<int> _getTaskIndexesBySubtype(
      List<dynamic> tasks,
      String subtype, {
        String? category,
      }) {
    return tasks.asMap().entries
        .where((entry) {
      final task = entry.value as Map<String, dynamic>;
      final isMatchingSubtype = task['subtype'] == subtype;
      if (subtype == 'evidence') {
        final taskCategory = (task['category'] ?? '').toString();
        return isMatchingSubtype && category != null && taskCategory == category;
      }
      return isMatchingSubtype;
    })
        .map((entry) => entry.key)
        .toList();
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
    String formattedDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.now().toUtc().add(const Duration(hours: 7)));

    final challengeQuery = await _firestore
        .collection('challenges')
        .where('id', isEqualTo: challengeId)
        .get();

    if (challengeQuery.docs.isEmpty) {
      print("No challenge found.");
      return;
    }

    final challengeDoc = challengeQuery.docs.first;
    final challengeRef = challengeDoc.reference;
    final challengeData = challengeDoc.data();

    final List<dynamic> submittedList =
        (challengeData['formSubmittedUser'] as List<dynamic>?) ?? [];

    final alreadySubmitted = submittedList.any((entry) =>
    entry['userId'] == userId && entry['submittedDate'] == formattedDate);

    if (!alreadySubmitted) {
      submittedList.add({
        'userId': userId,
        'submittedDate': formattedDate,
      });

      await challengeRef.update({
        'formSubmittedUser': submittedList,
      });

      print("Submission saved.");
    } else {
      print("Already submitted today.");
    }
  }

  /// Check if the user has submitted the challenge for today
  Stream<bool> checkSubmissionToday(String challengeId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return Stream.value(false);

    String formattedDate = DateFormat('dd-MM-yyyy').format(
      DateTime.now().toUtc().add(const Duration(hours: 7)),
    );

    return _firestore.collection('challenges')
        .where('id', isEqualTo: challengeId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return false;
      final data = snapshot.docs.first.data();
      final formSubmittedList = data['formSubmittedUser'] as List<dynamic>? ?? [];
      return formSubmittedList.any((entry) =>
      entry['userId'] == userId && entry['submittedDate'] == formattedDate);
    });
  }

  /// Update the progress of challenge
  // Future<void> updateChallengeProgress(
  //     {required String subtype, int value = 1, String? challengeId}) async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user == null) return;
  //
  //   final userId = user.uid;
  //
  //   try {
  //     QuerySnapshot querySnapshot;
  //     if (challengeId != null) {
  //       // If challengeId is provided, query by challengeId
  //       querySnapshot = await _firestore
  //           .collection('challenges')
  //           .where('id', isEqualTo: challengeId)
  //           .get();
  //     } else {
  //       // If challengeId is not provided, query all challenges with the given subtype
  //       querySnapshot = await _firestore
  //           .collection('challenges')
  //           .where('type', isEqualTo: 'community')
  //           .where('subtype', isEqualTo: subtype)
  //           .get();
  //     }
  //
  //     if (querySnapshot.docs.isEmpty) {
  //       print("No active challenges found.");
  //       return;
  //     }
  //
  //     for (final challengeDoc in querySnapshot.docs) {
  //       final challengeId = challengeDoc.id;
  //       final challengeData = challengeDoc.data();
  //       bool isOngoing = await isOngoingChallenge(challengeId);
  //
  //       if (!isOngoing) {
  //         print("Challenge $challengeId is not active at the moment.");
  //         continue;
  //       }
  //
  //       bool isUserJoined = await isUserJoinedFuture(challengeId, userId);
  //       if (!isUserJoined) {
  //         print("User has not joined challenge $challengeId.");
  //         continue;
  //       }
  //
  //       final currentProgress = challengeData['progress'] ?? 0;
  //       final target = challengeData['targetValue'] ?? 0; // Assuming 'targetValue' stores the target
  //
  //       // Check if progress has reached the target
  //       if (currentProgress == target) {
  //         print("Challenge $challengeId progress has already reached the target.");
  //         continue;
  //       }
  //
  //       // If subtype is 'streak', check for streak condition
  //       if (subtype == 'streak') {
  //         final participants = List<String>.from(challengeData['participants'] ?? []);
  //         final condition = challengeData['condition'] ?? 0;
  //
  //         // List of participants who meet the streak condition
  //         List<Future<int>> streakChecks = participants.map((userId) async {
  //           final userDoc = await _firestore.collection('users').doc(userId).get();
  //           final streak = userDoc.data()?['streak'] ?? 0;
  //           return streak >= condition ? 1 : 0;
  //         }).toList();
  //
  //         final results = await Future.wait(streakChecks);
  //         final qualifiedCount = results.fold(0, (sum, value) => sum + value);
  //
  //         // Update progress for streak challenge
  //         await _firestore.collection('challenges').doc(challengeId).update({
  //           'progress': qualifiedCount,
  //         });
  //         print("Streak progress updated for challenge $challengeId");
  //       } else {
  //         // Update progress for form or other challenge types
  //         await _firestore
  //             .collection('challenges')
  //             .doc(challengeId)
  //             .update({'progress': FieldValue.increment(value)});
  //         print("Progress updated for challenge $challengeId");
  //       }
  //
  //       // Submit the challenge after updating progress
  //       await submitChallenge(challengeId, userId);
  //
  //       // Optionally, reward contributors
  //       // await ChallengeService().rewardChallengeContributors(challengeId);
  //     }
  //   } catch (e) {
  //     debugPrint("Failed to update challenge progress: $e");
  //   }
  // }

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

        // await ChallengeService().rewardChallengeContributors(challengeId);
      }
    } catch (e) {
      debugPrint("Failed to update challenge progress: $e");
    }
  }

  /// Updates the progress of a challenge type form
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

      // await ChallengeService().rewardChallengeContributors(challengeId);
    } catch (e) {
      debugPrint("Failed to update challenge progress: $e");
    }
  }

  /// Updates the progress of challenge type streak
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

        // await ChallengeService().rewardChallengeContributors(challengeId);
      }
    } catch (e) {
      print("Error updating streak challenges progress: $e");
    }
  }

  /// Rewards users who contributed to a challenge
  Future<void> rewardChallengeContributors(String challengeId, String userId) async {
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
      print("Challenge not completed or expired.");
      return;
    }

    if (participants.contains(userId)) {
      final hasContributed = await _firestore
          .collection('challengeSubmissions')
          .where('challengeId', isEqualTo: challengeId)
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (hasContributed.docs.isNotEmpty) {
        await TreeService().increaseDrops(userId, rewardPoint);
        rewardedUsers.add(userId);
      }
    }

    await challengeRef.update({'rewardedUsers': rewardedUsers});
  }
}
