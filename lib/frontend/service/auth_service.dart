import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String? get userId => _firebaseAuth.currentUser?.uid;

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseAuthException(e);
    } catch (e) {
      return "An unexpected error occurred";
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
      // Check if the email exists in Firebase
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true; // Successfully sent the email
    } catch (e) {
      // Handle errors
      print("Error sending password reset email: $e");
      return false; // Failed to send the email
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
