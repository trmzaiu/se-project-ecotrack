import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    if (!snapshot.exists) {
      return {
        'photoUrl': '',
        'name': userId.substring(0, 10),
        'email': '',
        'dob': DateTime.now().toString(),
        'country': ''
      };
    }

    final data = snapshot.data() ?? {};

    return {
      'photoUrl': data['photoUrl'] ?? '',
      'name': data['name'] ?? userId.substring(0, 10),
      'email': data['email'] ?? '',
      'dob': data['dob'] ?? DateTime.now().toString(),
      'country': data['country'] ?? ''
    };
  }

  Stream<Map<String, dynamic>> getCurrentUser(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return {
          'photoUrl': '',
          'name': userId.substring(0, 10),
          'email': '',
          'dob': DateTime.now().toString(),
          'country': ''
        };
      }

      final data = snapshot.data() ?? {};

      return {
        'photoUrl': data['photoUrl'] ?? '',
        'name': data['name'] ?? userId.substring(0, 10),
        'email': data['email'] ?? '',
        'dob': data['dob'] ?? DateTime.now().toString(),
        'country': data['country'] ?? ''
      };
    });
  }


  // Update user name
  Future<void> updateUserName(String userId, String newName) async {
    try {
      await _db.collection('users').doc(userId).update({'name': newName});
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }

  Future<void> updateUserDob(String userId, DateTime dob) async {
    String dobString = dob.toIso8601String();

    try {
      await _db.collection('users')
          .doc(userId)
          .update({'dob': dobString}
      );
      print("User DOB updated: $dobString");
    } catch (e) {
      print("Failed to update DOB: $e");
      throw Exception('Failed to update DOB');
    }
  }

  Future<void> updateUserCountry(String userId, String country) async {
    try {
      await _db.collection('users')
          .doc(userId)
          .update({'country': country});
      print("User country updated: $country");
    } catch (e) {
      print("Failed to update country: $e");
      throw Exception('Failed to update country');
    }
  }

  Future<void> updateUserAvatar(String userId, File image) async {
    try {
      String? photoUrl = await CloudinaryConfig().uploadImage(image);

      await _db.collection('users')
          .doc(userId)
          .update({'photoUrl': photoUrl});

      print("User photoUrl updated: $photoUrl");
    } catch (e) {
      print("Failed to update photoUrl for userId: $userId. Error: $e");

      throw Exception('Failed to update photoUrl');
    }
  }

  Stream<int> getUserStreak(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data()?['streak'] ?? 0);
  }

  Future<int> checkUserStreakFuture(String userId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null && data.containsKey('streak')) {
          return data['streak'] as int;
        }
      }

      return 0; // Default streak if not found
    } catch (e) {
      print('Error fetching user streak: $e');
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final usersRef = FirebaseFirestore.instance.collection('users');
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
