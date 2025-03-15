import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordResetService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      // Check if the email exists in Firebase
      await _auth.sendPasswordResetEmail(email: email);
      return true; // Successfully sent the email
    } catch (e) {
      // Handle errors
      print("Error sending password reset email: $e");
      return false; // Failed to send the email
    }
  }
}
