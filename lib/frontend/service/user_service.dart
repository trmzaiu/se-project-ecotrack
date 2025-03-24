import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart'; // Import RxDart

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserService();

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
          'name': data['name'] ?? 'Unknown',
          'image': data['photoUrl']?.isNotEmpty == true
              ? data['photoUrl']
              : 'lib/assets/images/avatar_default.png',
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
}
