import 'package:flutter/material.dart';
import 'package:wastesortapp/components/square_tile.dart';
import 'package:wastesortapp/components/my_button.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() {
    // Implement login logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Background with Image
              Container(
                width: 414,
                height: 396,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 370,
                    height: 370,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage("https://placehold.co/370x370"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),
              

              // Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Label
                    // Text(
                    //   'Email',
                    //   style: TextStyle(
                    //     color: AppColors.tertiary,
                    //     fontSize: 14,
                    //     fontFamily: 'Urbanist',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    SizedBox(height: 8),

                    // Email Input Field
                    Container(
                      width: 330,
                      height: 49,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: InputBorder.none,
                          hintText: "Enter your email",
                          hintStyle: TextStyle(color: AppColors.tertiary),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Password Label
                    // Text(
                    //   'Password',
                    //   style: TextStyle(
                    //     color: Color(0xFF9C9385),
                    //     fontSize: 14,
                    //     fontFamily: 'Urbanist',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // SizedBox(height: 8),

                    // Password Input Field
                    Container(
                      width: 330,
                      height: 49,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: InputBorder.none,
                          hintText: "Enter your password",
                          hintStyle: TextStyle(color: AppColors.tertiary),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot your password?',
                        style: TextStyle(
                          color: Color(0x7F7C3F3E),
                          fontSize: 14,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Login Button
                    GestureDetector(
                      onTap: signUserIn,
                      child: Container(
                        width: 330,
                        height: 49,
                        decoration: ShapeDecoration(
                          color: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: AppColors.primary),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 18,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            height: 1.11,
                            letterSpacing: -0.23,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // "Or sign in with" Divider
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            color: AppColors.secondary,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Or sign in with',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: AppColors.secondary,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Social login buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(imagePath: 'assets/images/google.png'),
                        SizedBox(width: 45.47),
                        SquareTile(imagePath: 'assets/images/apple.png'),
                        SizedBox(width: 45.47),
                        SquareTile(imagePath: 'assets/images/facebook.png'),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Register Text
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(color: AppColors.primary),
                              ),
                              TextSpan(
                                text: "Register",
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
