import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wastesortapp/components/my_textfield.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // RegisterScreen({super.key});

  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  // final confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validate email structure
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}").hasMatch(email)) {
      _showErrorDialog("Invalid Email", "Please enter a valid email address.");
      return;
    }

    // Check password match
    if (password != confirmPassword) {
      _showErrorDialog("Password Mismatch", "Passwords do not match.");
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          _showErrorDialog("Registration Failed", "This email is already registered.");
          break;
        case 'weak-password':
          _showErrorDialog("Registration Failed", "The password is too weak.");
          break;
        default:
          _showErrorDialog("Registration Failed", e.message ?? "An unexpected error occurred.");
      }
    } catch (e) {
      _showErrorDialog("Registration Failed", "An unexpected error occurred. Please try again later.");
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
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
                        image: AssetImage("lib/assets/images/trash.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 210,
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
                        SizedBox(height: 20),

                        MyTextField(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                        ),
                        SizedBox(height: 20),

                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: true,
                    ),
                    SizedBox(height: 35),

                    GestureDetector(
                      onTap: signUp,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Create Account",
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
            Positioned(
              top: 810,
              left: 0,
              right: 0,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Already have an account? ",
                        style: GoogleFonts.urbanist(color: AppColors.primary),
                      ),
                      TextSpan(
                        text: "Login",
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
