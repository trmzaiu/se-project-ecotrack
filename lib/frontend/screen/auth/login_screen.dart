import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wastesortapp/frontend/screen/auth/register_screen.dart';
import 'package:wastesortapp/frontend/service/authentication.dart';
import 'package:wastesortapp/frontend/screen/home/home_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../widget/my_textfield.dart';
import '../../../main.dart';
import '../../service/google_auth_service.dart';
import '../../widget/square_tile.dart';
import 'forgot_pw_email.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  void signUserIn(BuildContext context) async {
    final authService = AuthenticationService(FirebaseAuth.instance);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate email format
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(email)) {
      _showErrorDialog(context, "Invalid Email", "Please enter a valid email address.");
      return;
    }

    if (password.isEmpty) {
      _showErrorDialog(context, "Invalid Password", "Password cannot be empty.");
      return;
    }

    // Attempt login
    try {
      String result = await authService.signIn(email: email, password: password);
      if (result == "Success") {
        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(userId: userId)),
        );
      } else {
        _showErrorDialog(context, "Login Failed", result);
      }
    } catch (e) {
      _showErrorDialog(context, "Login Error", "An unexpected error occurred: $e");
    }
  }

  void signInWithGoogle(BuildContext context) async {
    UserCredential? userCredential = await _googleAuthService
        .signInWithGoogle();
    if (userCredential != null) {
      String userId = userCredential.user?.uid ?? '';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(userId: userId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In Failed")),
      );
    }
    try {
      UserCredential? userCredential = await _googleAuthService.signInWithGoogle();
      if (userCredential != null) {
        String userId = userCredential.user?.uid ?? '';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: userId)),
        );
      } else {
        _showErrorDialog(context, "Google Sign-In Failed", "Please try again.");
      }
    } catch (e) {
      _showErrorDialog(context, "Google Sign-In Error", "An error occurred: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
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
                    onTap: () => signUserIn(context),
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
                      SquareTile(imagePath: 'lib/assets/icons/icons8-facebook.svg'),
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
