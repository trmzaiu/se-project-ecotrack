import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../widget/my_button.dart';
import '../../widget/my_textfield.dart';

class ForgotPasswordSheet extends StatelessWidget {
  final Function(String) onResetPassword;
  final TextEditingController emailController;

  ForgotPasswordSheet({
    Key? key,
    required this.onResetPassword,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, controller) => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 70),
            Text(
              "Mail Address Here",
              style: GoogleFonts.urbanist(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 292,
              child: Text(
                "Please enter your email address to receive a verification link.",
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: AppColors.tertiary
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 35),
            SizedBox(
              width: 330,
              child: MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: 330,
              child: MyButton(text: 'Continue', onTap: () => onResetPassword(emailController.text.trim())),
            ),
            SizedBox(height: 15), // Add space between button and "Resend" link
            GestureDetector(
              onTap: () => onResetPassword(emailController.text.trim()), // Handle resend email functionality
              child: Text(
                "Resend Verification Link",
                style: GoogleFonts.urbanist(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
