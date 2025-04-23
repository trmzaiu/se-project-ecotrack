import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:wastesortapp/frontend/service/notification_service.dart';

import '../../database/model/tree.dart';

class TreeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _notiService = NotificationService();

  /// Creates a tree document for the user if it does not already exist.
  Future<void> createTree(String userId) async {
    final treeDocRef = _db
        .collection('trees')
        .doc(userId);
    final docSnapshot = await treeDocRef.get();

    if (!docSnapshot.exists) {
      // Create a new tree document for the user
      Trees tree = Trees(
        treeId: treeDocRef.id,
        userId: userId,
        progress: 0.0,
        drops: 0,
        levelOfTree: 0,
        trees: 0,
      );

      await treeDocRef.set(
        tree.toMap(),
        SetOptions(merge: true),
      );
    }
  }

  /// Get real-time updates of the tree data for a specific user.
  Stream<DocumentSnapshot> getTreeProgress(String userId) {
    return _db
        .collection('trees')
        .doc(userId)
        .snapshots();
  }

  /// Update the progress of the tree for a specific user.
  Future<void> updateProgress(String userId, double currentProgress) async {
    if (currentProgress == 1.0) currentProgress = 0;
    print("Progress: $currentProgress");
    await _db
        .collection('trees')
        .doc(userId)
        .update({'progress': currentProgress});
  }

  /// Update the number of water drops for a specific user's tree.
  Future<void> updateWater(String userId, int drops) async {
    try {
      // Update drops value in Firestore
      await _db
          .collection('trees')
          .doc(userId)
          .update({'drops': drops});
      print('Drops updated successfully: $drops');
    } catch (e) {
      print('Error in updateWater function: $e');
    }
  }

  /// Update the level of the tree for a specific user.
  Future<void> updateLevelOfTree(String userId, int level) async {
    await _db
        .collection('trees')
        .doc(userId)
        .update({'levelOfTree': level});
  }

  /// Update the total number of trees for a specific user.
  Future<void> updateTree(String userId, int trees) async {
    await _db
        .collection('trees')
        .doc(userId)
        .update({'trees': trees});
  }

  /// Increase the number of drops for a specific user's tree by a certain increment.
  Future<void> increaseDrops(String userId, int increment) async {
    try {
      var treesRef = await _db
          .collection('trees')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (treesRef.docs.isNotEmpty) {
        String treeId = treesRef.docs.first.id;
        debugPrint("🌱 Found treeId: $treeId");

        // Increment the drops count in Firestore
        await _db.collection('trees')
            .doc(treeId)
            .update({'drops': FieldValue.increment(increment)});

        Future.delayed(Duration(seconds: 2));

        var currentDrops = treesRef.docs.first.data()['drops'] ?? 0;
        int newDrops = currentDrops + increment;
        if (newDrops >= 100) {
          // Send notification if drops reach the threshold
          await _notiService.sendNotificationToUser(
            receiverUserId: userId,
            title: 'Water Level Reached the Limit!',
            body: 'Check now to prevent overflow or adjust as needed.',
            type: 'water'
          );
        }

        debugPrint("✅ Drops incremented by $increment for treeId: $treeId");
      } else {
        debugPrint("🚨 No tree found for userId: $userId");
      }
    } catch (e) {
      debugPrint("❌ Error updating drops: $e");
    }
  }

  /// Get real-time updates of drops and trees data for a specific user.
  Stream<Map<String, int>> getUserDropsAndTrees(String userId) {
    return _db
        .collection('trees')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        var data = snapshot.data() as Map<String, dynamic>;
        return {
          'drops': data['drops'] ?? 0,
          'trees': data['trees'] ?? 0,
        };
      }
      return {'drops': 0, 'trees': 0};
    });
  }
}
