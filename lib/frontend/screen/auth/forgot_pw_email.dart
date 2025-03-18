import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastesortapp/frontend/screen/auth/opening_screen.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/auth_service.dart';


class ForgotPasswordScreenMail extends StatefulWidget {
  ForgotPasswordScreenMail({super.key});

  final emailController = TextEditingController();
  @override
  _ForgotPasswordScreenMailState createState() =>
      _ForgotPasswordScreenMailState();
}

class _ForgotPasswordScreenMailState extends State<ForgotPasswordScreenMail> {
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);

  String _errorMessage = "";

  void resetPassword() async {
    String email = widget.emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorMessage = "Please enter your email address.";
      });
      return;
    }

    bool success = await _authService.sendPasswordResetEmail(email);

    if (success) {
      // Navigate to next screen if email is sent
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OpeningScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "Failed to send password reset link. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Column(
              children: [
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    image: DecorationImage(
                      image: AssetImage("lib/assets/images/reset_password.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Reset Password Form
          Positioned(
            width: 414,
            height: 800,
            bottom: -100,
            child: Container(
              width: 400,
              padding: EdgeInsets.all(32),
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
                  Container(
                    width: 90,
                    height: 3.5,
                    decoration: ShapeDecoration(
                      color: Color(0xFF7C3F3E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Mail Address Here",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please enter your email address to receive a reset password link.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: widget.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _errorMessage.isEmpty ? null : _errorMessage,
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: resetPassword,
                    child: Container(
                      width: 330,
                      height: 49,
                      decoration: ShapeDecoration(
                        color: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Continue",
                        style: GoogleFonts.urbanist(
                            color: AppColors.surface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      "Back to Login",
                      style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
