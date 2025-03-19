import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastesortapp/frontend/screen/user/edit_profile.dart';
import 'package:wastesortapp/frontend/screen/user/notification_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
//import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';

import '../../service/auth_service.dart';


class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.secondary,
            fontSize: 18,
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        backgroundColor: AppColors.background,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Picture
              Container(
                width: 126,
                height: 125,
                decoration: ShapeDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: AssetImage("lib/assets/images/user_placeholder.png"),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(
                    side: BorderSide(
                      width: 5,
                      color: AppColors.tertiary,
                    )
                  )
                ),
              ),
              SizedBox(height: 16),

              // User ID
              Text(
                'Gwen Stacy',
                style: TextStyle(
                  color: const Color(0xFF7C3F3E),
                  fontSize: 24,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),

              // Email (Example)
              Text(
                '@GwenStacy31',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF7C3F3E),
                  fontSize: 16,
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 24),

              // Edit Profile
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                  );
                  // Handle edit profile logic
                },
                child: Container(
                  width: 135,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF2C6E49),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Edit Profile',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFFFFCFB),
                          fontSize: 13,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25),

              SizedBox(
                width: 328,
                height: 39,
                child: Text(
                  'Statistics',
                  style: TextStyle(
                    color: const Color(0xFF7C3F3E),
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Align(
                alignment: Alignment.center, // Change this to adjust alignment (e.g., .centerLeft, .topCenter)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Adjusts spacing between the columns
                  children: [
                    Column(
                      children: [
                        Text(
                          '56',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 20,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Drops',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '4',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 20,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Trees',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '14',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 20,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Evidences',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 16,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),


              SizedBox(
                width: 328,
                height: 39,
                child: Text(
                  'History',
                  style: TextStyle(
                    color: const Color(0xFF7C3F3E),
                    fontSize: 22,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 20,),

              //haza
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 155,
                  height: 155,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0x197C3F3E),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'lib/assets/images/hazard.png',
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(height: 8),

                          SizedBox(
                            width: 94.31,
                            height: 36.25,
                            child: Text(
                              'Hazardous \nWaste',
                              style: TextStyle(
                                color:const Color(0xFF7C3F3E),
                                fontSize: 15,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.28,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                        height: 62.21,
                        child: Text(
                          '22',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Subtitle
                      Text(
                        'Times',
                        style: TextStyle(
                          color: Color(0xFF7C3F3E),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Organic
              Align(
                alignment: Alignment.bottomLeft,
               child: Container(
                width: 155,
                height: 155,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0x197C3F3E),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'lib/assets/images/organic.png',
                          width: 35,
                          height: 35,
                        ),
                        SizedBox(height: 8),

                        SizedBox(
                          width: 94.31,
                          height: 36.25,
                          child: Text(
                            'Organic \nWaste',
                            style: TextStyle(
                              color:const Color(0xFF7C3F3E),
                              fontSize: 15,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.28,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),


                    SizedBox(
                      width: 40,
                      height: 62.21,
                    child: Text(
                      '22',
                      style: TextStyle(
                        color: Color(0xFF7C3F3E),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ),


                    // Subtitle
                    Text(
                      'Times',
                      style: TextStyle(
                        color: Color(0xFF7C3F3E),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              ),

              //general
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 155,
                  height: 155,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0x197C3F3E),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'lib/assets/images/general.png',
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(height: 8),

                          SizedBox(
                            width: 94.31,
                            height: 36.25,
                            child: Text(
                              'General \nWaste',
                              style: TextStyle(
                                color:const Color(0xFF7C3F3E),
                                fontSize: 15,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.28,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),



                      SizedBox(
                        width: 40,
                        height: 62.21,
                        child: Text(
                          '22',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),


                      // Subtitle
                      Text(
                        'Times',
                        style: TextStyle(
                          color: Color(0xFF7C3F3E),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //recycle
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 155,
                  height: 155,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0x197C3F3E),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'lib/assets/images/recycle.png',
                            width: 35,
                            height: 35,
                          ),
                          SizedBox(height: 8),

                          SizedBox(
                            width: 94.31,
                            height: 36.25,
                            child: Text(
                              'Recycle \nWaste',
                              style: TextStyle(
                                color:const Color(0xFF7C3F3E),
                                fontSize: 15,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.28,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40,
                        height: 62.21,
                        child: Text(
                          '22',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Subtitle
                      Text(
                        'Times',
                        style: TextStyle(
                          color: Color(0xFF7C3F3E),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),







              // Sign Out Button
              GestureDetector(
                onTap: () => _signOut(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}