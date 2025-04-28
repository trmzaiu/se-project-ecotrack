import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:wastesortapp/services/auth_service.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late AuthenticationService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late FakeFirebaseFirestore mockFirestore;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = FakeFirebaseFirestore();
    mockGoogleSignIn = MockGoogleSignIn();
    authService = AuthenticationService.test(
      auth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
  });

  group('App Authentication', () {
    test('should sign up successfully with email and password', () async {
      final email = 'test@example.com';
      final password = 'test1234';

      await authService.signUp(email: email, password: password);
      final user = mockFirebaseAuth.currentUser;

      expect(user, isNotNull);

      final userDoc = await mockFirestore.collection('users').doc(user!.uid).get();
      expect(userDoc.exists, true);
    });

    test('should sign in successfully with email and password', () async {
      final email = 'test@example.com';
      final password = 'test1234';

      await authService.signUp(email: email, password: password);
      await authService.signIn(email: email, password: password);

      final user = mockFirebaseAuth.currentUser;
      expect(user!.email, equals(email));
    });

    test('should return valid idToken and accessToken when authenticating via Google', () async {
      final signInAccount = await mockGoogleSignIn.signIn();
      final signInAuthentication = await signInAccount!.authentication;

      expect(signInAuthentication, isNotNull);
      expect(mockGoogleSignIn.currentUser, isNotNull);
      expect(signInAuthentication.accessToken, isNotNull);
      expect(signInAuthentication.idToken, isNotNull);
    });

    test('should return null when Google login is cancelled by the user', () async {
      mockGoogleSignIn.setIsCancelled(true);
      final signInAccount = await mockGoogleSignIn.signIn();

      expect(signInAccount, isNull);
    });

    test('should handle Google login attempts, cancelled first, then successful', () async {
      mockGoogleSignIn.setIsCancelled(true);
      final signInAccount = await mockGoogleSignIn.signIn();
      expect(signInAccount, isNull);

      mockGoogleSignIn.setIsCancelled(false);
      final signInAccountSecondAttempt = await mockGoogleSignIn.signIn();
      expect(signInAccountSecondAttempt, isNotNull);
    });

    test('should sign out successfully and clear the current user', () async {
      final email = 'test@example.com';
      final password = 'test1234';

      await authService.signUp(email: email, password: password);
      await authService.signOut();

      expect(mockFirebaseAuth.currentUser, isNull);
    });

    test('should send password reset email successfully', () async {
      final result = await authService.sendPasswordResetEmail("test@example.com");

      expect(result, true);
    });

    test('should return null when Google sign in is cancelled by user', () async {
      mockGoogleSignIn.setIsCancelled(true);

      final signInAccount = await mockGoogleSignIn.signIn();
      expect(signInAccount, isNull);
    });
  });
}
