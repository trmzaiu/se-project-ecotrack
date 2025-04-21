import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/service/challenge_service.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../theme/colors.dart';
import '../../utils/phone_size.dart';
import '../../widget/bar_title.dart';

class WeeklyChallengeScreen extends StatelessWidget {

  DateTime _getNextSunday(DateTime currentDate) {
    // Calculate how many days to add to reach Sunday
    int daysToSunday = DateTime.sunday - currentDate.weekday;
    if (daysToSunday <= 0) {
      // If it's already Sunday, add 7 days to get to the next Sunday
      daysToSunday += 7;
    }

    // Get the next Sunday's date
    DateTime nextSunday = currentDate.add(Duration(days: daysToSunday));

    // Set the time to 11:59 PM
    return DateTime(nextSunday.year, nextSunday.month, nextSunday.day, 23, 59, 59);
  }

  @override
  Widget build(BuildContext context) {
    final int currentPoints = 5;
    final int goalPoints = 10;

    double progress = currentPoints / goalPoints;

    DateTime now = DateTime.now();

    // Calculate the time left until Sunday 11:59 PM
    DateTime nextSunday = _getNextSunday(now);
    Duration remainingTime = nextSunday.difference(now);

    // Get the days, hours, and minutes left
    int remainingDays = remainingTime.inDays;
    int remainingHours = remainingTime.inHours % 24;
    int remainingMinutes = remainingTime.inMinutes % 60;

    // Construct the time string based on the remaining time
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
      body:  Container(
        color: AppColors.secondary,
        width: double.infinity,
        child: Column(
          children: [
            BarTitle(title: 'Weekly Challenge', showBackButton: true),

            const SizedBox(height: 30),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Earn 7 Quest Points",
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 18,
                          fontWeight: AppFontWeight.extraBold
                        ),
                      ),

                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '$currentPoints',
                              style: GoogleFonts.urbanist(
                                color: AppColors.primary,
                                fontSize: 18,
                                fontWeight: AppFontWeight.extraBold
                              ),
                            ),

                            TextSpan(
                              text: ' / $goalPoints',
                              style: GoogleFonts.urbanist(
                                color: AppColors.tertiary,
                                fontSize: 18,
                                fontWeight: AppFontWeight.extraBold
                              ),
                            ),
                          ]
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 30,
                          backgroundColor: AppColors.accent.withOpacity(0.8),
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),

                      // Light highlight strip
                      Positioned(
                        left: 15,
                        top: 6,
                        child: Container(
                          height: 9,
                          width: progress * (MediaQuery.of(context).size.width - 35*2) - 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.surface.withOpacity(0.2)
                          ),
                        ),
                      ),

                      Positioned(
                        left: (3 / 7) * (MediaQuery.of(context).size.width - 35*2) - 40,
                        top: -5,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 3.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Container(
                              color: currentPoints >= (3/7) * goalPoints ? AppColors.primary : AppColors.accent.withOpacity(0.8),
                              child: Center(
                                child: SvgPicture.asset(currentPoints >= (3/7) * goalPoints ? 'lib/assets/icons/ic_check.svg' : 'lib/assets/icons/ic_lock.svg', width: currentPoints >= (3/7) * goalPoints ? 30 : 20)
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: (5 / 7) * (MediaQuery.of(context).size.width - 35*2) - 40,
                        top: -5,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 3.5,
                            ),
                          ),
                          child: ClipOval(
                            child: Container(
                              color: currentPoints >= (5/7) * goalPoints ? AppColors.primary : AppColors.accent.withOpacity(0.8),
                              child: Center(
                                child: SvgPicture.asset(currentPoints >= (5/7) * goalPoints ? 'lib/assets/icons/ic_check.svg' : 'lib/assets/icons/ic_lock.svg', width: currentPoints >= (5/7) * goalPoints ? 30 : 20),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: (MediaQuery.of(context).size.width - 35 * 2) - 45,
                        top: -7.5,
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surface,
                              width: 3.5,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: currentPoints >= goalPoints
                                    ? AppColors.primary
                                    : Colors.grey[400]!,
                                width: 4,
                              ),
                            ),
                            child: ClipOval(
                              child: Container(
                                color: currentPoints >= 7
                                    ? AppColors.primary
                                    : AppColors.accent.withOpacity(0.8),
                                child: Center(
                                  child: SvgPicture.asset(currentPoints >= goalPoints ? 'lib/assets/icons/ic_check.svg' : 'lib/assets/icons/ic_crown.svg', width: currentPoints >= goalPoints ? 35 : 22),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
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
                              fontWeight: AppFontWeight.bold
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('lib/assets/icons/ic_clock.svg', width: 18),
                            Text(
                              remainingTimeString,
                              style: GoogleFonts.urbanist(
                                  color: AppColors.secondary,
                                  fontSize: 18,
                                  fontWeight: AppFontWeight.bold
                              ),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.tertiary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FutureBuilder<Map<String, dynamic>>(
                        future: ChallengeService().loadWeeklyChallenge(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error loading weekly challenge"));
                          } else if (snapshot.hasData) {
                            final weeklyChallenge = snapshot.data;

                            if (weeklyChallenge == null || weeklyChallenge.containsKey('error')) {
                              return Center(child: Text("No weekly challenge available"));
                            }

                            final dailyChallenges = List<Map<String, dynamic>>.from(weeklyChallenge['tasks'] ?? []);

                            return Column(
                              children: List.generate(dailyChallenges.length, (index) {
                                final task = dailyChallenges[index];
                                return Column(
                                  children: [
                                    _buildTaskItem(context, task),
                                    if (index < dailyChallenges.length - 1)
                                      Divider(color: AppColors.tertiary, thickness: 2),
                                  ],
                                );
                              }),
                            );
                          } else {
                            return Center(child: Text("No data found"));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> task) {
    final int currentPoints = 0;

    final description = task['description'] ?? 'Task';
    final targetValue = task['targetValue'] ?? 0;

    double progress = currentPoints / targetValue;

    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$description',
              style: GoogleFonts.urbanist(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: AppFontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 8),

          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Progress Bar
              SizedBox(
                width: getPhoneWidth(context) - 50 - 65/2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 30,
                    backgroundColor: AppColors.accent,
                    valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),

              // Light highlight strip
              Positioned(
                left: 15,
                top: 6,
                child: Container(
                  height: 9,
                  width: progress * (MediaQuery.of(context).size.width - 50) * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppColors.surface.withOpacity(0.2)
                  ),
                ),
              ),

              Positioned(
                right: -65/2,
                bottom: -12,
                child: Image.asset(currentPoints == targetValue ? 'lib/assets/images/open_chest.png' : 'lib/assets/images/close_chest.png', width: 65)
              ),

              Text(
                '$currentPoints/$targetValue',
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: AppFontWeight.extraBold,
                  color: AppColors.surface,
                ),
              ),
            ]
          )
        ],
      ),
    );
  }
}
