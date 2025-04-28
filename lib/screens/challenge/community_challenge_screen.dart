import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/services/challenge_service.dart';

import '../../../models/challenge.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../utils/phone_size.dart';
import '../../utils/route_transition.dart';
import '../../widgets/bar_title.dart';
import 'challenge_detail_screen.dart';
import 'community_challenge_card.dart';

class CommunityChallengeScreen extends StatefulWidget {
  final int index;

  CommunityChallengeScreen({this.index = 0});

  @override
  _CommunityChallengeScreenState createState() => _CommunityChallengeScreenState();
}

class _CommunityChallengeScreenState extends State<CommunityChallengeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length:  _isUserLoggedIn() ? 3 : 2, vsync: this, initialIndex: widget.index,);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool _isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body:
      Container(
        color: AppColors.secondary,
        child: Column(
          children: [
            BarTitle(title: 'Community Challenge', showBackButton: true),

            SizedBox(height: 30),

            Expanded(
              child: Container(
                color: AppColors.background,
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    Container(
                      width: getPhoneWidth(context) - 40,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: List.generate(_isUserLoggedIn() ? 3 : 2, (index) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tabController.index = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: _tabController.index == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: _tabController.index == index
                                      ? [
                                    BoxShadow(
                                      color: Color(0x0F101828),
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                    BoxShadow(
                                      color: Color(0x19101828),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ]
                                      : [],
                                ),
                                child: Center(
                                  child: Text(
                                    ['All', 'Active', 'Your'][index],
                                    style: GoogleFonts.urbanist(
                                      color: _tabController.index == index
                                          ? AppColors.primary
                                          : AppColors.tertiary,
                                      fontSize: 14,
                                      fontWeight: _tabController.index == index
                                          ? AppFontWeight.bold
                                          : AppFontWeight.regular,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildAllCommunityContent(),
                          _buildActiveCommunityContent(),
                          _buildUseJoinedContent(userId)
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        )
      )
      //
    );
  }
}

Widget _buildAllCommunityContent() {
  return FutureBuilder<List<CommunityChallenge>>(
      future: ChallengeService().loadCommunityChallenges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No challenges available.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          );
        }

        final challenges = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
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
        );
      }
  );
}

Widget _buildActiveCommunityContent() {
  return FutureBuilder<List<CommunityChallenge>>(
      future: ChallengeService().loadChallengesActive(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No active challenges available.',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          );
        }

        final challenges = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
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
        );
      }
  );
}

Widget _buildUseJoinedContent(String userId) {
    return FutureBuilder<List<CommunityChallenge>>(
      future: ChallengeService().loadChallengesUserJoined(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'You haven\'t joined any challenges yet',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          );
        }

        final challenges = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
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
        );
      },
    );
}
