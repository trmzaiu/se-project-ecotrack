import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wastesortapp/frontend/service/challenge_service.dart';
import 'package:wastesortapp/frontend/service/notification_service.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../ScanAI/processImage.dart';
import '../../database/CloudinaryConfig.dart';
import '../../database/model/evidence.dart';
import '../screen/evidence/evidence_screen.dart';
import '../utils/route_transition.dart';

class EvidenceService{
  final BuildContext context;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TreeService _treeService = TreeService();
  final _notificationService = NotificationService();

  EvidenceService(this.context);

  Future<void> submitData({
    required List<File> selectedImages,
    required String selectedCategory,
    required TextEditingController descriptionController,
    int totalPoint = 5,
  }) async {
    if (selectedImages.isEmpty) {
      _showSnackBar("No image selected");
      return;
    }

    if (selectedCategory == '') {
      _showSnackBar("Please select a category");
      return;
    }

    try {
      // Upload images concurrently
      List<String> uploadedImageUrls = await Future.wait(
        selectedImages.map((image) async => await CloudinaryConfig().uploadImage(image)),
      ).then((urls) => urls.whereType<String>().toList());

      if (uploadedImageUrls.isEmpty) {
        _showSnackBar("Image upload failed");
        return;
      }

      // Points calculation
      if (uploadedImageUrls.length == 5) {
        totalPoint += 10;
      } else if (uploadedImageUrls.length > 2) {
        totalPoint += 5;
      }

      String description = descriptionController.text.trim();
      if (description.length >= 50) {
        totalPoint += 10;
      } else if (description.isNotEmpty) {
        totalPoint += 5;
      }

      String evidenceId = _db.collection('evidences').doc().id;

      Evidences evidence = Evidences(
        userId: _auth.currentUser!.uid,
        evidenceId: evidenceId,
        category: selectedCategory,
        imagesUrl: uploadedImageUrls,
        description: description,
        date: DateTime.now(),
        status: "Pending",
        point: totalPoint,
      );

      // Save evidence in Firestore
      await _db.collection('evidences').doc(evidenceId).set(evidence.toMap());

      _showSnackBar("Upload successful!", success: true);

      Navigator.of(context).pushAndRemoveUntil(
        moveLeftRoute(EvidenceScreen(), settings: RouteSettings(name: "EvidenceScreen")),
            (route) => route.settings.name != "UploadScreen" && route.settings.name != "EvidenceScreen" || route.isFirst,
      );

      await _db.collection('evidences')
          .doc(evidenceId)
          .set(evidence.toMap());

      // Schedule verification after delay
      Future.delayed(Duration(seconds: 5), () async {
        await verifyEvidence(evidence);
      });
    } catch (e) {
      _showSnackBar("Error uploading: $e");
    }
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.surface,
            ),
          ),
        ),
        backgroundColor: success ? AppColors.board2 : AppColors.board1,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Stream<List<Evidences>> fetchEvidences(String userId) {
    return _db.collection('evidences')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Evidences.fromFirestore(doc))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date)));
  }

  Future<void> verifyEvidence(Evidences evidence) async {
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
        await _treeService.increaseDrops(evidence.userId, evidence.point);

        // Send notification to the user immediately (no need for delay)
        await _notificationService.sendNotificationToUser(
          notificationId: evidence.evidenceId,
          receiverUserId: evidence.userId,
          title: 'Your Evidence Was Approved!',
          body: 'You earned ${evidence.point} points. Keep contributing for more rewards!',
          type: 'evidence',
        );

        debugPrint("📈 Updating challenge progress...");

        // Update challenge progress for "evidence" and the weekly task progress
        await Future.wait([
          ChallengeService().updateChallengeProgress('evidence', evidence.point),
          ChallengeService().updateWeeklyProgressForTasks(evidence.userId, 'evidence', category: evidence.category.toLowerCase())
        ]);

        debugPrint("✅ Challenge progress update done!");
      }

    } catch (e) {
      debugPrint("Error verifying evidence: $e");
    }
  }

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

  Stream<Map<String, int>> getTotalEachAcceptedCategory(String userId) {
    return _db.collection('evidences')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Accepted')
        .snapshots()
        .map((querySnapshot) {
      Map<String, int> categoryCount = {};

      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String category = data['category'];

        categoryCount[category] = (categoryCount[category] ?? 0) + 1;
      }

      return categoryCount;
    });
  }

  Stream<int> getTotalEvidences(String userId) {
    return _db.collection('evidences')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'Accepted')
        .snapshots()
        .map((querySnapshot) => querySnapshot.size);
  }

  Future<Evidences> getEvidenceById(String evidenceId) async {
    return _db.collection('evidences')
        .doc(evidenceId)
        .get()
        .then((doc) {
      if (doc.exists) {
        return Evidences.fromFirestore(doc);
      } else {
        throw Exception("Evidence not found");
      }
    });
  }
}