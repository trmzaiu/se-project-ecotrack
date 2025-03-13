import 'package:flutter/material.dart';
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
              bottom: 60,
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
                    // Title
                    Text(
                      "Get Your Code",
                      style: GoogleFonts.urbanist(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
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
                      ),
                    ),
                    SizedBox(height: 24),

                    // 4 Digit Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.secondary),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              fillColor: AppColors.surface,
                              filled: true,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 3) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(context)
                                    .requestFocus(_focusNodes[index - 1]);
                              }
                            },
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
                            color: AppColors.secondary,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: "Send again",
                              style: GoogleFonts.urbanist(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Confirm Button
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, '/forgot-password');
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
