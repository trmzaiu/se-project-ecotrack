import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:wastesortapp/components/my_textfield.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // RegisterScreen({super.key});

  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();
  // final confirmPasswordController = TextEditingController();

  Future<void> signUp() async {
    // if (passwordController.text != confirmPasswordController.text) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Mật khẩu xác nhận không trùng khớp')),
    //   );
    //   return;
    // }
    //
    // try {
    //   await _auth.createUserWithEmailAndPassword(
    //     email: emailController.text.trim(),
    //     password: passwordController.text.trim(),
    //   );
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Login successfully!')),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error: ${e.toString()}')),
    //   );
    // }
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
                    height: 370,
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

            // Centered Column for Registration Form & Login Text
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Registration Form
                  Container(
                    width: 350,
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
                              color: AppColors.secondary),
                        ),
                        SizedBox(height: 30),

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
                          hintText: "Confirm password",
                          obscureText: true,
                        ),
                        SizedBox(height: 30),

                        GestureDetector(
                          onTap: signUp,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Create Account",
                              style: GoogleFonts.urbanist(
                                  color: AppColors.surface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 60), // Space between registration form & login text

                  // "Already have an account? Login"
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: "Already have an account? ",
                              style: GoogleFonts.urbanist(color: AppColors.primary)),
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.urbanist(
                                color: AppColors.secondary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
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
