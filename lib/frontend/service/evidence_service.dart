import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../ScanAI/processImage.dart';
import '../../database/CloudinaryConfig.dart';
import '../../database/model/evidence.dart';
import '../screen/camera/camera_screen.dart';
import '../screen/evidence/evidence_screen.dart';
import '../screen/user/profile_screen.dart';
import '../utils/route_transition.dart';

class EvidenceService{
  final BuildContext context;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TreeService _treeService = TreeService();

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

      for (String imageUrl in evidence.imagesUrl) {
        File imageFile = await _downloadImage(imageUrl);
        String? predictedCategory = await ApiService.classifyImage(imageFile);

        if (predictedCategory == null || predictedCategory != evidence.category) {
          allMatched = false;
          break;
        }
      }

      String newStatus = allMatched ? "Accepted" : "Rejected";
      await _db.collection('evidences').doc(evidence.evidenceId).update({'status': newStatus});

      if (newStatus == "Accepted") {
        debugPrint("📝 Fetching treeId for user: ${evidence.userId}, ${evidence.point}");

        await _treeService.increaseDrops(evidence.userId, evidence.point);
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
}