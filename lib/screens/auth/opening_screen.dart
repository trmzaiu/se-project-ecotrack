import 'package:flutter/material.dart';
import 'package:wastesortapp/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/screens/auth/login_screen.dart';

import '../../../theme/fonts.dart';
import '../../utils/route_transition.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({Key? key}) : super(key: key);

  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> with SingleTickerProviderStateMixin {
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

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      moveRightRoute(
        LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);
    double phoneHeight = getPhoneHeight(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(height: phoneHeight/6),
          // Waste Sorting Image
          Center(
            child: RotationTransition(
              turns: _controller,
              child: Image.asset(
                "lib/assets/images/opening.png",
                width: phoneWidth - 10,
              ),
            ),
          ),

          // Welcome Text
          SizedBox(
            width: phoneWidth - 60,
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

          SizedBox(height: phoneHeight/12),

          // "Getting Started" Button
          ElevatedButton(
            onPressed: _navigateToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              ),
              fixedSize: Size(phoneWidth - 60, 55),
            ),
            child: Text(
              "Getting started",
              style: GoogleFonts.urbanist(
                color: AppColors.surface,
                fontSize: 18,
                fontWeight: AppFontWeight.semiBold
              ),
            ),
          ),
        ],
      ),
    );
  }
}
