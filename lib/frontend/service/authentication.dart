import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // Stream to track user authentication state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Sign in with email and password
  Future<String> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Success"; // Standardized return value
    } on FirebaseAuthException catch (e) {
      return "Error: ${e.message}"; // Ensure consistent error messages
    } catch (e) {
      return "Error: An unexpected error occurred"; // Handle other exceptions
    }
  }

  // Register with email and password
  Future<String> register({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Success"; // Standardized return value
    } on FirebaseAuthException catch (e) {
      return "Error: ${e.message}";
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
      return "Error: ${e.message}";
    } catch (e) {
      return "Error: An unexpected error occurred";
    }
  }
}
