import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';

import '../../../theme/fonts.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 100));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => LoginScreen(),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: 120),
          // Waste Sorting Image
          Center(
            child: RotationTransition(
              turns: _controller,
              child: Image.asset(
                "lib/assets/images/opening.png",
                height: 380,
              ),
            ),
          ),

          // Welcome Text
          SizedBox(
            width: 330,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello.",
                  style: GoogleFonts.urbanist(
                      fontSize: 36,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.secondary
                  ),
                ),
                Text(
                  "Welcome back!",
                  style: GoogleFonts.urbanist(
                      fontSize: 36,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.secondary
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 60),

          // "Getting Started" Button
          GestureDetector(
            onTap: _navigateToLogin,
            child: Container(
              width: 330,
              height: 55,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text(
                "Getting started",
                style: GoogleFonts.urbanist(
                  color: AppColors.surface,
                  fontSize: 18,
                  fontWeight: AppFontWeight.semiBold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
