import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../database/CloudinaryConfig.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserService();

  Future<void> updateUserPassword(String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }

    await user.updatePassword(newPassword);
  }

  Stream<List<Map<String, dynamic>>> leaderboardStream() {
    Stream<QuerySnapshot> usersStream = _db.collection('users').snapshots();
    Stream<QuerySnapshot> treesStream = _db.collection('trees').snapshots();

    return Rx.combineLatest2(
        usersStream, treesStream, (usersSnapshot, treesSnapshot) {
      if (usersSnapshot.docs.isEmpty) return [];

      Map<String, Map<String, dynamic>> usersData = {};
      for (var doc in usersSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        usersData[doc.id] = {
          'userId': doc.id,
          'name': data['name'] ?? doc.id.substring(0, 10),
          'image': data['photoUrl'] ?? '',
          'trees': 0
        };
      }

      for (var doc in treesSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String userId = data['userId']?.toString().trim() ?? '';
        if (usersData.containsKey(userId)) {
          usersData[userId]!['trees'] = (data['trees'] ?? 0);
        }
      }

      List<Map<String, dynamic>> leaderboardData = usersData.values.toList();
      leaderboardData.sort((a, b) => b['trees'].compareTo(a['trees']));

      for (int i = 0; i < leaderboardData.length; i++) {
        leaderboardData[i]['rank'] = i + 1;
      }

      return leaderboardData;
    });
  }

  // Get current user data
  Future<Map<String, dynamic>> getCurrentUserFuture(String userId) async {
    final snapshot = await _db.collection('users').doc(userId).get();
    return snapshot.data() ?? {};
  }

  Stream<Map<String, dynamic>> getCurrentUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      return snapshot.data() ?? {};
    });
  }

  // Update user profile
  Future<void> updateUserProfile(String userId, {
    String? name,
    DateTime? dob,
    String? country,
    File? image
  }) async {
    final Map<String, dynamic> updates = {};

    if (name != null) updates['name'] = name;

    if (dob != null) {
      final formattedDob = DateFormat('dd/MM/yyyy').format(dob);
      updates['dob'] = formattedDob;
    }

    if (country != null) updates['country'] = country;

    if (image != null) {
      String? photoUrl = await CloudinaryConfig().uploadImage(image);
      updates['photoUrl'] = photoUrl;
    }

    if (updates.isEmpty) {
      print("⚠️ No fields provided to update");
      return;
    }

    try {
      await _db.collection('users').doc(userId).update(updates);
      print("✅ User profile updated: $updates");
    } catch (e) {
      print("❌ Failed to update profile for $userId: $e");
      throw Exception('Failed to update profile');
    }
  }


  Stream<int> getUserStreak(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['streak'] ?? 0);
  }

  Future<List<Map<String, dynamic>>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final usersRef = _db.collection('users');
    final List<Map<String, dynamic>> users = [];

    final batches = <List<String>>[];
    const batchSize = 10;

    for (int i = 0; i < userIds.length; i += batchSize) {
      batches.add(userIds.sublist(i, i + batchSize > userIds.length ? userIds.length : i + batchSize));
    }

    for (var batch in batches) {
      final querySnapshot = await usersRef.where(FieldPath.documentId, whereIn: batch).get();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        users.add({
          'id': doc.id,
          'name': data['name'] ?? '',
          'photoUrl': data['photoUrl'] ?? '',
          'email': data['email'] ?? '',
        });
      }
    }

    return users;
  }
}
