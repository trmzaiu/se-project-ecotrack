import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/challenge/weekly_challenge_progress_card.dart';
import 'package:wastesortapp/frontend/service/challenge_service.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../../database/model/challenge.dart';
import '../../../theme/colors.dart';
import '../../service/tree_service.dart';
import '../../utils/phone_size.dart';
import '../../widget/bar_title.dart';

class WeeklyChallengeScreen extends StatefulWidget {
  @override
  State<WeeklyChallengeScreen> createState() => _WeeklyChallengeScreenState();
}

class _WeeklyChallengeScreenState extends State<WeeklyChallengeScreen> {
  late Future<Map<String, dynamic>> _weeklyChallengeFuture;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  DateTime _getNextSunday(DateTime currentDate) {
    int daysToSunday = DateTime.sunday - currentDate.weekday;
    if (daysToSunday <= 0) daysToSunday += 7;
    return DateTime(currentDate.year, currentDate.month, currentDate.day + daysToSunday, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime nextSunday = _getNextSunday(now);
    final Duration remainingTime = nextSunday.difference(now);

    final int remainingDays = remainingTime.inDays;
    final int remainingHours = remainingTime.inHours % 24;
    final int remainingMinutes = remainingTime.inMinutes % 60;

    int? rewardPoints;

    String remainingTimeString = '';
    if (remainingDays > 0) {
      remainingTimeString = ' $remainingDays DAY${remainingDays > 1 ? 'S' : ''}';
    } else if (remainingHours > 0) {
      remainingTimeString = ' $remainingHours HOUR${remainingHours > 1 ? 'S' : ''}';
    } else if (remainingMinutes > 0) {
      remainingTimeString = ' $remainingMinutes MINUTE${remainingMinutes > 1 ? 'S' : ''}';
    }

    return Scaffold(
      extendBody: true,
      body: Container(
        color: AppColors.secondary,
        width: double.infinity,
        child: Column(
          children: [
            BarTitle(title: 'Weekly Challenge', showBackButton: true),

            const SizedBox(height: 30),

            FutureBuilder<WeeklyChallenge?>(
              future: ChallengeService().loadWeeklyChallenge(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading weekly challenge"));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("No weekly challenge available"));
                } else {
                  final weeklyChallenge = snapshot.data!;
                  final goalPoints = weeklyChallenge.target;
                  rewardPoints = weeklyChallenge.rewardPoints;

                  return WeeklyChallengeProgressCard(
                    userId: userId,
                    goalPoints: goalPoints,
                  );
                }
              },
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                color: AppColors.background,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Weekly Quests',
                          style: GoogleFonts.urbanist(
                            color: AppColors.secondary,
                            fontSize: 24,
                            fontWeight: AppFontWeight.bold,
                          )
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('lib/assets/icons/ic_clock.svg', width: 18),
                            Text(
                              remainingTimeString,
                              style: GoogleFonts.urbanist(
                                color: AppColors.secondary,
                                fontSize: 18,
                                fontWeight: AppFontWeight.bold,
                              )
                            )
                          ]
                        )
                      ]
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.tertiary, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FutureBuilder<WeeklyChallenge>(
                        future: ChallengeService().loadWeeklyChallenge(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error loading weekly challenge"));
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return Center(child: Text("No weekly challenge available"));
                          }

                          final tasks = List<Map<String, dynamic>>.from(snapshot.data!.tasks);

                          return Column(
                            children: List.generate(tasks.length, (index) {
                              final task = tasks[index];
                              return Column(
                                children: [
                                  _buildTaskItem(context, task, index),
                                  if (index < tasks.length - 1)
                                    Divider(color: AppColors.tertiary, thickness: 2),
                                ],
                              );
                            }),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    StreamBuilder<bool>(
                      stream: ChallengeService().isWeeklyChallengeCompleted(userId),
                      builder: (context, snapshot) {
                        final isCompleted = snapshot.data ?? false;

                        return ElevatedButton(
                          onPressed: !isCompleted ? null : () async {
                            await ChallengeService().setWeeklyChallengeCompleted(userId, false);
                            await TreeService().increaseDrops(userId, rewardPoints ?? 0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isCompleted ? AppColors.accent : AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            minimumSize: Size(200, 0),
                          ),
                          child: Text(
                            'Claim',
                            style: GoogleFonts.urbanist(
                              color: AppColors.surface,
                              fontSize: 18,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task, int index) {
    final int targetValue = task['targetValue'] ?? 1;
    final String title = task['title'] ?? 'Task';
    final int rewardPoint = task['point'] ?? 1;

    return StreamBuilder<Map<String, dynamic>>(
      stream: ChallengeService().getTaskStatus(userId, index),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: LinearProgressIndicator(),
          );
        }

        final int currentPoints = snapshot.data!['progressTask'];
        final bool isTaskCompleted = snapshot.data!['isCompleted'];
        final double progress = (currentPoints / targetValue).clamp(0.0, 1.0);

        return Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: GoogleFonts.urbanist(
                    color: AppColors.secondary,
                    fontSize: 18,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: getPhoneWidth(context) - 50 - 65 / 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 30,
                        backgroundColor: AppColors.accent,
                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 15,
                    top: 6,
                    child: Container(
                      height: 9,
                      width: progress * (MediaQuery.of(context).size.width - 50) * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.surface.withOpacity(0.2),
                      ),
                    ),
                  ),

                  Positioned(
                    right: -65 / 2,
                    bottom: -12,
                    child: GestureDetector(
                      onTap: () async {
                        if (!isTaskCompleted) {
                          await ChallengeService().completeWeeklyTask(userId, index, rewardPoint);
                        }
                      },
                      child: Image.asset(
                        isTaskCompleted
                            ? 'lib/assets/images/open_chest.png'
                            : 'lib/assets/images/close_chest.png',
                        width: 65,
                      ),
                    ),
                  ),

                  Text(
                    '$currentPoints/$targetValue',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: AppFontWeight.extraBold,
                      color: AppColors.surface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
