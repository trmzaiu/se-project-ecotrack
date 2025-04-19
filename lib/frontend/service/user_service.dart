import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserService();

  Future<void> updateUserEmail({
    required String currentPassword,
    required String newEmail,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      throw Exception('No user is currently logged in.');

    }

    try {

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      print(' Reauthentication successful');


      await user.updateEmail(newEmail);
      print(' Email updated in Firebase Auth');


      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'email': newEmail,
      });
      print(' Email updated in Firestore');


      await user.reload();

    } catch (e) {
      print(' Failed to update email: $e');
      throw Exception('Failed to update email: $e');
    }
  }

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

  Future<void> updateUserDob({
    required String userId,
    required DateTime dob,
  }) async {
    String dobString = dob.toIso8601String();

    try {
      await _db.collection('users').doc(userId).update({
        'dob': dobString,
      });
      print("User DOB updated: $dobString");
    } catch (e) {
      print("Failed to update DOB: $e");
      throw Exception('Failed to update DOB');
    }
  }

  Future<void> updateUserCountry({
    required String userId,
    required String country,
  }) async {
    try {
      await _db.collection('users').doc(userId).update({
        'country': country,
      });
      print("User country updated: $country");
    } catch (e) {
      print("Failed to update country: $e");
      throw Exception('Failed to update country');
    }
  }
}
