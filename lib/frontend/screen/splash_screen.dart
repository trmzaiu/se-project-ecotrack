import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:wastesortapp/main.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../utils/route_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool showLogo = false;
  bool showEco = false;
  bool showTrack = false;
  double trackOffsetX = 3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutExpo,
      ),
    );

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        showLogo = true;
      });
    }

    _controller.forward();

    await Future.delayed(Duration(milliseconds: 1000));

    if (mounted) {
      setState(() {
        showEco = true;
      });
    }

    await Future.delayed(Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        showTrack = true;
        trackOffsetX = 0;
      });
    }

    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pushReplacement(
      moveUpRoute(
        MainScreen(),
      ),
    );
  }

  // Future<void> _checkLoginStatus() async {
  //   await Future.delayed(Duration(seconds: 0));
  //
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (mounted) {
  //     Future.microtask(() {
  //       Navigator.of(context).pushReplacement(
  //         moveUpRoute(
  //           user != null ? MainScreen() : OpeningScreen(),
  //         ),
  //       );
  //     });
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('SplashScreen built');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: showLogo ? 1.0 : 0.0,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'lib/assets/images/logo.png',
                  height: 200,
                ),
              ),
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: Duration(milliseconds: 500),
                  scale: showEco ? 1.0 : 0.0,
                  child: Stack(
                    children: [
                      Text(
                        'Eco',
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 40,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: AppColors.secondary.withOpacity(0.60),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        'Eco',
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 40,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 2,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = AppColors.background,
                        ),
                      ),

                      Text(
                        'Eco',
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 40,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                ),

                AnimatedSlide(
                  duration: Duration(milliseconds: 600),
                  offset: Offset(trackOffsetX, 0),
                  curve: Curves.easeOutExpo,
                  child: Stack(
                    children: [
                      Text(
                        'Track',
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 40,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: AppColors.secondary.withOpacity(0.60),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        'Track',
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 40,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 2,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 2
                            ..color = AppColors.background,
                        ),
                      ),

                      Text(
                        'Track',
                        style: GoogleFonts.aDLaMDisplay(
                          fontSize: 40,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 2,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}