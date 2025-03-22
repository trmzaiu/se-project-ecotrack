import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';

class UserService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TreeService _treeService = TreeService();
  UserService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? get userId => _firebaseAuth.currentUser?.uid;

  Future<List<Map<String, dynamic>>> fetchUsersForLeaderboard() async {
    try {
      // Fetch all users from the 'users' collection
      QuerySnapshot userSnapshot = await _firestore.collection('users').get();
      List<Map<String, dynamic>> leaderboardData = [];

      print('Total users found: ${userSnapshot.docs.length}'); // Debug print

      // For each user, fetch their tree data
      for (var userDoc in userSnapshot.docs) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String userId = userData['userId']?.toString().trim() ?? '';

        if (userId.isEmpty) {
          print('Skipping user with empty userId: $userData'); // Debug print
          continue;
        }

        print('Fetching tree data for userId: "$userId"'); // Debug print

        // Fetch the tree data for this user
        QuerySnapshot treeSnapshot = await _firestore
            .collection('tree')
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();

        int treeCount = 0;
        if (treeSnapshot.docs.isNotEmpty) {
          Map<String, dynamic> treeData = treeSnapshot.docs.first.data() as Map<String, dynamic>;
          print('Tree data for userId $userId: $treeData'); // Debug print
          treeCount = treeData['tree'] ?? 0; // Use 'tree' field
        } else {
          print('No tree data found for userId: "$userId"'); // Debug print
        }

        // Add user data with their tree count (score) to the leaderboard list
        leaderboardData.add({
          'name': userData['name'] ?? 'Unknown',
          'score': treeCount,
          'image': userData['photoUrl']?.isNotEmpty == true
              ? userData['photoUrl']
              : 'lib/assets/images/caution.png',
        });
      }

      // Sort users by score (number of trees) in descending order
      leaderboardData.sort((a, b) => b['score'].compareTo(a['score']));

      // Add rank to each user
      for (int i = 0; i < leaderboardData.length; i++) {
        leaderboardData[i]['rank'] = i + 1;
      }

      print('Leaderboard data: $leaderboardData'); // Debug print
      return leaderboardData;
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      throw Exception("Failed to fetch leaderboard data: $e");
    }
  }
}