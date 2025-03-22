import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? get userId => _firebaseAuth.currentUser?.uid;

  Future<List<Map<String, dynamic>>> fetchUsersForLeaderboard() async {
    try {
      // Fetch all users from 'users' collection
      QuerySnapshot userSnapshot = await _firestore.collection('users').get();
      if (userSnapshot.docs.isEmpty) return [];

      Map<String, Map<String, dynamic>> usersData = {};
      for (var doc in userSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        usersData[doc.id] = {
          'name': data['name'] ?? 'Unknown',
          'image': data['photoUrl']?.isNotEmpty == true
              ? data['photoUrl']
              : 'lib/assets/images/avatar_default.png',
          'tree': 0 // Default tree, will be updated
        };
      }

      // Fetch all tree data in one query
      QuerySnapshot treeSnapshot = await _firestore.collection('tree').get();
      for (var doc in treeSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String userId = data['userId']?.toString().trim() ?? '';
        if (usersData.containsKey(userId)) {
          usersData[userId]!['tree'] = (data['tree'] ?? 0);
        }
      }

      // Convert to list and sort by tree
      List<Map<String, dynamic>> leaderboardData = usersData.values.toList();
      leaderboardData.sort((a, b) => b['tree'].compareTo(a['tree']));

      // Assign ranks
      for (int i = 0; i < leaderboardData.length; i++) {
        leaderboardData[i]['rank'] = i + 1;
      }

      return leaderboardData;
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      throw Exception("Failed to fetch leaderboard data: $e");
    }
  }
}
