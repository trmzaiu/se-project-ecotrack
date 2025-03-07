import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:wastesortapp/main.dart';
import 'package:wastesortapp/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        debugPrint('Navigating to HomeScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SplashScreen built');

    return Scaffold(
      backgroundColor: Color(0xFFF7EEE7),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/assets/images/logo.png',
                height: 200,
              ),
              SizedBox(height: 10),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    'EcoTrack',
                    style: GoogleFonts.aDLaMDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Color(0xFF7C3F3E).withOpacity(0.60),
                        ),
                      ],
                    ),
                  ),
                  // Chữ nền (mờ)
                  Text(
                    'EcoTrack',
                    style: GoogleFonts.aDLaMDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2
                        ..color = AppColors.background,
                    ),
                  ),

                  // Chữ chính (nổi bật)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Eco',
                          style: GoogleFonts.aDLaMDisplay(
                            color: Color(0xFF2C6E49),
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                        ),
                        TextSpan(
                          text: 'Track',
                          style: GoogleFonts.aDLaMDisplay(
                            color: Color(0xFF7C3F3E),
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
