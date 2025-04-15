import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../service/auth_service.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/my_button.dart';
import '../../widget/my_textfield.dart';
class ForgotPasswordSheet extends StatefulWidget {
  final VoidCallback onNext;

  const ForgotPasswordSheet({required this.onNext, Key? key}) : super(key: key);

  @override
  _ForgotPasswordSheetState createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<ForgotPasswordSheet> {
  final AuthenticationService _authService = AuthenticationService();
  final TextEditingController emailController = TextEditingController();

  int _secondsRemaining = 90;
  Timer? _timer;
  bool _canResend = true;
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _emailSent = false;
    });
  }


  @override
  void dispose() {
    _timer?.cancel();
    emailController.dispose();
    setState(() {
      _emailSent = false;
    });
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 90;
      _canResend = false;
    });

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendMail(BuildContext context) {
    if (_canResend) {
      _startCountdown();
    }
    sendEmail(context);
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  Future<void> sendEmail(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog(context, "Please enter your email address");
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorDialog(context, "Invalid email format");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await _authService.sendPasswordResetEmail(email);

      setState(() => _isLoading = false);

      if (success) {
        setState(() {
          _emailSent = true;
        });
        _showSuccessDialog(context, "Email sent successfully");
      } else {
        _showErrorDialog(context, "Fail to send email");
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, "Incorrect email");
    } finally {
      setState(() => _isLoading = false);
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

            Text(
              "Mail Address Here",
              style: GoogleFonts.urbanist(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 5),

            Text(
              "Please enter your email address to \nreceive a verification link.",
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.tertiary,
              ),
              textAlign: TextAlign.center,
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

            SizedBox(height: 10),

            Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Didn't receive email? ",
                      style: GoogleFonts.urbanist(
                        color: AppColors.tertiary,
                        fontSize: 14,
                      ),
                    ),

                    TextSpan(
                      text: _canResend
                          ? "Send again"
                          : _formatTime(_secondsRemaining),
                      style: GoogleFonts.urbanist(
                          color: _canResend
                              ? emailController.text.trim().isEmpty ? Colors.grey : AppColors.secondary
                              : Colors.grey,
                          fontSize: 15,
                          fontWeight: _canResend
                              ? AppFontWeight.bold
                              : AppFontWeight.semiBold
                      ),
                      recognizer: _canResend
                          ? emailController.text.trim().isEmpty ? null : (TapGestureRecognizer()..onTap = () { FocusScope.of(context).unfocus(); _resendMail(context);})
                          : null,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: 330,
              child: MyButton(
                text:  _isLoading ? 'Loading...' : 'Send',
                onTap: (_isLoading || _emailSent)
                    ? () {}
                    : () {
                      FocusScope.of(context).unfocus();
                      sendEmail(context);
                    },
                isDisabled: _emailSent || emailController.text.trim().isEmpty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}