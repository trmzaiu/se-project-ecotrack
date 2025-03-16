import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wastesortapp/frontend/screen/auth/register_screen.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../../main.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/my_textfield.dart';
import '../../widget/square_tile.dart';
import 'forgot_pw_email.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog(context, "Empty Email", "Please enter your email address to continue. This field cannot be left blank.");
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorDialog(context, "Invalid Email", "The email address you entered is not in the correct format. Please check and try again.");
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog(context, "Empty Password", "Please enter your password to continue. This field cannot be left blank.");
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.signIn(email: email, password: password);

    setState(() => _isLoading = false);

    if (result != null) {
      _showErrorDialog(context, "Login Error", result);
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _navigateToMainScreen(context, user.uid);
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signInWithGoogle();

      setState(() => _isLoading = false);

      if (userCredential?.user != null) {
        _navigateToMainScreen(context, userCredential!.user!.uid);
      } else {
        _showErrorDialog(context, "Google Sign-In Failed", "Please try again.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(context, "Google Sign-In Error", "An error occurred: $e");
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signInWithFacebook();

      setState(() => _isLoading = false);

      if (userCredential.user != null) {
        _navigateToMainScreen(context, userCredential.user!.uid);
      } else {
        _showErrorDialog(context, "Facebook Sign-In Failed", "Please try again.");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(context, "Facebook Sign-In Error", "An error occurred: $e");
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  void _navigateToMainScreen(BuildContext context, String userId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(userId: userId)),
    );
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        message: message,
        buttonTitle: "Try Again",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneHeight= getPhoneHeight(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Center(
                    child: Image.asset(
                      "lib/assets/images/trash.png", width: 370,
                    ),
                  )
                ),
              ],
            ),
          ),

          Positioned(
            top: 180,
            right: 20,
            left: 20,
            child: Container(
              width: 370,
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Login",
                    style: GoogleFonts.urbanist(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary
                    ),
                  ),
                  SizedBox(height: 20),

                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  SizedBox(height: 25),

                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreenMail()),
                        );
                      },
                      child: Text(
                        "Forgot your password?",
                        style: GoogleFonts.urbanist(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: AppFontWeight.regular
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  GestureDetector(
                    onTap: () => signIn(context),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Login",
                        style: GoogleFonts.urbanist(
                            color: AppColors.surface,
                            fontSize: 18,
                            fontWeight: AppFontWeight.bold
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.secondary, thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "or sign in with",
                          style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 13,
                              fontWeight: AppFontWeight.medium
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.secondary, thickness: 1)),
                    ],
                  ),
                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => signInWithGoogle(context),
                        child: SquareTile(imagePath: 'lib/assets/icons/icons8-google.svg'),
                      ),
                      SizedBox(width: 50),
                      GestureDetector(
                        onTap: () => signInWithFacebook(context),
                        child: SquareTile(imagePath: 'lib/assets/icons/icons8-facebook.svg'),
                      ),
                      SizedBox(width: 50),
                      SquareTile(imagePath: 'lib/assets/icons/icons8-apple.svg'),
                    ],
                  ),
                  SizedBox(height: 13),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: phoneHeight - 55,
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.urbanist(
                        color: AppColors.primary,
                        fontSize: 14,
                      )
                    ),
                    TextSpan(
                      text: "Register",
                      style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 15,
                        fontWeight: AppFontWeight.bold
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
