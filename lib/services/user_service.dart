import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../database/CloudinaryConfig.dart';
import '../../models/leaderboard.dart';
import '../../models/user.dart';

class UserService {
  final FirebaseFirestore _db;

  UserService()
  : _db  = FirebaseFirestore.instance;

  UserService.test({
    required FirebaseFirestore firestore
  }): _db = firestore;
  /// Stream the current user data in real time
  Stream<Usr?> getCurrentUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) return null;
      return Usr.fromMap(data, userId);
    });
  }

  /// Stream leaderboard data based on number of trees per user
  Stream<List<Leaderboard>> showLeaderboard() {
    Stream<QuerySnapshot> usersStream = _db.collection('users').snapshots();
    Stream<QuerySnapshot> treesStream = _db.collection('trees').snapshots();

    return Rx.combineLatest2(
        usersStream, treesStream, (usersSnapshot, treesSnapshot) {
      if (usersSnapshot.docs.isEmpty) return [];

      Map<String, Leaderboard> usersData = {};

      for (var doc in usersSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        usersData[doc.id] = Leaderboard(
          userId: doc.id,
          name: data['name'] ?? doc.id.substring(0, 10),
          photoUrl: data['photoUrl'] ?? '',
          trees: 0,
          rank: 0,
        );
      }

      for (var doc in treesSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String userId = data['userId']?.toString().trim() ?? '';
        if (usersData.containsKey(userId)) {
          usersData[userId] = usersData[userId]!.copyWith(trees: data['trees'] ?? 0);
        }
      }

      List<Leaderboard> leaderboardData = usersData.values.toList();
      leaderboardData.sort((a, b) => b.trees.compareTo(a.trees));

      for (int i = 0; i < leaderboardData.length; i++) {
        leaderboardData[i] = leaderboardData[i].copyWith(rank: i + 1);
      }

      return leaderboardData;
    });
  }

  /// Update user profile
  Future<void> updateUserProfile(String userId, {
    String? name,
    DateTime? dob,
    String? country,
    File? image
  }) async {
    final Map<String, dynamic> updates = {};
    if (name != null) updates['name'] = name;
    if (dob != null) updates['dob'] = DateFormat('dd/MM/yyyy').format(dob);
    if (country != null) updates['country'] = country;
    if (image != null) {
      String? photoUrl = await CloudinaryConfig().uploadImage(image);
      updates['photoUrl'] = photoUrl;
    }

    if (updates.isEmpty) return;

    try {
      await _db.collection('users').doc(userId).update(updates);
    } catch (e) {
      throw Exception('Failed to update profile');
    }
  }

  /// Get list of users by their IDs
  Future<List<Usr>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final usersRef = _db.collection('users');
    final List<Usr> users = [];

    const batchSize = 10;
    for (int i = 0; i < userIds.length; i += batchSize) {
      final batch = userIds.sublist(
          i, i + batchSize > userIds.length ? userIds.length : i + batchSize);
      final querySnapshot = await usersRef.where(FieldPath.documentId, whereIn: batch).get();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        data['userId'] = doc.id;
        users.add(Usr.fromMap(data, data['userId']));
      }
    }

    return users;
  }
}
