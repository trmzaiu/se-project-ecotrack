import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wastesortapp/frontend/screen/auth/opening_screen.dart';
import 'package:wastesortapp/frontend/screen/auth/register_screen.dart';
import 'package:wastesortapp/frontend/screen/auth/reset_password_sheet.dart';
import 'package:wastesortapp/frontend/screen/auth/verify_code_sheet.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/frontend/widget/my_button.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../../main.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/my_textfield.dart';
import '../../widget/square_tile.dart';
import 'forgot_password_sheet.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:wastesortapp/frontend/service/internet_checker_provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isFacebookLoading = false;
  bool _isShowSheet = false;
  int _currentSheetState = 0;

  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, "Email or password is empty");
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorDialog(context, "Invalid email format");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.signIn(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _navigateToMainScreen(context, user.uid);
      }
    } on FirebaseAuthException catch (e) {
      _showErrorDialog(context, "Incorrect email or password");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setState(() => _isGoogleLoading = true);

    try {
      await _authService.signInWithGoogle();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _navigateToMainScreen(context, user.uid);
      } else {
        _showErrorDialog(context, "Google Sign-In failed.");
      }
    } on FirebaseAuthException {
      _showErrorDialog(context, "Google Sign-In error.");
    } finally {
      setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    setState(() => _isFacebookLoading = true);

    try {
      await _authService.signInWithFacebook();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _navigateToMainScreen(context, user.uid);
      } else {
        _showErrorDialog(context, "Facebook Sign-In failed.");
      }
    } on FirebaseAuthException {
      _showErrorDialog(context, "Facebook Sign-In error.");
    } finally {
      setState(() => _isFacebookLoading = false);
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$").hasMatch(email);
  }

  void _navigateToMainScreen(BuildContext context, String userId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen(userId: userId)),
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

  void _toggleSheet(BuildContext context, int state) {
    if (_isShowSheet) return;

    setState(() {
      _isShowSheet = true;
      _currentSheetState = state;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildSheet(state);
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _isShowSheet = false;
        });
      }
    });
  }

  Widget _buildSheet(int state) {
    switch (state) {
      case 0:
        return ForgotPasswordSheet(onNext: () {
          Navigator.pop(context);
          Future.delayed(Duration(milliseconds: 200), () {
            _toggleSheet(context, 1);
          });
        });
      case 1:
        return VerifyCodeSheet(onNext: () {
          Navigator.pop(context);
          Future.delayed(Duration(milliseconds: 200), () {
            _toggleSheet(context, 2);
          });
        });
      case 2:
        return ResetPasswordSheet(onNext: () {
          Navigator.pop(context);
        });
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    double phoneHeight= getPhoneHeight(context);
    // Provider.of<InternetCheckerProvider>(context, listen: false).setContext(context);

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
                  child: !_isShowSheet ?
                    Center(
                      child: Image.asset(
                        "lib/assets/images/trash.png", width: 370,
                      ),
                    ) :
                    Center()
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
                    "Login",
                    style: GoogleFonts.urbanist(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary
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
                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        _toggleSheet(context, 0);
                      },
                      child: Text(
                        "Forgot your password?",
                        style: GoogleFonts.urbanist(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: AppFontWeight.regular
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  MyButton(
                    text: _isLoading ? 'Loading...' : 'Login',
                    onTap: () => signIn(context),
                    isDisabled: _isLoading ? true : false,
                  ),

                  SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(child: Divider(color: AppColors.secondary, thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "or sign in with",
                          style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 13,
                              fontWeight: AppFontWeight.medium
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.secondary, thickness: 1)),
                    ],
                  ),
                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => signInWithGoogle(context),
                        child: SquareTile(imagePath: 'lib/assets/icons/icons8-google.svg', isLoading: _isGoogleLoading),
                      ),
                      SizedBox(width: 50),
                      GestureDetector(
                        onTap: () => signInWithFacebook(context),
                        child: SquareTile(imagePath: 'lib/assets/icons/icons8-facebook.svg', isLoading: _isFacebookLoading),
                      ),
                      SizedBox(width: 50),
                      SquareTile(imagePath: 'lib/assets/icons/icons8-apple.svg'),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            top: phoneHeight - 55,
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.urbanist(
                        color: AppColors.primary,
                        fontSize: 14,
                      )
                    ),
                    TextSpan(
                      text: "Register",
                      style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 15,
                        fontWeight: AppFontWeight.bold
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
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
