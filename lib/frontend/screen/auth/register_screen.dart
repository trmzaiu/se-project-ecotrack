import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../main.dart';
import '../../../theme/fonts.dart';
import '../../utils/phone_size.dart';
import '../../utils/route_transition.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/my_button.dart';
import '../../widget/my_textfield.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> signUp(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (!_isValidEmail(email)) {
      _showErrorDialog(
        context,
        "The email address is invalid format!",
      );
      return;
    }

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog(
        context,
        "Please enter your password!",
      );
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog(
        context,
        "Your password is mismatch!",
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.signUp(email: email, password: password);

    setState(() => _isLoading = false);

    if (result != null) {
      _showErrorDialog(context, "Register Error: $result");
    } else {
      _showSuccessDialog(context, "Register Successfully");
    }
  }


  bool _isValidEmail(String email) {
    return RegExp(r"^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  void _navigateToMainScreen(BuildContext context, String userId) {
    Navigator.of(context).pushReplacement(
      moveUpRoute(
        MainScreen(userId: '',),
      ),
    );

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
        buttonTitle: "Continue",
        onPressed: () => _navigateToMainScreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneHeight= getPhoneHeight(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                    ),
                    child: Center(
                      child: Image.asset(
                        "lib/assets/images/trash.png", width: 370,
                      ),
                    )
                ),
              ],
            ),
          ),

          Positioned(
            top: 180,
            right: 20,
            left: 20,
            child: Container(
              width: 370,
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 24),
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
                    "Register",
                    style: GoogleFonts.urbanist(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                  SizedBox(height: 20),

                  MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  SizedBox(height: 25),

                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 25),

                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirm password",
                    obscureText: true,
                  ),
                  SizedBox(height: 50),

                  MyButton(text: 'Create Account', onTap: () => signUp(context)),

                  SizedBox(height: 15),
                ],
              ),
            ),
          ),

          Positioned(
            top: phoneHeight - 55,
            left: 0,
            right: 0,
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.urbanist(
                          color: AppColors.primary,
                          fontSize: 14,
                        )
                    ),
                    TextSpan(
                      text: "Login",
                      style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 15,
                          fontWeight: AppFontWeight.bold
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).pushReplacement(
                            moveUpRoute(
                              MainScreen(userId: '',),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}