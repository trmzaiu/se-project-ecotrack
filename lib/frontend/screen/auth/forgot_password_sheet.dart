import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';
import '../../service/auth_service.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/my_textfield.dart';
import '../../widget/section_tile.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';
class ForgotPasswordSheet extends StatefulWidget {
  final VoidCallback onNext;

  const ForgotPasswordSheet({required this.onNext, Key? key}) : super(key: key);

  @override
  _ForgotPasswordSheetState createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> sendEmail(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim();
      if (email.isEmpty) throw "Please enter your email address.";
      print('Email: $email');
      // if (!_isValidEmail(email)) throw "The email is in invalid format!";

      final success = await _authService.sendPasswordResetEmail(email);

      setState(() => _isLoading = false);

      if (success) {
        // _showSuccessDialog(context, "Please check your email!");
      } else {
        throw "Failed to send password reset email!";
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        message: message,
        status: false,
        buttonTitle: "Try Again",
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        message: message,
        status: true,
        buttonTitle: "Ok",
      ),
    );
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
              title: "Mail Address Here",
              description: "Please enter your email address to \nreceive a verification code.",
              text: _isLoading ? 'Loading...' : 'Continue',
              onSubmit: _isLoading
                  ? () {}
                  : () async {
                await sendEmail(context);
                widget.onNext();
              },
              children: [
                SizedBox(
                  width: 330,
                  child: MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
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
