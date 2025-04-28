import 'package:flutter/material.dart';
import 'package:wastesortapp/widgets/section_tile.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../widgets/my_textfield.dart';

class ResetPasswordSheet extends StatefulWidget {
  final VoidCallback onNext;

  const ResetPasswordSheet({required this.onNext, Key? key}) : super(key: key);

  @override
  _ResetPasswordSheetState createState() => _ResetPasswordSheetState();
}

class _ResetPasswordSheetState extends State<ResetPasswordSheet> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? errorMessage;

  void resetPassword() {
    setState(() {
      if (passwordController.text != confirmPasswordController.text) {
        errorMessage = "Passwords do not match";
      } else {
        errorMessage = null;
        // Proceed with password reset logic
        print("Password reset successful");
      }
    });
  }

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

            SectionTitle(
              title: "Enter New Password",
              description: "Your new password must be different \nfrom previously used password.",
              text: "Confirm",
              onSubmit: () {
                resetPassword();
                widget.onNext();
              },
              children: [
                SizedBox(
                  width: 330,
                  child: MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: 330,
                  child: MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm password",
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
