import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastesortapp/database/model/user.dart';
import 'package:email_otp/email_otp.dart';

import '../widget/custom_dialog.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? get userId => _firebaseAuth.currentUser?.uid;

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        message: message,
        status: false,
        buttonTitle: "Try Again",
      ),
    );
  }

  Future<bool> signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      // Check email, password empty
      if (email.isEmpty || password.isEmpty) {
        _showErrorDialog(context, "Email and password cannot be empty.");
        return false;
      }

      // Check valid email
      if (!_isValidEmail(email)) {
        _showErrorDialog(context, "The email address is in an invalid format!");
        return false;
      }

      // Check exist email
      // List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      // if (signInMethods.isEmpty) {
      //   _showErrorDialog(context, "No account found with this email.");
      //   return false;
      // }

      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      // Check password
      _showErrorDialog(context, _handleFirebaseAuthException(e));
      return false;
    } catch (e) {
      _showErrorDialog(context, "An unexpected error occurred");
      return false;
    }
  }

  Future<String?> signUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      saveUserToFirestore(uid: userCredential.user!.uid, name: userCredential.user!.uid, email: email);

      return null;
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e);
    } catch (e) {
      return "An unexpected error occurred";
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await saveUserToFirestore(
          uid: user.uid,
          name: user.displayName ?? "Unknown",
          email: user.email ?? "",
        );
      }

      return userCredential;
    } catch (e) {
      throw Exception("Google Sign-In failed. Please try again later.");
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      User? user = userCredential.user;

      if (user != null) {
        final userData = await FacebookAuth.instance.getUserData();
        await saveUserToFirestore(
          uid: user.uid,
          name: userData['name'] ?? "Unknown",
          email: user.email ?? "",
        );
      }

      return userCredential;
    } catch(e) {
      throw Exception("Facebook Sign-In failed. Please try again later.");
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _facebookAuth.logOut();
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<void> saveUserToFirestore({
    required String uid,
    required String name,
    required String email,
  }) async {
    final userDocRef = _firestore.collection('users').doc(uid);
    final docSnapshot = await userDocRef.get();

    if (!docSnapshot.exists) {
      // If user does not exist, create a new record
      await userDocRef.set({
        'uid': uid,
        'name': name,
        'email': email,
        'dob': DateTime.now().toIso8601String(),
        'photoUrl': "https://res.cloudinary.com/dosqd0oni/image/upload/v1742131075/anonymous-user_n2vxh0.png",
        'region': "Viet Nam",
        'water': 0,
        'tree': 0
      });
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      EmailOTP.config(
        appName: 'EcoTrack',
        otpType: OTPType.numeric,
        expiry : 30000,
        emailTheme: EmailTheme.v6,
        appEmail: 'wastesortapp@gmail.com',
        otpLength: 4,
      );

      bool result = await EmailOTP.sendOTP(email: email);
      if (result) {
        print("OTP sent successfully!");
        return true;
      } else {
        print("Failed to send OTP.");
        return false;
      }
    } catch (e) {
      // Handle errors
      print("Error sending password reset email: $e");
      return false;
    }
  }

  String _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "Invalid email address.";
      case 'user-not-found':
        return "No account found with this email.";
      case 'wrong-password':
        return "Incorrect password.";
      case 'email-already-in-use':
        return "Email is already in use.";
      case 'weak-password':
        return "Password is too weak.";
      case 'network-request-failed':
        return "Network error. Please try again.";
      default:
        return "Error: ${e.message}";
    }
  }
}
