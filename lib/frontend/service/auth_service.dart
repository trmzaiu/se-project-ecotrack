import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastesortapp/frontend/service/tree_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookAuth _facebookAuth = FacebookAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TreeService _treeService = TreeService();

  // Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  //
  // String? get userId => _firebaseAuth.currentUser?.uid;

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
  Future<void> signUp({required String email, required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      await saveUserInformation(
        userId: userCredential.user!.uid,
        name: userCredential.user!.uid.substring(0, 10),
        email: email,
      );

      await _treeService.createTree(userCredential.user!.uid);
    } on FirebaseAuthException {
      rethrow;
    } catch (_) {
      throw FirebaseAuthException(code: 'unexpected-error', message: 'Something went wrong.');
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
      // Check if the email exists in Firebase
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true; // Successfully sent the email
    } catch (e) {
      // Handle errors
      print("Error sending password reset email: $e");
      return false; // Failed to send the email
    }
  }

}
