import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wastesortapp/frontend/screen/auth/login_screen.dart';
import 'package:wastesortapp/frontend/screen/user/setting_screen.dart';
import 'package:wastesortapp/frontend/service/user_provider.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import 'package:wastesortapp/frontend/widget/bar_title.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../service/user_service.dart';

import '../../service/evidence_service.dart';
import '../../service/tree_service.dart';
import '../evidence/evidence_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId;
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          userId = Provider.of<UserProvider>(context, listen: false).userId;
        });
      }
    });
  }

  Future<void> _signOut(BuildContext context) async {
    await UserProvider().signOut();
    Navigator.of(context).pushReplacement(
      moveLeftRoute(
        LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userId = Provider.of<UserProvider>(context).userId;
    double phoneWidth = getPhoneWidth(context);
    print("Height: ${getPhoneHeight(context)}");
    print("Width: ${getPhoneWidth(context)}");

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BarTitle(title: "Profile", textColor: AppColors.secondary, showNotification: true),

          SizedBox(height: 25),

          FutureBuilder<Map<String, dynamic>>(
            future: UserService().getCurrentUser(userId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final user = snapshot.data ?? {
                'photoUrl': '',
                'name': userId!.substring(0, 10),
                'email': '',
              };

              return Column(
                children: [
                  Container(
                    width: 125,
                    height: 125,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: user['photoUrl'] != '' ? CachedNetworkImageProvider(user['photoUrl']) : AssetImage('lib/assets/images/avatar_default.png'),
                        fit: BoxFit.cover,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 5,
                          color: AppColors.tertiary.withOpacity(0.8),
                        )
                      )
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    user['name'],
                    style: GoogleFonts.urbanist(
                      color: AppColors.secondary,
                      fontSize: 24,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ),

                  Text(
                    user['email'],
                    style: GoogleFonts.urbanist(
                      color: AppColors.tertiary,
                      fontSize: 16,
                      fontWeight: AppFontWeight.regular,
                    ),
                  ),
                ]
              );
            }
          ),

          SizedBox(height: 30),

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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: ShapeDecoration(
                color: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
              child: Text(
                'Edit Profile',
                textAlign: TextAlign.center,
                style: GoogleFonts.urbanist(
                  color: AppColors.surface,
                  fontSize: 14,
                  fontWeight: AppFontWeight.semiBold,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  // SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Statistics',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 20,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamBuilder<Map<String, int>>(
                          stream: TreeService().getUserDropsAndTrees(userId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _statistic('Drops', '0');
                            }

                            Map<String, int> data = snapshot.data ?? {};
                            int drops = data['drops'] ?? 0;

                            return _statistic('Drops', drops.toString());
                          },
                        ),

                        StreamBuilder<Map<String, int>>(
                          stream: TreeService().getUserDropsAndTrees(userId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _statistic('Trees', '0');
                            }

                            Map<String, int> data = snapshot.data ?? {};
                            int trees = data['trees'] ?? 0;

                            return _statistic('Trees', trees.toString());
                          },
                        ),

                        StreamBuilder<int>(
                          stream: EvidenceService(context).getTotalEvidences(userId!),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return _statistic('Evidences', '0');
                            }

                            int totalAccepted = snapshot.data ?? 0;

                            return _statistic('Evidences', totalAccepted.toString());
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'History',
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 20,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                moveLeftRoute(
                                  EvidenceScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'See more',
                              style: GoogleFonts.urbanist(
                                color: AppColors.tertiary,
                                fontSize: 13,
                                fontWeight: AppFontWeight.regular,
                              ),
                            ),
                          )
                        ]
                    ),
                  ),

                  SizedBox(height: 10),

                  StreamBuilder<Map<String, int>>(
                    stream: EvidenceService(context).getTotalEachAcceptedCategory(userId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      Map<String, int> categoryCounts = snapshot.data ?? {
                        'Recyclable': 0,
                        'Organic': 0,
                        'Hazardous': 0,
                        'General': 0,
                      };

                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _history(
                                  context,
                                  'lib/assets/images/recycle.png',
                                  'Recyclable \nWaste',
                                  categoryCounts['Recyclable']?.toString() ?? '0',
                                ),
                                _history(
                                  context,
                                  'lib/assets/images/organic.png',
                                  'Organic \nWaste',
                                  categoryCounts['Organic']?.toString() ?? '0',
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: phoneWidth - phoneWidth * 0.82 - 60),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _history(
                                  context,
                                  'lib/assets/images/hazard.png',
                                  'Hazardous \nWaste',
                                  categoryCounts['Hazardous']?.toString() ?? '0',
                                ),
                                _history(
                                  context,
                                  'lib/assets/images/general.png',
                                  'General \nWaste',
                                  categoryCounts['General']?.toString() ?? '0',
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  SizedBox(height: 30),

                  GestureDetector(
                    onTap: () => _signOut(context),
                    child: Container(
                      width: phoneWidth - 60,
                      padding: EdgeInsets.symmetric(vertical: 15),
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
                      )
                    ),
                  ),

                  SizedBox(height: 35),
                ],
              ),
            )
          )
        ],
      )
    );
  }

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

  Widget _history(BuildContext context, String image, String title, String time) {
    return Container(
      width: getPhoneWidth(context) * 0.41,
      height: getPhoneWidth(context) * 0.41,
      padding: EdgeInsets.all(15),
      decoration: ShapeDecoration(
        color: Color(0x80EBDCD6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.tertiary.withOpacity(0.1),
            blurRadius: 2,
            offset: Offset(1, 2),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: getPhoneWidth(context) * 0.4 * 0.23,
                width: getPhoneWidth(context) * 0.4 * 0.23,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 10),

              Text(
                title,
                style: GoogleFonts.urbanist(
                  color: AppColors.secondary,
                  fontSize: getPhoneWidth(context) * 0.4 * 0.095,
                  fontWeight: AppFontWeight.regular,
                  letterSpacing: 1,
                  height: 1.2
                ),
              ),
            ],
          ),

          SizedBox(height: 5),

          Text(
            time,
            style: GoogleFonts.urbanist(
              color: AppColors.secondary,
              fontSize: getPhoneWidth(context) * 0.4 * 0.34,
              fontWeight: AppFontWeight.medium,
            ),
          ),

          Text(
            time == '1' ? 'Time' : 'Times',
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: getPhoneWidth(context) * 0.4 * 0.09,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }
}