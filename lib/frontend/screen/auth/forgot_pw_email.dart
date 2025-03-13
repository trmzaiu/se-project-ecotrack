import 'package:flutter/material.dart';
import 'package:wastesortapp/components/my_textfield.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreenMail extends StatelessWidget {
  ForgotPasswordScreenMail({super.key});

  final emailController = TextEditingController();

  void resetPassword() {
    // Implement password reset logic here
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
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
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
              bottom: 150,
              left: 20,
              right: 20,
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
                    Text(
                      "Mail Address Here",
                      style: GoogleFonts.urbanist(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary),
                    ),
                    SizedBox(height: 16),

                    Text(
                      "Please enter your email address to receive a verification code.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(color: AppColors.secondary),
                    ),
                    SizedBox(height: 30),

                    MyTextField(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),
                    SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/otp');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
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
                      onTap: () => Navigator.pushNamed(context,'/login'),
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
      ),
    );
  }
}