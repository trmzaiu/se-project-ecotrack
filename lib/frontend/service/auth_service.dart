import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';

import '../../database/model/user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TreeService _treeService = TreeService();

  /// Function sign in with email & password
  Future<void> signIn({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        await addToken(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Function sign up with email & password
  Future<void> signUp({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      await saveUserInformation(
        userId: userCredential.user!.uid,
        name: userCredential.user!.uid.substring(0, 10),
        email: email,
      );

      await addToken(userCredential.user!.uid);

      await _treeService.createTree(userCredential.user!.uid);
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Function sign in with Google
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

        await addToken(user.uid);
      }

      await _treeService.createTree(userCredential.user!.uid);

    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Function sign in with Facebook
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await _facebookAuth.login();
      if (loginResult.status != LoginStatus.success || loginResult.accessToken == null) {
        throw FirebaseAuthException(code: 'sign-in-cancelled', message: 'Facebook Sign-In was cancelled.');
      }

      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      User? user = userCredential.user;

      if (user != null) {
        final userData = await _facebookAuth.getUserData();
        await saveUserInformation(
          userId: user.uid,
          name: userData['name'] ?? user.uid.substring(0, 10),
          email: user.email ?? "",
        );

        await addToken(user.uid);
      }

      await _treeService.createTree(userCredential.user!.uid);

    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
    }
  }

  /// Update the user password
  Future<void> updateUserPassword(String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently logged in.');
    }
    await user.updatePassword(newPassword);
  }

  /// Sign out
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

  /// Save user information to Firebase
  Future<void> saveUserInformation({
    required String userId,
    required String name,
    required String email,
  }) async {
    final userDocRef = _firestore.collection('users').doc(userId);

    Users user = Users(
      userId: userId,
      name: name,
      email: email,
      dob: DateTime.now(),
      photoUrl: "",
      country: "",
      completedDailyDate: null,
      completedWeekly: false,
      streak: 0,
      weekLog: "",
      weekProgress: 0,
      weekTasks: [],
    );

    await userDocRef.set(
      user.toMap(),
      SetOptions(merge: true),
    );
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      // Handle errors
      print("Error sending password reset email: $e");
      return false;
    }
  }

  /// Add fcm token
  Future<void> addToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      // First, check if the document exists
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        // If the document exists, update the fcmToken field
        await _firestore.collection('users').doc(userId).update({
          'fcmToken': token,
        });
        print('✅ FCM token updated for user $userId');
      } else {
        // If the document doesn't exist, set the document with fcmToken
        await _firestore.collection('users').doc(userId).set({
          'fcmToken': token,
        });
        print('✅ FCM token set for new user $userId');
      }
    }
  }
}
