import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';
import '../widget/custom_dialog.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TreeService _treeService = TreeService();
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

  // Function sign in with email & password
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  // Function sign up with email & password
  Future<String?> signUp({required String email, required String password}) async {
    try {
      if (!_isValidEmail(email)) {
        return "Invalid email format";
      }

      // if (!_isValidPassword(password)) {
      //   return "Password must be at least 8 characters long and include uppercase, lowercase, a number, and a special character.";
      // }

      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      print("User registered with UID: \${userCredential.user!.uid}"); // Debugging

      await saveUserInformation(userId: userCredential.user!.uid, name: userCredential.user!.uid, email: email);
      print("User saved to Firestore"); // Debugging

      await _treeService.createTree(userCredential.user!.uid);

      return null;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: \${e.code}"); // Debugging
      return "Error";
    } catch (e) {
      print("Unexpected error during sign-up: \$e"); // Debugging
      return "An unexpected error occurred";
    }
  }

  // Function sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseAuthException(code: 'sign-in-cancelled', message: 'Google Sign-In was cancelled.');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        await saveUserInformation(
          userId: user.uid,
          name: user.displayName ?? user.uid.substring(0, 10),
          email: user.email ?? "",
        );
      }
      await _treeService.createTree(userCredential.user!.uid);

    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  // Function sign in with Facebook
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status != LoginStatus.success || loginResult.accessToken == null) {
        throw FirebaseAuthException(code: 'sign-in-cancelled', message: 'Facebook Sign-In was cancelled.');
      }

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      User? user = userCredential.user;

      if (user != null) {
        final userData = await FacebookAuth.instance.getUserData();
        await saveUserInformation(
          userId: user.uid,
          name: userData['name'] ?? user.uid.substring(0, 10),
          email: user.email ?? "",
        );
      }

      await _treeService.createTree(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  // Function sign out
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
    } catch (e) {
      throw Exception("Sign-out failed. Please try again.");
    }
  }

  // Save user information to Firebase
  Future<void> saveUserInformation({
    required String userId,
    required String name,
    required String email,
  }) async {
    final userDocRef = _firestore.collection('users').doc(userId);

    await userDocRef.set(
      {
        'userId': userId,
        'name': name,
        'email': email,
        'dob': DateTime.now().toIso8601String(),
        'photoUrl': "",
        'country': "",
      },
      SetOptions(merge: true),
    );
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      EmailOTP.config(
        appName: 'EcoTrack',
        otpType: OTPType.numeric,
        expiry : 150000,
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

}

