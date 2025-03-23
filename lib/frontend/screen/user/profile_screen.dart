import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
import 'package:wastesortapp/frontend/screen/user/setting_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import 'package:wastesortapp/frontend/widget/bar_title.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../service/user_service.dart';

import '../../service/auth_service.dart';
import '../evidence/evidence_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final fetchedUser = await getCurrentUser(widget.userId);
    setState(() {
      user = fetchedUser;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await AuthenticationService(FirebaseAuth.instance).signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    // If user data is not loaded yet, show a loading spinner
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BarTitle(
            title: "Profile",
            textColor: AppColors.secondary,
            showNotification: true,
          ),

          const SizedBox(height: 25),

          // Profile Image
          Container(
            width: 125,
            height: 125,
            decoration: ShapeDecoration(
              color: const Color(0xE0E0E0FF),
              image: DecorationImage(
                image: NetworkImage(user!['photoUrl']), // Use fetched user data
                fit: BoxFit.cover,
              ),
              shape: OvalBorder(
                side: BorderSide(
                  width: 5,
                  color: AppColors.tertiary.withOpacity(0.8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // Name
          Text(
            user!['name'],
            style: GoogleFonts.urbanist(
              color: AppColors.secondary,
              fontSize: 24,
              fontWeight: AppFontWeight.bold,
            ),
          ),

          // Email
          Text(
            user!['email'],
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: 16,
              fontWeight: AppFontWeight.regular,
            ),
          ),

          const SizedBox(height: 30),

          // Edit Profile Button
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                moveLeftRoute(
                  SettingScreen(),
                ),
              );
            },
            child: Container(
              width: 135,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: ShapeDecoration(
                color: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Edit Profile',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      color: AppColors.surface,
                      fontSize: 14,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Statistics Section
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statistic('Drops', user!['water']),
                _statistic('Trees', user!['tree']),
                _statistic('Evidences', user!['evidence']),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // Logout Button
          GestureDetector(
            onTap: () => _signOut(context),
            child: Container(
              width: phoneWidth - 60,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                'Log out',
                style: GoogleFonts.urbanist(
                  color: AppColors.surface,
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 35),
        ],
      ),
    );
  }

  // Widget for Statistics
  Widget _statistic(String title, String number) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.urbanist(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: AppFontWeight.semiBold,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: 16,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }
}
