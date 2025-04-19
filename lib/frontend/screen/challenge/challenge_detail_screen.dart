import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../theme/colors.dart';
import '../../service/challenge_service.dart';
import '../../service/user_service.dart';
import '../auth/login_screen.dart';
import '../../widget/custom_dialog.dart';
import '../../utils/route_transition.dart';
import '../tree/virtual_tree_screen.dart';
import 'daily_challenge_screen.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String challengeId;

  const ChallengeDetailScreen({super.key, required this.data, required this.challengeId});

  @override
  _ChallengeDetailScreenState createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.surface,
            ),
          ),
        ),
        backgroundColor: AppColors.board2,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDuration(DateTime endTime) {
    final now = DateTime.now();
    final remaining = endTime.difference(now);
    if (remaining.isNegative) return "Challenge ended";
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;
    final minutes = remaining.inMinutes % 60;
    return "$days d $hours h $minutes m left";
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
    final image = widget.data['image'] ?? '';
    final title = widget.data['title'] ?? 'No title';
    final description =widget.data['description'] ?? 'No description';
    final reward = widget.data['rewardPoints'] ?? 0;
    final target = widget.data['targetValue'] ?? 1000;
    final progress = widget.data['progress'] ?? 0;
    final subtype = widget.data['subtype'] ?? '';
    final participants = (widget.data['participants'] as List?)?.length ?? 0;
    final Timestamp endTimestamp = widget.data['endDate'];
    final endTime = endTimestamp.toDate();

    final progressRatio = (progress / target).clamp(0.0, 1.0);
    final percentage = (progressRatio * 100).toStringAsFixed(2);

    return Scaffold(
      body: Container(
        height: double.infinity,
        color: AppColors.background,
        child: SingleChildScrollView(
          child:  Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: getPhoneWidth(context) * 6/7,
                    width: double.infinity,
                    child: Image.asset('lib/assets/images/$image.png', fit: BoxFit.cover),
                  ),

                  Positioned(
                    top: 25,
                    left: 15,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: SvgPicture.asset(
                            'lib/assets/icons/ic_close.svg',
                            width: 45,
                            height: 45,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  )
                ],
              ),

              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: UserService().getUsersByIds(List<String>.from(widget.data['participants'] ?? [])),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox();
                        }

                        final users = snapshot.data!;
                        final displayUsers = users.take(3).toList();

                        return Row(
                          children: [
                            SizedBox(
                              width: 12*(displayUsers.length+1),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: List.generate(displayUsers.length, (index) {
                                  final user = displayUsers[index];
                                  final avatar = Container(
                                    width: 25,
                                    height: 25,
                                    decoration: ShapeDecoration(
                                      shape: OvalBorder(
                                        side: BorderSide(width: 1, color: AppColors.surface),
                                      ),
                                      image: DecorationImage(
                                        image: user['photoUrl'] != null && user['photoUrl'] != ''
                                            ? CachedNetworkImageProvider(user['photoUrl']) as ImageProvider
                                            : AssetImage('lib/assets/images/avatar_default.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );

                                  return index == 0
                                      ? avatar
                                      : Positioned(
                                    left: index * 15,
                                    child: avatar,
                                  );
                                }),
                              )
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                "$participants ${participants == 1 ? 'participant' : 'participants'}",
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: AppColors.secondary,
                                  fontWeight: AppFontWeight.regular,
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _formatDuration(endTime),
                                style: GoogleFonts.urbanist(
                                  fontSize: 14,
                                  color: AppColors.secondary,
                                  fontWeight: AppFontWeight.regular,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        style: GoogleFonts.urbanist(
                          fontSize: 42,
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.primary,
                          height: 1.2
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      description,
                      style: GoogleFonts.urbanist(
                        fontSize: 17,
                        color: AppColors.tertiary,
                        height: 1.2
                      ),
                    ),

                    const SizedBox(height: 20),

                    LinearProgressIndicator(
                      value: progressRatio,
                      minHeight: 10,
                      backgroundColor: AppColors.accent.withOpacity(0.6),
                      color: AppColors.primary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$progress / $target",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: AppColors.tertiary,
                            fontWeight: AppFontWeight.medium,
                          )
                        ),

                        Text("$percentage%",
                          style: GoogleFonts.urbanist(
                            fontSize: 14,
                            color: AppColors.tertiary,
                            fontWeight: AppFontWeight.medium,
                          )
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text("🎁  $reward points for successful completion",
                          style: GoogleFonts.urbanist(
                            fontWeight: AppFontWeight.medium,
                            fontSize: 14,
                            color: AppColors.secondary,
                          )
                        ),
                      )
                    ),

                    const SizedBox(height: 20),

                    StreamBuilder<bool>(
                      stream: ChallengeService().isUserJoined(widget.challengeId, userId),
                      builder: (context, snapshot) {
                        final isJoined = snapshot.data ?? false;

                        if (!isJoined) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (!_isUserLoggedIn()) {
                                  _showErrorDialog(context);
                                  return;
                                }

                                await ChallengeService().joinChallenge(widget.challengeId, userId);
                                _showSnackBar("You have joined the challenge!");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.surface,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Join",
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        if (subtype == 'form') {
                          return StreamBuilder<bool>(
                            stream: ChallengeService().checkSubmissionToday(widget.challengeId),
                            builder: (context, snapshot) {
                              final submittedToday = snapshot.data ?? false;

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: submittedToday
                                      ? null
                                      : () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          title: Text("Confirm Pledge"),
                                          content: const Text("Are you sure you didn’t use any single-use plastic today?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text("Submit"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm != true) return;

                                    await ChallengeService().submitChallenge(widget.challengeId, userId);
                                    await ChallengeService().updateChallengeProgress(widget.challengeId, 1);

                                    _showSnackBar("Pledge submitted successfully!");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.surface,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    submittedToday ? 'Already submitted today' : 'Submit Pledge',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        if (subtype == 'streak') {
                          return StreamBuilder<bool>(
                            stream: ChallengeService().hasCompletedToday(userId),
                            builder: (context, completedSnap) {
                              final isCompleted = completedSnap.data ?? false;

                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isCompleted
                                      ? null
                                      : () {
                                    Navigator.of(context).push(
                                      scaleRoute(const DailyChallengeScreen()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.surface,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    isCompleted ? 'Already completed today' : 'Start challenge',
                                    style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        if (subtype == 'evidence') {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  scaleRoute(UploadScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.surface,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Start challenge',
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        if (subtype == 'tree') {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  scaleRoute(VirtualTreeScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.surface,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Start challenge',
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }

                        // Default return widget to prevent the 'null' return error
                        return SizedBox.shrink();
                      },
                    ),

                    FutureBuilder<bool>(
                      future: ChallengeService().checkChallengeDeadline(widget.challengeId),
                      builder: (context, snapshot) {
                        final isExpired = snapshot.data ?? false;

                        return SizedBox(
                          width: double.infinity,
                          child: isExpired
                              ? Center(
                                child: Text(
                                  "This challenge is no longer available",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: AppFontWeight.medium,
                                    color: AppColors.tertiary,
                                  ),
                                )
                              )
                              : null
                        );
                      },
                    ),
                  ],
                )
              )
            ],
          ),
        )
      )

    );
  }
}
