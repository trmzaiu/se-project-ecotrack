import 'package:flutter/material.dart';
import 'package:wastesortapp/components/my_textfield.dart';
import 'package:wastesortapp/frontend/screen/auth/forgot_pw_code.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
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
                ), //cucuucucu
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
                      "Please enter your email address to receive a verification code.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),

                    ),
                    SizedBox(height: 30),

                    Container(
                      width: 330,
                      height: 49,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 330,
                              height: 49,
                              decoration: ShapeDecoration(
                                color: Color(0xFFFFFCFB),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 18.33,
                            top: 16,
                            child: SizedBox(
                              width: 148.50,
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: Color(0xFF9C9385),
                                  fontSize: 16,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => VerificationScreen()),
                        );
                      },
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
                        Navigator.push(context,
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
      ),
    );
  }
}