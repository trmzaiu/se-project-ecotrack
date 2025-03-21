import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../database/CloudinaryConfig.dart';
import '../../database/model/evidence.dart';
import '../screen/evidence/evidence_screen.dart';

class EvidenceService{
  final BuildContext context;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EvidenceService(this.context);

  Future<void> submitData({
   List<File>? selectedImages,
   String? selectedCategory,
   TextEditingController? descriptionController,
   int totalPoint = 5,

  }) async {
    if (selectedImages!.isEmpty) {
      showSnackbar("No image selected.");
      return;
    }

    if (selectedCategory == null) {
      showSnackbar("Please select a category.");
      return;
    }

    try {
      List<String> uploadedImageUrls = [];

      for (File image in selectedImages) {
        String? imageUrl = await CloudinaryConfig().uploadImage(image);
        if (imageUrl != null) {
          uploadedImageUrls.add(imageUrl);
        }
      }

      if (uploadedImageUrls.isEmpty) {
        showSnackbar("Image upload failed.");
        return;
      } else if(uploadedImageUrls.length > 2){
        totalPoint += 5;
      }

      if(descriptionController != null && descriptionController.text.trim().isNotEmpty){
        totalPoint += 5;
      }

      String evidenceId = FirebaseFirestore.instance
          .collection('evidences')
          .doc()
          .id;

      Evidence evidence = Evidence(
        userId: FirebaseAuth.instance.currentUser!.uid,
        evidenceId: evidenceId,
        category: selectedCategory,
        imagesUrl: uploadedImageUrls,
        description: descriptionController?.text.trim(),
        date: DateTime.now(),
        status: "Pending",
        point: totalPoint,
      );

      await FirebaseFirestore.instance
          .collection('evidences')
          .doc(evidenceId)
          .set(evidence.toMap());

      showSnackbar("Upload successful!", success: true);

      Future.delayed(Duration(milliseconds: 500), () {
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EvidenceScreen()),
                (route) => false,
          );
        }
      });
    } catch (e) {
      showSnackbar("Error uploading: $e");
    }
  }

  void showSnackbar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Stream<List<Evidence>> fetchEvidences(String userId) {
    return FirebaseFirestore.instance
        .collection('evidences')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Evidence.fromFirestore(doc))
          .toList()
          ..sort((a, b) => b.date.compareTo(a.date)));
  }
}