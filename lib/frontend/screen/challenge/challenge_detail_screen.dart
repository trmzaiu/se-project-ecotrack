import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../main.dart';
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

  late DateTime startTime;
  late DateTime endTime;
  late Duration remainingTime;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();

    Timestamp startTimestamp = widget.data['startDate'];
    Timestamp endTimestamp = widget.data['endDate'];

    startTime = startTimestamp.toDate();
    endTime = endTimestamp.toDate();

    final now = DateTime.now();

    // Check if the challenge hasn't started yet or if it's already ongoing
    if (now.isBefore(startTime)) {
      // Show countdown until the challenge starts
      remainingTime = startTime.difference(now);
    } else if (now.isBefore(endTime)) {
      // Show countdown until the challenge ends
      remainingTime = endTime.difference(now);
    } else {
      remainingTime = Duration.zero; // The challenge has ended
    }

    // Start the countdown timer
    _startCountdown();
  }

  void _startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      if (now.isBefore(startTime)) {
        setState(() {
          remainingTime = startTime.difference(now);
        });
      } else if (now.isBefore(endTime)) {
        setState(() {
          remainingTime = endTime.difference(now);
        });
      } else {
        setState(() {
          remainingTime = Duration.zero;
        });
      }
    });
  }

  String _formatDuration(Duration d) {
    if (d == Duration.zero) return "Challenge ended";

    if (d.inDays >= 1) {
      return "${d.inDays} ${d.inDays == 1 ? 'day' : 'days'}";
    } else if (d.inHours >= 1) {
      return "${d.inHours} ${d.inHours == 1 ? 'hour' : 'hours'}";
    } else if (d.inMinutes >= 1) {
      return "${d.inMinutes} ${d.inMinutes == 1 ? 'minute' : 'minutes'}";
    } else {
      return "${d.inSeconds} ${d.inSeconds == 1 ? 'second' : 'seconds'}";
    }
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
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
        backgroundColor: !isError ? AppColors.board2 : AppColors.board1,
        duration: Duration(seconds: 2),
      ),
    );
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
    final target = widget.data['targetValue'] ?? 0;
    final progress = widget.data['progress'] ?? 0;
    final participants = (widget.data['participants'] as List?)?.length ?? 0;

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
                              width: 13*(displayUsers.length+1),
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
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: remainingTime == Duration.zero ? '' : startTime.isAfter(DateTime.now()) ? 'Start in ' : 'End in ',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        color: AppColors.secondary,
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                    ),

                                    TextSpan(
                                      text: _formatDuration(remainingTime),
                                      style: GoogleFonts.urbanist(
                                        fontSize: 14,
                                        color: remainingTime == Duration.zero ? AppColors.tertiary : Color(0xFFC62828),
                                        fontWeight: AppFontWeight.semiBold,
                                      ),
                                    ),
                                  ]
                                )
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

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('challenges').doc(widget.challengeId).get(),
                          builder: (context, challengeSnap) {
                            if (!challengeSnap.hasData) return CircularProgressIndicator();

                            final data = challengeSnap.data!.data() as Map<String, dynamic>;
                            final startDate = (data['startDate'] as Timestamp).toDate();
                            final endDate = (data['endDate'] as Timestamp).toDate();
                            final subtype = data['subtype'] as String? ?? '';
                            final now = DateTime.now();
                            final question = data['question'] as String? ?? '';
                            final progress = data['progress'] ?? 0;
                            final target = data['targetValue'] ?? 100;
                            final rewardedUsers = List<String>.from(data['rewardedUsers'] ?? []);
                            final claimedReward = rewardedUsers.contains(userId);

                            final isComingSoon = now.isBefore(startDate);
                            final isExpired = now.isAfter(endDate);
                            final isActive = !isComingSoon && !isExpired;

                            if (!isJoined) {
                              if (isComingSoon || isExpired) {
                                String label = isComingSoon ? 'Coming Soon' : 'This challenge is no longer available';
                                return _buildLabel(label);
                              }

                              return _buildJoinButton();
                            }

                            if (!isActive) {
                              return _buildLabel("This challenge is no longer available");
                            }

                            if (progress == target) {
                              return FutureBuilder<bool>(
                                future: ChallengeService().hasUserContributedToChallenge(widget.challengeId, userId),
                                builder: (context, contribSnapshot) {
                                  if (!contribSnapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  final hasContributed = contribSnapshot.data!;

                                  return ElevatedButton(
                                    onPressed: claimedReward
                                        ? null
                                        : () async {
                                      if (!hasContributed) {
                                        _showSnackBar('Cannot claim without contribution', isError: true);
                                        return;
                                      }

                                      await ChallengeService().rewardChallengeContributors(widget.challengeId, userId);
                                      _showSnackBar('Reward claimed successfully!');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: claimedReward ? AppColors.accent : AppColors.primary,
                                      foregroundColor: AppColors.surface,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      minimumSize: const Size(200, 0),
                                    ),
                                    child: Text(
                                      claimedReward ? 'Claimed' : 'Claim',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: AppFontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            switch (subtype) {
                              case 'form':
                                return _buildFormSubmitButton(question);
                              case 'streak':
                                return _buildStreakButton();
                              case 'evidence':
                                return _buildNavigationButton(UploadScreen(), "Start challenge");
                              case 'tree':
                                return _buildNavigationButton(VirtualTreeScreen(), "Start challenge");
                              default:
                                return _buildLabel("Unknown challenge type");
                            }
                          },
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

  Widget _buildLabel(String text) => Center(
    child: Text(
      text,
      style: GoogleFonts.urbanist(
        fontSize: 15,
        fontWeight: AppFontWeight.semiBold,
        color: Colors.grey.shade600,
      ),
    ),
  );

  Widget _buildJoinButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        if (!_isUserLoggedIn()) {
          _showErrorDialog(context);
          return;
        }

        await ChallengeService().joinChallenge(widget.challengeId, userId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You have joined the challenge!")),
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
        "Join",
        style: GoogleFonts.urbanist(
          fontSize: 15,
          fontWeight: AppFontWeight.semiBold,
        ),
      ),
    ),
  );

  Widget _buildFormSubmitButton(String question) {
    return StreamBuilder<bool>(
      stream: ChallengeService().checkSubmissionToday(widget.challengeId),
      builder: (context, snapshot) {
        final submittedToday = snapshot.data ?? false;
        print(submittedToday);

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
                    title: const Text("Confirm Pledge"),
                    content: Text(question),
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
              await ChallengeService().updateChallengeProgress(subtype: 'form', challengeId: widget.challengeId);

              _showSnackBar('Pledge submitted successfully!');
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

  Widget _buildStreakButton() {
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
              Navigator.of(context).push(scaleRoute(const DailyChallengeScreen()));
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

  Widget _buildNavigationButton(Widget screen, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(scaleRoute(screen));
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
          label,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
    );
  }
}
