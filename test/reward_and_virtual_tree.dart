import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wastesortapp/models/evidence.dart';
import 'package:wastesortapp/services/evidence_service.dart';
import 'package:wastesortapp/services/notification_service.dart';
import 'mock_test.dart';

class FakeNotificationService extends Mock implements NotificationService {}

void main() {
  group('Rewarding', () {
    late EvidenceService evidenceService;
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockApiService mockApiService;
    late File testImage;

    setUp(() async {
      // Initialize mock services and Firestore
      firestore = FakeFirebaseFirestore();
      mockFirebaseAuth = MockFirebaseAuth();
      mockApiService = MockApiService();

      // Setup mock user
      mockFirebaseAuth.signInWithEmailAndPassword(email: "testuser@example.com", password: "password");

      // Create a test image file (this would be a mock for testing)
      testImage = File('test/test_image.jpg');

      // Initialize the EvidenceService
      evidenceService = EvidenceService.test(
        firestore: firestore,
        auth: mockFirebaseAuth,
      );
    });
    test('verifyEvidence updates the status to Accepted if categories match', () async {
      var evidence = Evidence(
        userId: 'testuser',
        evidenceId: 'evidence1',
        category: 'Recyclable',
        imagesUrl: ['http://mockurl.com/test_image.jpg'],
        description: 'Test description',
        date: DateTime.now(),
        status: 'Pending',
        point: 5,
      );

      // Add the evidence to Firestore
      await firestore.collection('evidences').doc(evidence.evidenceId).set(evidence.toMap());

      // Mock Cloudinary image upload and classification
      when(MockCloudinaryConfig.uploadImage(testImage)).thenAnswer((_) async => 'http://res.cloudinary.com/dosqd0oni/image/upload/test_image.jpg');
      when(mockApiService.classifyImage(testImage)).thenAnswer((_) async => 'Recyclable');

      // Call the verifyEvidence method
      await evidenceService.verifyEvidence(evidence);

      // Fetch the updated evidence from Firestore
      var updatedEvidenceSnapshot = await firestore.collection('evidences').doc(evidence.evidenceId).get();
      expect(updatedEvidenceSnapshot.data()?['status'], 'Accepted');
    });

    test('verifyEvidence updates the status to Rejected if categories do not match', () async {
      // Create a sample evidence object
      var evidence = Evidence(
        userId: 'testuser',
        evidenceId: 'evidence2',
        category: 'Recyclable',
        imagesUrl: ['http://mockurl.com/test_image.jpg'],
        description: 'Test description',
        date: DateTime.now(),
        status: 'Pending',
        point: 5,
      );

      // Add the evidence to Firestore
      await firestore.collection('evidences').doc(evidence.evidenceId).set(evidence.toMap());

      // Mock Cloudinary image upload and classification
      when(MockCloudinaryConfig.uploadImage(testImage)).thenAnswer((_) async => 'http://mockurl.com/test_image.jpg');
      when(mockApiService.classifyImage(testImage)).thenAnswer((_) async => 'Hazardous');

      // Call the verifyEvidence method
      await evidenceService.verifyEvidence(evidence);

      // Fetch the updated evidence from Firestore
      var updatedEvidenceSnapshot = await firestore.collection('evidences').doc(evidence.evidenceId).get();
      expect(updatedEvidenceSnapshot.data()?['status'], 'Rejected');
    });
  });
  group('Virtual Tree Growth', () {
    late TreeServiceTest treeService;
    late FakeFirebaseFirestore mockFirestore;

    const userId = 'testUserId';

    setUp(() {
      mockFirestore = FakeFirebaseFirestore();
      treeService = TreeServiceTest(
        firestore: mockFirestore,
        notiService: FakeNotificationService(),
      );
    });

    test('always generate a new tree for new user', () async {
      await treeService.createTree(userId);
      final docSnapshot = await mockFirestore.collection('trees').doc(userId).get();
      expect(docSnapshot.exists, isTrue);
    });

    test('should update progress of each tree levels', () async {
      await treeService.updateProgress(userId, 0.7);

      final doc = await mockFirestore.collection('trees').doc(userId).get();
      expect(doc.data()?['progress'], 0.7);
    });

    test('should update the drops to water tree', () async {
      final treeDocRef = mockFirestore.collection('trees').doc(userId);

      await treeDocRef.set({
        'drops': 10,
        'userId': userId,
      });

      await treeService.updateWater(userId, 20);

      final updatedDoc = await treeDocRef.get();
      expect(updatedDoc.exists, true);
      final data = updatedDoc.data();
      expect(data?['drops'], 20);
    });

    test('should update the level of the tree', () async {
      final treeDocRef = mockFirestore.collection('trees').doc(userId);

      await treeDocRef.set({
        'levelOfTree': 1,
        'userId': userId,
      });

      await treeService.updateLevelOfTree(userId, 2);

      final updatedDoc = await treeDocRef.get();
      expect(updatedDoc.exists, true);
      final data = updatedDoc.data();
      expect(data?['levelOfTree'], 2);
    });

    test('should donate the number of trees', () async {
      final treeDocRef = mockFirestore.collection('trees').doc(userId);

      await treeDocRef.set({
        'trees': 5,
        'userId': userId,
      });

      await treeService.updateTree(userId, 10);

      final updatedDoc = await treeDocRef.get();
      expect(updatedDoc.exists, true);
      final data = updatedDoc.data();
      expect(data?['trees'], 10);
    });

  });
}
