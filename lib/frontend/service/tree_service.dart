import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:wastesortapp/frontend/service/notification_service.dart';

import '../../database/model/tree.dart';

class TreeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _notiService = NotificationService();

  Future<void> createTree(String userId) async {
    final treeDocRef = _db.collection('trees').doc(userId);
    final docSnapshot = await treeDocRef.get();

    if (!docSnapshot.exists) {
      await treeDocRef.set({
        'userId': userId,
        'progress': 0.0,
        'drops': 0,
        'levelOfTree': 0,
        'trees': 0,
      });
    }
  }

  // Get real-time updates
  Stream<DocumentSnapshot> getTreeProgress(String userId) {
    return _db.collection('trees')
        .doc(userId)
        .snapshots();
  }

  // Update progress
  Future<void> updateProgress(String userId, double currentProgress) async {
    if (currentProgress == 1.0) currentProgress = 0;
    print("Progress: $currentProgress");
    await _db.collection('trees')
        .doc(userId)
        .update({'progress': currentProgress});
  }


  Future<void> updateWater(String userId, int drops) async {
    try {
      // Update drops value in Firestore
      await _db.collection('trees').doc(userId).update({'drops': drops});
      print('Drops updated successfully: $drops');
    } catch (e) {
      print('Error in updateWater function: $e');
    }
  }



  Future<void> updateLevelOfTree(String userId, int level) async{
    await _db.collection('trees')
        .doc(userId)
        .update({'levelOfTree': level});
  }

  Future<void> updateTree(String userId, int trees) async{
    await _db.collection('trees')
        .doc(userId)
        .update({'trees': trees});
  }

  Future<void> increaseDrops(String userId, int increment) async {
    try {
      var treesRef = await _db.collection('trees')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (treesRef.docs.isNotEmpty) {
        String treeId = treesRef.docs.first.id;
        debugPrint("🌱 Found treeId: $treeId");

        await _db.collection('trees')
            .doc(treeId)
            .update({'drops': FieldValue.increment(increment)});

        Future.delayed(Duration(seconds: 2));

        var currentDrops = treesRef.docs.first.data()?['drops'] ?? 0;
        int newDrops = currentDrops + increment;
        if (newDrops >= 100){
          await _notiService.createNotification(status: 'water', point : 0);
        }

        debugPrint("✅ Drops incremented by $increment for treeId: $treeId");
      } else {
        debugPrint("🚨 No tree found for userId: $userId");
      }
    } catch (e) {
      debugPrint("❌ Error updating drops: $e");
    }
  }

  Stream<Map<String, int>> getUserDropsAndTrees(String userId) {
    return _db.collection('trees')
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