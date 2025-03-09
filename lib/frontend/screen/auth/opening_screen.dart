import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class OpeningScreen extends StatelessWidget {
  const OpeningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Waste Sorting Image
            Expanded(
              child: Center(
                child: Image.asset(
                  "lib/assets/images/logo.png",
                  width: 250,
                ),
              ),
            ),

            // Welcome Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Hello.",
                    style: GoogleFonts.urbanist(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary),
                  ),
                  Text(
                    "Welcome back!",
                    style: GoogleFonts.urbanist(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // "Getting Started" Button
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/login'); // Navigate to login page
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
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
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 50), 
          ],
        ),
      ),
    );
  }
}
