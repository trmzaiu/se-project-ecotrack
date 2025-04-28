// tree_service_test_impl.dart
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_url_gen/config/api_config.dart';
import 'package:cloudinary_url_gen/config/cloud_config.dart';
import 'package:cloudinary_url_gen/config/cloudinary_config.dart';
import 'package:cloudinary_url_gen/config/url_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wastesortapp/ScanAI/processImage.dart';
import 'package:wastesortapp/database/model/tree.dart';
import 'package:wastesortapp/frontend/service/evidence_service.dart';
import 'package:wastesortapp/frontend/service/notification_service.dart';

class TreeServiceTest {
  final FirebaseFirestore _db;
  final NotificationService _notiService;

  TreeServiceTest({
    required FirebaseFirestore firestore,
    required NotificationService notiService,
  })  : _db = firestore,
        _notiService = notiService;

  Future<void> createTree(String userId) async {
    final treeDocRef = _db.collection('trees').doc(userId);
    final docSnapshot = await treeDocRef.get();

    if (!docSnapshot.exists) {
      Trees tree = Trees(
        treeId: treeDocRef.id,
        userId: userId,
        progress: 0.0,
        drops: 0,
        levelOfTree: 0,
        trees: 0,
      );

      await treeDocRef.set(tree.toMap(), SetOptions(merge: true));
    }
  }

  Stream<DocumentSnapshot> getTreeProgress(String userId) {
    return _db.collection('trees').doc(userId).snapshots();
  }

  Future<void> updateProgress(String userId, double currentProgress) async {
    final treeDocRef = _db.collection('trees').doc(userId);

    // Kiểm tra nếu tài liệu không tồn tại, tạo mới nó
    final docSnapshot = await treeDocRef.get();
    if (!docSnapshot.exists) {
      // Nếu tài liệu không tồn tại, tạo mới tài liệu với giá trị mặc định
      await treeDocRef.set({
        'progress': currentProgress,
        'userId': userId,
        // Các trường khác nếu cần thiết
      }, SetOptions(merge: true)); // Merge để giữ lại các trường cũ nếu có
    } else {
      // Nếu tài liệu đã tồn tại, update giá trị
      await treeDocRef.update({'progress': currentProgress});
    }
  }

  Future<void> updateWater(String userId, int drops) async {
    await _db.collection('trees').doc(userId).update({'drops': drops});
  }

  Future<void> updateLevelOfTree(String userId, int level) async {
    await _db.collection('trees').doc(userId).update({'levelOfTree': level});
  }

  Future<void> updateTree(String userId, int trees) async {
    await _db.collection('trees').doc(userId).update({'trees': trees});
  }

  Future<void> increaseDrops(String userId, int increment) async {
    var treesRef = await _db.collection('trees').where('userId', isEqualTo: userId).limit(1).get();

    if (treesRef.docs.isNotEmpty) {
      String treeId = treesRef.docs.first.id;

      await _db.collection('trees').doc(treeId).update({
        'drops': FieldValue.increment(increment),
      });

      var currentData = treesRef.docs.first.data();
      var currentDrops = currentData['drops'] ?? 0;
      int newDrops = currentDrops + increment;

      if (newDrops >= 100) {
        await _notiService.sendNotificationToUser(
          receiverUserId: userId,
          title: 'Water Level Reached the Limit!',
          body: 'Check now to prevent overflow or adjust as needed.',
          type: 'water',
        );
      }
    }
  }
}

class MockApiService extends Mock implements ApiService {
  @override
  Future<String> classifyImage(File? image) {
    return super.noSuchMethod(
      Invocation.method(#classifyImage, [image]),
      returnValue: Future.value('Plastic'),
      returnValueForMissingStub: Future.value('Plastic'),
    );
  }
}

class MockCloudinaryConfig extends Mock implements CloudinaryConfig {
  static uploadImage(File testImage) {}
}
