import 'package:flutter/material.dart';
import 'package:wastesortapp/frontend/screen/auth/forgot_password_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationScreen extends StatefulWidget {
  VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  void verifyCode() {
    String code = _controllers.map((e) => e.text).join();
    print("Entered code: $code");
    // Add logic to verify the code
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 3) {
        _focusNodes[index].unfocus();
        _focusNodes[index + 1].requestFocus(); // Move to next box
      } else {
        _focusNodes[index].unfocus(); // Last digit, remove focus
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        _focusNodes[index].unfocus();
        _focusNodes[index - 1].requestFocus(); // Go back to previous box
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Positioned.fill(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Verification Form
            Positioned(
              bottom: -100,
              width: 414,
              height: 800,
              child: Container(
                width: 400,
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
                    SizedBox(height: 50),// Title
                    Text(
                      "Get Your Code",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Subtitle
                    Text(
                      "Please enter the 4-digit code sent to your email address.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 24),

                    // Digit Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.tertiary, width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFFFFCFB),
                          ),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              counterText: "", // Remove counter below input field
                              border: InputBorder.none, // Remove default border
                            ),
                            onChanged: (value) => _onChanged(index, value),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 20),

                    // Resend Code
                    TextButton(
                      onPressed: () {
                        // Add logic to resend code
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Didn't receive the code? ",
                          style: GoogleFonts.urbanist(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: "Send again",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.bold,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Confirm Button cuu toi
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> ForgotPasswordScreen()),
                        );
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
                          "Verify",
                          style: GoogleFonts.urbanist(
                            color: AppColors.surface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
