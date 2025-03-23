import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<Map<String, dynamic>> getCurrentUser(String userId) async {
  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .get();

  if (userDoc.exists) {
    return {
      'photoUrl': userDoc.data()?['photoUrl'] ?? 'lib/assets/images/user_image.png',
      'name': userDoc.data()?['name'] ?? '',
      'email': userDoc.data()?['email'] ?? '',
      'water': userDoc.data()?['water'].toString() ?? '0',
      'tree': userDoc.data()?['tree'].toString() ?? '0',
      'evidence': userDoc.data()?['evidence'].toString() ?? '0',
    };
  }

  return {
    'photoUrl': 'lib/assets/images/user_image.png',
    'name': 'Guest',
    'email': 'guest@example.com',
    'water': '0',
    'tree': '0',
    'evidence': '0',
  };
}

