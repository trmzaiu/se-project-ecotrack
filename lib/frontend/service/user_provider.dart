import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  String? userId;

  UserProvider() {
    _loadUser();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      userId = user?.uid;
      notifyListeners();
    });
  }

  void _loadUser() {
    userId = FirebaseAuth.instance.currentUser?.uid;
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
        _facebookAuth.logOut(),
      ]);
      userId = null;
      notifyListeners();
    } catch (e) {
      throw Exception("Sign-out failed. Please try again.");
    }
  }
}
