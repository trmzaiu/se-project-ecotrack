import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wastesortapp/services/challenge_service.dart';
import 'package:wastesortapp/services/notification_service.dart';
import 'package:wastesortapp/services/tree_service.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../ScanAI/processImage.dart';
import '../../database/CloudinaryConfig.dart';
import '../../models/evidence.dart';
import '../screens/evidence/evidence_screen.dart';
import '../utils/route_transition.dart';

class EvidenceService{
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  // EvidenceService(this.context);
  EvidenceService()
      : _db = FirebaseFirestore.instance,
        _auth = FirebaseAuth.instance;

  EvidenceService.test({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) :  _db = firestore,
        _auth = auth;

  // Submit new evidence with image upload and description
  Future<Evidence?> submitData({
    required List<File> selectedImages,
    required String selectedCategory,
    required TextEditingController descriptionController,
    int totalPoint = 5,
  }) async {
    try {
      if (selectedImages.isEmpty) {
        throw Exception("No image selected");
      }

      if (selectedCategory.isEmpty) {
        throw Exception("Please select a category");
      }

      // Upload images
      List<String> uploadedImageUrls = await _uploadImages(selectedImages);
      if (uploadedImageUrls.isEmpty) {
        throw Exception("Image upload failed");
      }

      // Calculate points
      String description = descriptionController.text.trim();
      int finalPoints = _calculatePoints(uploadedImageUrls.length, description, basePoint: totalPoint);

      // Create Evidence object
      Evidence evidence = _createEvidence(
        category: selectedCategory,
        imagesUrl: uploadedImageUrls,
        description: description,
        point: finalPoints,
      );

      // Save to Firestore
      await _db.collection('evidences').doc(evidence.evidenceId).set(evidence.toMap());

      return evidence; // thành công

    } catch (e) {
      print("Error in submitData: $e");
      return null; // thất bại
    }
  }

  Future<List<String>> _uploadImages(List<File> selectedImages) async {
    return await Future.wait(
      selectedImages.map((image) async => await CloudinaryConfig().uploadImage(image)),
    ).then((urls) => urls.whereType<String>().toList());
  }

  int _calculatePoints(int imageCount, String description, {int basePoint = 5}) {
    int points = basePoint;

    if (imageCount == 5) {
      points += 10;
    } else if (imageCount > 2) {
      points += 5;
    }

    if (description.length >= 50) {
      points += 10;
    } else if (description.isNotEmpty) {
      points += 5;
    }

    return points;
  }

  /// Create a evidence
  Evidence _createEvidence({
    required String category,
    required List<String> imagesUrl,
    required String description,
    required int point,
  }) {
    String evidenceId = _db.collection('evidences').doc().id;

    return Evidence(
      userId: _auth.currentUser!.uid,
      evidenceId: evidenceId,
      category: category,
      imagesUrl: imagesUrl,
      description: description,
      date: DateTime.now(),
      status: "Pending",
      point: point,
    );
  }

  /// Stream evidence list by userId, sorted by points
  Stream<List<Evidence>> getEvidencesByUserId(String userId) {
    return FirebaseFirestore.instance
        .collection('evidences')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs.map((doc) {
        return Evidence.fromMap(doc.data(), doc.id);
      }).toList();

      list.sort((a, b) => b.date.compareTo(a.date));

      return list;
    });
  }

  /// Automatically verify an evidence using AI image classification
  Future<void> verifyEvidence(Evidence evidence) async {
    try {
      bool allMatched = true;

      // Download and classify all images concurrently (in parallel)
      List<Future<String?>> classificationFutures = evidence.imagesUrl.map((imageUrl) async {
        // Download each image file
        File imageFile = await _downloadImage(imageUrl);
        // Classify the image
        return await ApiService.classifyImage(imageFile);
      }).toList();

      // Wait for all classification results
      List<String?> predictedCategories = await Future.wait(classificationFutures);

      // Check if all categories match the evidence's category
      allMatched = predictedCategories.every((category) => category != null && category == evidence.category);

      // Update the evidence status based on classification results
      String newStatus = allMatched ? "Accepted" : "Rejected";
      await _db.collection('evidences').doc(evidence.evidenceId).update({'status': newStatus});

      // If evidence is accepted, start updating points and progress
      if (newStatus == "Accepted") {
        debugPrint("✅ Evidence accepted, starting point and progress update...");

        // Increase points for the user
        await TreeService().increaseDrops(evidence.userId, evidence.point);

        // Send notification to the user immediately (no need for delay)
        await NotificationService().sendNotificationToUser(
          notificationId: evidence.evidenceId,
          receiverUserId: evidence.userId,
          title: 'Your Evidence Was Approved!',
          body: 'You earned ${evidence.point} points. Keep contributing for more rewards!',
          type: 'evidence',
        );

        debugPrint("📈 Updating challenge progress...");

        // Update challenge progress for "evidence" and the weekly task progress
        await Future.wait([
          ChallengeService().updateChallengeProgress(subtype:'evidence', value: evidence.point),
          ChallengeService().updateWeeklyProgressForTasks(evidence.userId, 'evidence', category: evidence.category.toLowerCase())
        ]);

        debugPrint("✅ Challenge progress update done!");
      }

    } catch (e) {
      debugPrint("Error verifying evidence: $e");
    }
  }

  /// Helper function to download image file from URL
  Future<File> _downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception("Failed to download image");
    }
  }

  /// Get number of accepted evidences by category for a user
  Stream<Map<String, int>> getTotalEachAcceptedCategory(String userId) {
    return _db.collection('evidences')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Accepted')
        .snapshots()
        .map((querySnapshot) {
      Map<String, int> categoryCount = {};

      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        String category = data['category'];

        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }

      return categoryCount;
    });
  }

  /// Get total number of accepted evidences for a user
  Stream<int> getTotalEvidences(String userId) {
    return _db.collection('evidences')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Accepted')
        .snapshots()
        .map((querySnapshot) => querySnapshot.size);
  }

  /// Get a specific evidence by ID
  Future<Evidence?> getEvidenceById(String evidenceId) async {
    try {
      final doc = await _db
          .collection('evidences')
          .doc(evidenceId)
          .get();

      if (doc.exists && doc.data() != null) {
        return Evidence.fromMap(doc.data()!, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Evidence not found");
    }
  }
}