import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/service/challenge_service.dart';

import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../utils/phone_size.dart';
import '../../utils/route_transition.dart';
import '../../widget/bar_title.dart';
import '../../widget/custom_dialog.dart';
import '../auth/login_screen.dart';
import 'challenge_detail_screen.dart';

class CommunityChallengeScreen extends StatefulWidget {
  @override
  _CommunityChallengeScreenState createState() => _CommunityChallengeScreenState();
}

class _CommunityChallengeScreenState extends State<CommunityChallengeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        color: AppColors.secondary,
        child: Column(
          children: [
            BarTitle(title: 'Challenge', showBackButton: true),

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
                        children: List.generate(2, (index) {
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
                                    ["Weekly", "Community"][index],
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

                    const SizedBox(height: 15),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          _buildTabContent("weekly"),
                          _buildTabContent("community"),
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

Widget _buildTabContent(String type) {
  return StreamBuilder<QuerySnapshot>(
    stream: ChallengeService().loadChallenges(type),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text(
            'No $type challenges available.',
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              color: AppColors.secondary,
              fontSize: 16,
              fontWeight: AppFontWeight.medium,
            ),
          ),
        );
      }

      final challenges = snapshot.data!.docs;

      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final doc = challenges[index];
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChallengeDetailScreen(data: data, challengeId: data['id']),
                ),
              );
            },
            child: CommunityChallengeCard(data: data)
          );
        },
      );
    },
  );
}

class CommunityChallengeCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const CommunityChallengeCard({super.key, required this.data});

  @override
  State<CommunityChallengeCard> createState() => _CommunityChallengeCardState();
}

class _CommunityChallengeCardState extends State<CommunityChallengeCard> {
  late DateTime endTime;
  late Duration remainingTime;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    Timestamp endTimestamp = widget.data['endDate'];
    endTime = endTimestamp.toDate();

    final now = DateTime.now();
    final diff = endTime.difference(now);
    remainingTime = diff.isNegative ? Duration.zero : diff;

    _startCountdown();
  }

  void _startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final diff = endTime.difference(now);
      setState(() {
        remainingTime = diff.isNegative ? Duration.zero : diff;
      });
    });
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    if (d == Duration.zero) return "Challenge ended";
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  bool _isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        message: 'Please log in to upload evidence.',
        status: false,
        buttonTitle: "Login",
        isDirect: true,
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            moveUpRoute(
              LoginScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.data['title'] ?? '';
    final description = widget.data['description'] ?? '';
    final progress = (widget.data['progress'] ?? 0);
    final target = (widget.data['targetValue'] ?? 1000);

    final progressRatio = (progress / target).clamp(0.0, 1.0);
    final percentage = (progressRatio * 100).toStringAsFixed(2);

    final challengeId = widget.data['id'] as String? ?? '';
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: GoogleFonts.urbanist(
              fontSize: 24,
              fontWeight: AppFontWeight.bold,
              color: AppColors.secondary,
            )
          ),

          const SizedBox(height: 5),

          Text(description,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              color: AppColors.tertiary,
            )
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progressRatio,
                  minHeight: 8,
                  backgroundColor: AppColors.accent.withOpacity(0.6),
                  color: AppColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              const SizedBox(width: 8),

              Text("$percentage%",
                style: GoogleFonts.urbanist(
                  fontSize: 13,
                  color: AppColors.tertiary,
                  fontWeight: AppFontWeight.medium,
                )
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(remainingTime),
                style: GoogleFonts.urbanist(
                  color: remainingTime == Duration.zero ? AppColors.tertiary : Color(0xFFC62828),
                  fontWeight: AppFontWeight.medium,
                ),
              ),

              StreamBuilder<bool>(
                stream: ChallengeService().isUserJoined(challengeId, userId),
                builder: (context, snapshot) {
                  final isJoined = snapshot.data ?? false;

                  return SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!_isUserLoggedIn()) {
                          _showErrorDialog(context);
                          return;
                        }

                        if (!isJoined) {
                          await ChallengeService().joinChallenge(challengeId, userId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("You have joined the challenge!")),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isJoined ? AppColors.accent : AppColors.primary,
                        foregroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        isJoined ? "Joined" : "Join",
                        style: GoogleFonts.urbanist(
                          fontSize: 15,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
