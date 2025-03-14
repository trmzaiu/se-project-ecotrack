// authentication.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // Stream to track user authentication state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  String? get userId => _firebaseAuth.currentUser?.uid;
  // Sign in with email and password
  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return "Invalid email address.";
        case 'user-not-found':
          return "No account found with this email.";
        case 'wrong-password':
          return "Incorrect password.";
        default:
          return "Error: ${e.message}";
      }
    } catch (e) {
      return "Error: An unexpected error occurred";
    }
  }

  // Register with email and password
  Future<String> register({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return "Invalid email address.";
        case 'email-already-in-use':
          return "Email is already in use.";
        case 'weak-password':
          return "Password is too weak.";
        default:
          return "Error: ${e.message}";
      }
    } catch (e) {
      return "Error: An unexpected error occurred";
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Reset password
  Future<String> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "Success";
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return "Invalid email address.";
        case 'user-not-found':
          return "No account found with this email.";
        default:
          return "Error: ${e.message}";
      }
    } catch (e) {
      return "Error: An unexpected error occurred";
    }
  }
}