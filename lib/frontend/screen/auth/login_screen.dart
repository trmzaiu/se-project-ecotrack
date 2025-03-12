import 'package:flutter/material.dart';
import 'package:wastesortapp/components/circle_tile.dart';
import 'package:wastesortapp/components/my_textfield.dart';
import 'package:wastesortapp/frontend/screen/auth/register_screen.dart';
import 'package:wastesortapp/frontend/screen/home/home_screen.dart';
import 'package:wastesortapp/main.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/service/google_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  void signUserIn() {
    // Implement login logic here
  }

  void signInWithGoogle(BuildContext context) async {
    UserCredential? userCredential = await _googleAuthService.signInWithGoogle();
    if (userCredential != null) {
      String userId = userCredential.user?.uid ?? '';
      // Navigate to home or dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(userId: userId)),
      );
    } else {
      print("Google Sign-In Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
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
                        image: AssetImage("lib/assets/images/trash.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),

             // Centered Column for Login Form & Register Text
            Positioned(
              top: 210,
              left: 20,
              right: 20,
              child: Container(
                width: 370,
                padding: EdgeInsets.all(24),
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
                          color: AppColors.secondary),
                    ),
                    SizedBox(height: 20),

                    MyTextField(
                      controller: usernameController,
                      hintText: "Email",
                      obscureText: false,
                    ),
                    SizedBox(height: 20),

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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
                          );
                        },
                        child: Text(
                          "Forgot your password?",
                          style: GoogleFonts.urbanist(color: AppColors.secondary),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    GestureDetector(
                      onTap: signUserIn,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          style: GoogleFonts.urbanist(
                              color: AppColors.surface,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
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
                            "Or sign in with",
                            style: GoogleFonts.urbanist(color: AppColors.secondary),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.secondary, thickness: 1)),
                      ],
                    ),
                    SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => signInWithGoogle(context),
                          child: CircleTile(imagePath: 'lib/assets/icons/icons8-google.svg'),
                        ),
                        SizedBox(width: 30),
                        CircleTile(imagePath: 'lib/assets/icons/icons8-facebook.svg'),
                        SizedBox(width: 30),
                        CircleTile(imagePath: 'lib/assets/icons/icons8-apple.svg'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // "Don't have an account? Register"
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? ",
                          style: GoogleFonts.urbanist(color: AppColors.primary),
                        ),
                        TextSpan(
                          text: "Register",
                          style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
