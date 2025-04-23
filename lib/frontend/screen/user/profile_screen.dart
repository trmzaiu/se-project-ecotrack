import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/database/model/challenge.dart';
import 'package:wastesortapp/frontend/screen/challenge/weekly_challenge_screen.dart';
import 'package:wastesortapp/frontend/screen/user/setting_screen.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import 'package:wastesortapp/frontend/widget/bar_title.dart';
import 'package:wastesortapp/main.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../../database/model/user.dart';
import '../../service/challenge_service.dart';
import '../../service/user_service.dart';

import '../../service/evidence_service.dart';
import '../../service/tree_service.dart';
import '../challenge/challenge_detail_screen.dart';
import '../challenge/community_challenge_card.dart';
import '../challenge/community_challenge_screen.dart';
import '../challenge/weekly_challenge_progress_card.dart';
import '../evidence/evidence_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<void> _signOut(BuildContext context) async {
    await AuthenticationService().signOut();
    Navigator.of(context).pushReplacement(
      moveLeftRoute(
        MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);
    print("Height: ${getPhoneHeight(context)}");
    print("Width: ${getPhoneWidth(context)}");

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BarTitle(title: "Profile", textColor: AppColors.secondary, showNotification: true),

          const SizedBox(height: 25),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 25),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  StreamBuilder<Users?>(
                    stream: UserService().getCurrentUser(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const SizedBox();
                      }

                      final user = snapshot.data;

                      return Column(
                        children: [
                          CircleAvatar(
                            radius: 62.5,
                            backgroundColor: AppColors.tertiary.withOpacity(0.5),
                            child: CircleAvatar(
                              radius: 59,
                              backgroundImage: user!.photoUrl != ''
                                  ? CachedNetworkImageProvider(user.photoUrl) as ImageProvider
                                  : AssetImage('lib/assets/images/avatar_default.png'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            user.name,
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 24,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),

                          Text(
                            user.email,
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

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        moveLeftRoute(
                          SettingScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      elevation: 0,
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

                  const SizedBox(height: 20),

                  Align(
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

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StreamBuilder<Map<String, int>>(
                          stream: TreeService().getUserDropsAndTrees(userId),
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
                          stream: TreeService().getUserDropsAndTrees(userId),
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
                          stream: EvidenceService(context).getTotalEvidences(userId),
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

                  const SizedBox(height: 10),

                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     'Weekly Goal',
                  //     textAlign: TextAlign.left,
                  //     style: GoogleFonts.urbanist(
                  //       color: AppColors.secondary,
                  //       fontSize: 20,
                  //       fontWeight: AppFontWeight.semiBold,
                  //     ),
                  //   ),
                  // ),
                  //
                  // const SizedBox(height: 10),

                  FutureBuilder<WeeklyChallenge>(
                    future: ChallengeService().loadWeeklyChallenge(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox();
                      } else if (snapshot.hasError) {
                        return SizedBox();
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return SizedBox();
                      } else {
                        final weeklyChallenge = snapshot.data!;
                        final goalPoints = weeklyChallenge.target;

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              moveLeftRoute(
                                  WeeklyChallengeScreen()
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent,
                                  offset: Offset(0, 0),
                                  blurRadius: 3
                                ),
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: WeeklyChallengeProgressCard(
                              userId: userId,
                              goalPoints: goalPoints,
                              margin: 0,
                              padding: 25,
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 25),

                  Row(
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
                          Navigator.of(context).pushAndRemoveUntil(
                            moveLeftRoute(EvidenceScreen(), settings: RouteSettings(name: "EvidenceScreen")),
                                (route) => route.settings.name != "UploadScreen" && route.settings.name != "EvidenceScreen" || route.isFirst,
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

                  const SizedBox(height: 10),

                  StreamBuilder<Map<String, int>>(
                    stream: EvidenceService(context).getTotalEachAcceptedCategory(userId),
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
                          Row(
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

                          SizedBox(height: phoneWidth - phoneWidth * 0.405 * 2 - 50),

                          Row(
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
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  FutureBuilder<List<CommunityChallenge>>(
                    future: ChallengeService().loadChallengesUserJoined(userId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox();
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return SizedBox();
                      }

                      final challenges = snapshot.data!;
                      final limitedChallenges = challenges.take(2).toList();

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Your Challenges',
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
                                        CommunityChallengeScreen(index: 2)
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
                          const SizedBox(height: 10),

                          ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: limitedChallenges.length,
                            itemBuilder: (context, index) {
                              final challenge = limitedChallenges[index];
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      scaleRoute(
                                        ChallengeDetailScreen(challengeId: challenge.id),
                                      ),
                                    );
                                  },
                                  child: CommunityChallengeCard(challenge: challenge)
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 5),

                  ElevatedButton(
                    onPressed: () => _signOut(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      minimumSize: Size(phoneWidth - 60, 0),
                    ),
                    child: Text(
                      'Log out',
                      style: GoogleFonts.urbanist(
                        color: AppColors.surface,
                        fontSize: 16,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),
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
    double phoneWidth = getPhoneWidth(context);
    double containerSize = phoneWidth * 0.405;
    double paddingSize = phoneWidth * 0.04;

    return Container(
      width: phoneWidth * 0.41,
      height: phoneWidth * 0.41,
      padding: EdgeInsets.all(paddingSize),
      decoration: ShapeDecoration(
        color: Color(0x80EBDCD6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
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
                height: containerSize * 0.22,
                width: containerSize * 0.22,
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

              SizedBox(width: paddingSize * 0.5),

              Text(
                title,
                style: GoogleFonts.urbanist(
                  color: AppColors.secondary,
                  fontSize: containerSize * 0.095,
                  fontWeight: AppFontWeight.regular,
                  letterSpacing: 0.8,
                  height: 1.2
                ),
              ),
            ],
          ),

          SizedBox(height: paddingSize * 0.5),

          Expanded(
            child: Text(
              time,
              style: GoogleFonts.urbanist(
                color: AppColors.secondary,
                fontSize: containerSize * 0.34,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          ),

          Text(
            time == '1' ? 'Time' : 'Times',
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: containerSize * 0.09,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        ],
      ),
    );
  }
}