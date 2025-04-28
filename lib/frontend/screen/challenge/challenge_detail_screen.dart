import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/database/model/challenge.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../database/model/user.dart';
import '../../../main.dart';
import '../../../theme/colors.dart';
import '../../service/challenge_service.dart';
import '../../service/user_service.dart';
import '../../utils/format_time.dart';
import '../auth/login_screen.dart';
import '../../widget/custom_dialog.dart';
import '../../utils/route_transition.dart';
import 'daily_challenge_screen.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final String challengeId;

  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  _ChallengeDetailScreenState createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  DateTime? startTime;
  DateTime? endTime;
  Duration remainingTime = Duration.zero;
  Timer? countdownTimer;
  bool _timerInitialized = false;

  void _initTimer(DateTime start, DateTime end) {
    startTime = start;
    endTime = end;

    final now = DateTime.now();
    if (now.isBefore(start)) {
      remainingTime = start.difference(now);
    } else if (now.isBefore(end)) {
      remainingTime = end.difference(now);
    } else {
      remainingTime = Duration.zero;
    }

    _startCountdown();
    _timerInitialized = true;
  }

  void _startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      setState(() {
        if (now.isBefore(startTime!)) {
          remainingTime = startTime!.difference(now);
        } else if (now.isBefore(endTime!)) {
          remainingTime = endTime!.difference(now);
        } else {
          remainingTime = Duration.zero;
        }
      });
    });
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
    return StreamBuilder<CommunityChallenge>(
      stream: ChallengeService().getChallengeById(widget.challengeId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        final challenge = snapshot.data!;

        if (!_timerInitialized) {
          final start = (challenge.startDate).toDate();
          final end = (challenge.endDate).toDate();
          _initTimer(start, end);
        }

        final image = challenge.image;
        final title = challenge.title;
        final description = challenge.description;
        final reward = challenge.rewardPoints;
        final target = challenge.targetValue;
        final progress = challenge.progress;
        final subtype = challenge.subtype;
        final question = challenge.question;
        final participantsList = challenge.participants;
        final participants = participantsList.length;
        final rewardedUsers = List<String>.from(challenge.rewardedUsers);

        final progressRatio = (progress / target).clamp(0.0, 1.0);
        final percentage = (progressRatio * 100).toStringAsFixed(2);

        final now = DateTime.now();
        final isComingSoon = now.isBefore(challenge.startDate.toDate());
        final isExpired = now.isAfter(challenge.endDate.toDate());
        final isActive = !isComingSoon && !isExpired;

        return Scaffold(
          body: Container(
            height: double.infinity,
            color: AppColors.background,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: getPhoneWidth(context) * 6 / 7,
                        width: double.infinity,
                        child: Image.asset('lib/assets/images/$image.png',
                            fit: BoxFit.cover),
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
                        FutureBuilder<List<Users?>>(
                          future: UserService().getUsersByIds(List<String>.from(participantsList)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              if (!snapshot.hasData) {
                                return const SizedBox(height: 25,);
                              }
                            }

                            if (!snapshot.hasData || snapshot.data == null) {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'No participant',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 14,
                                    color: AppColors.secondary,
                                    fontWeight: AppFontWeight.regular,
                                  ),
                                ),
                              );
                            }

                            final users = snapshot.data!;
                            final displayUsers = users.take(3).toList();

                            return Row(
                              children: [
                                SizedBox(
                                  width: 13 * (displayUsers.length + 1),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: List.generate(
                                        displayUsers.length, (index) {
                                      final user = displayUsers[index];
                                      final avatar = Container(
                                        width: 25,
                                        height: 25,
                                        decoration: ShapeDecoration(
                                          shape: OvalBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: AppColors.surface
                                            ),
                                          ),
                                          image: DecorationImage(
                                            image: user!.photoUrl != ''
                                                ? CachedNetworkImageProvider(user.photoUrl) as ImageProvider
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
                                    participants == 0
                                        ? 'No participant'
                                        : '$participants ${participants == 1 ? 'participant' : 'participants'}',
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
                                          text: remainingTime == Duration.zero
                                              ? ''
                                              : (startTime != null && startTime!.isAfter(DateTime.now()))
                                              ? 'Start in '
                                              : 'End in ',
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            color: AppColors.secondary,
                                            fontWeight: AppFontWeight.medium,
                                          ),
                                        ),
                                        TextSpan(
                                          text: formatDuration(remainingTime, 'Challenge ended'),
                                          style: GoogleFonts.urbanist(
                                            fontSize: 14,
                                            color: remainingTime == Duration.zero
                                                ? AppColors.tertiary
                                                : const Color(0xFFC62828),
                                            fontWeight: AppFontWeight.semiBold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
                          backgroundColor: AppColors.accent.withOpacity(
                              0.6),
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
                            child: Text(
                              "🎁  $reward points for successful completion",
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
                            final claimedReward = rewardedUsers.contains(userId);

                            if (!isJoined) {
                              if (isComingSoon || isExpired) {
                                String label = isComingSoon
                                    ? 'Coming Soon'
                                    : 'This challenge is no longer available';
                                return _buildLabel(label);
                              }

                              return _buildJoinButton();
                            }

                            if (!isActive) {
                              return _buildLabel(
                                  "This challenge is no longer available");
                            }

                            if (progress == target) {
                              return FutureBuilder<bool>(
                                future: ChallengeService()
                                    .hasUserContributedToChallenge(
                                    widget.challengeId, userId),
                                builder: (context, contribSnapshot) {
                                  if (!contribSnapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }

                                  final hasContributed = contribSnapshot
                                      .data!;

                                  return ElevatedButton(
                                    onPressed: claimedReward
                                        ? null
                                        : () async {
                                      if (!hasContributed) {
                                        _showSnackBar(
                                            'Cannot claim without contribution',
                                            isError: true);
                                        return;
                                      }

                                      await ChallengeService()
                                          .rewardChallengeContributors(
                                          widget.challengeId, userId);
                                      _showSnackBar(
                                          'Reward claimed successfully!');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: claimedReward
                                          ? AppColors.accent
                                          : AppColors.primary,
                                      foregroundColor: AppColors
                                          .surface,
                                      padding: const EdgeInsets
                                          .symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius
                                            .circular(12),
                                      ),
                                      minimumSize: const Size(200, 0),
                                    ),
                                    child: Text(
                                      claimedReward
                                          ? 'Claimed'
                                          : 'Claim',
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: AppFontWeight
                                            .bold,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }

                            switch (subtype) {
                              case 'form':
                                return _buildFormSubmitButton(question!);
                              case 'streak':
                                return _buildStreakButton();
                              case 'evidence':
                                return _buildNavigationButton(UploadScreen(), "Start challenge", settings: RouteSettings(name: "UploadScreen"));
                              case 'tree':
                                return _buildNavigationButton(MainScreen(index: 2, fullOpened: true), "Start challenge");
                              default:
                                return _buildLabel("Unknown challenge type");
                            }
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

  Widget _buildNavigationButton(Widget screen, String label, {RouteSettings? settings}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (settings != null) {
            Navigator.of(context).push(
              scaleRoute(
                screen,
                settings: settings,
              ),
            );
          } else {
            Navigator.of(context).push(
              scaleRoute(screen),
            );
          }
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
