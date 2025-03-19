import 'package:cloud_firestore/cloud_firestore.dart';

class TreeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get real-time updates
  Stream<DocumentSnapshot> getTreeProgress(String userId) {
    return _db.collection('users')
        .doc(userId)
        .snapshots();
  }

  // Update progress
  Future<void> updateProgress(String userId, double currentProgress) async {
    if (currentProgress == 1.0) currentProgress = 0;
    print("Progress: $currentProgress");
    await _db.collection('users')
        .doc(userId)
        .update({'progress': currentProgress});
  }

  Future<void> updateWater(String userId, int water) async{
    await _db.collection('users')
        .doc(userId)
        .update({'water': water});
  }

  Future<void> updateLevelOfTree(String userId, int level) async{
    await _db.collection('users')
        .doc(userId)
        .update({'levelOfTree': level});
  }

  Future<void> updateTree(String userId, int trees) async{
    await _db.collection('users')
        .doc(userId)
        .update({'tree': trees});
  }
}