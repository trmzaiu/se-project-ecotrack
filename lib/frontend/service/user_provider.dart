// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// class UserProvider with ChangeNotifier {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FacebookAuth _facebookAuth = FacebookAuth.instance;
//   static UserProvider? _instance;
//   factory UserProvider() => _instance ??= UserProvider._internal();
//
//   UserProvider._internal();
//
//   static UserProvider get instance => _instance!;
//
//   String? _userId;
//
//   String? get userId => _userId;
//
//   void setUserId(String userId) {
//     _userId = userId;
//     notifyListeners();
//   }
//
//   Future<void> signOut() async {
//     try {
//       await Future.wait([
//         _firebaseAuth.signOut(),
//         _googleSignIn.signOut(),
//         _facebookAuth.logOut(),
//       ]);
//       _userId = null;
//       notifyListeners();
//     } catch (e) {
//       throw Exception("Sign-out failed. Please try again.");
//     }
//   }
// }
