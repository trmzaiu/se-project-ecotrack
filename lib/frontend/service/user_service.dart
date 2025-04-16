import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserService();

  // Stream for leaderboard
  Stream<List<Map<String, dynamic>>> leaderboardStream() {
    Stream<QuerySnapshot> usersStream = _db.collection('users').snapshots();
    Stream<QuerySnapshot> treesStream = _db.collection('trees').snapshots();

    return Rx.combineLatest2(usersStream, treesStream, (usersSnapshot, treesSnapshot) {
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
  Future<Map<String, dynamic>> getCurrentUser(String userId) async {
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

  // Update user name
  Future<void> updateUserName(String userId, String newName) async {
    try {
      await _db.collection('users').doc(userId).update({'name': newName});
    } catch (e) {
      throw Exception('Failed to update name: $e');
    }
  }

  // Update user email
  Future<void> updateUserEmail(String userId, String newEmail) async {
    try {
      // Update email in Firebase Authentication
      await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);

      // Update email in Firestore
      await _db.collection('users').doc(userId).update({'email': newEmail});
    } catch (e) {
      throw Exception('Failed to update email: $e');
    }
  }

  // Update user password
  Future<void> updateUserPassword(String userId, String newPassword) async {
    try {
      // Update password in Firebase Authentication
      await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }


  Future<void> updateUserProfile({
    required String userId,
    required DateTime dob,
    required String country,
  }) async {
    String dobString = dob.toIso8601String();

    try {
      await _db.collection('users').doc(userId).update({
        'dob': dobString,
        'country': country,
      });

      print("User profile updated: DOB = $dobString, Country = $country");
    } catch (e) {
      print("Failed to update user profile: $e");
      throw Exception('Failed to update profile');
    }
  }
}
