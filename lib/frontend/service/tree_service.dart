import 'package:cloud_firestore/cloud_firestore.dart';

class TreeService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createTree(String userId) async {
    final treeDocRef = _db.collection('trees').doc(userId);
    final docSnapshot = await treeDocRef.get();

    if (!docSnapshot.exists) {
      await treeDocRef.set({
        'userId': userId,
        'progress': 0.0,
        'drops': 0,
        'levelOfTree': 0,
        'trees': 0,
      });
    }
  }

  // Get real-time updates
  Stream<DocumentSnapshot> getTreeProgress(String userId) {
    return _db.collection('trees')
        .doc(userId)
        .snapshots();
  }

  // Update progress
  Future<void> updateProgress(String userId, double currentProgress) async {
    if (currentProgress == 1.0) currentProgress = 0;
    print("Progress: $currentProgress");
    await _db.collection('trees')
        .doc(userId)
        .update({'progress': currentProgress});
  }

  Future<void> updateWater(String userId, int water) async{
    await _db.collection('trees')
        .doc(userId)
        .update({'drops': water});
  }

  Future<void> updateLevelOfTree(String userId, int level) async{
    await _db.collection('trees')
        .doc(userId)
        .update({'levelOfTree': level});
  }

  Future<void> updateTree(String userId, int trees) async{
    await _db.collection('trees')
        .doc(userId)
        .update({'trees': trees});
  }

  Future<void> increaseDrops(String treeId, int increment) async {
    try {
      await _db.collection('trees')
          .doc(treeId)
          .update({'drops': FieldValue.increment(increment),});
      print("Drops incremented successfully");
    } catch (e) {
      print("Failed to increment drops: $e");
    }
  }

  Future<String?> getTreeIdByUserId(String userId) async {
    var treesRef = await _db.collection('trees')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (treesRef.docs.isNotEmpty) {
      return treesRef.docs.first.id;
    }

    return null;
  }

}