import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import '../../../database/model/user.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../service/user_service.dart';

class WeeklyChallengeProgressCard extends StatelessWidget {
  final String userId;
  final int goalPoints;
  final double margin;
  final double padding;

  const WeeklyChallengeProgressCard({
    Key? key,
    required this.userId,
    required this.goalPoints,
    this.margin = 20,
    this.padding = 20,
  }) : super(key: key);

  double _calculatePosition(double ratio, BuildContext context) {
    final barWidth = MediaQuery.of(context).size.width - (padding+15) * 2;
    return ratio * barWidth - 40;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Users?>(
      stream: UserService().getCurrentUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;

        if (user == null) {
          return const SizedBox();
        }

        final currentPoints = user.weekProgress;
        double progress = currentPoints / goalPoints;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Earn $goalPoints Quest Points',
                    style: GoogleFonts.urbanist(
                      color: AppColors.secondary,
                      fontSize: 18,
                      fontWeight: AppFontWeight.extraBold,
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
                            fontWeight: AppFontWeight.extraBold,
                          ),
                        ),
                        TextSpan(
                          text: ' / $goalPoints',
                          style: GoogleFonts.urbanist(
                            color: AppColors.tertiary,
                            fontSize: 18,
                            fontWeight: AppFontWeight.extraBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress Bar with milestones
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 30,
                      backgroundColor: AppColors.accent,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  // Light highlight overlay
                  Positioned(
                    left: 15,
                    top: 6,
                    child: Container(
                      height: 9,
                      width: progress * (getPhoneWidth(context) - (margin+15) * 2) - 20 <= 20 ? 0 : progress * (getPhoneWidth(context) - (margin+15) * 2) - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.surface.withOpacity(0.2),
                      ),
                    ),
                  ),

                  // Milestone 3/7
                  _buildMilestone(
                    context,
                    ratio: 3 / 7,
                    unlocked: currentPoints >= (3 / 7) * goalPoints,
                    icon: currentPoints >= (3 / 7) * goalPoints
                        ? 'lib/assets/icons/ic_check.svg'
                        : 'lib/assets/icons/ic_lock.svg',
                    iconSize: currentPoints >= (3 / 7) * goalPoints ? 30 : 20,
                  ),

                  // Milestone 5/7
                  _buildMilestone(
                    context,
                    ratio: 5 / 7,
                    unlocked: currentPoints >= (5 / 7) * goalPoints,
                    icon: currentPoints >= (5 / 7) * goalPoints
                        ? 'lib/assets/icons/ic_check.svg'
                        : 'lib/assets/icons/ic_lock.svg',
                    iconSize: currentPoints >= (5 / 7) * goalPoints ? 30 : 20,
                  ),

                  // Final milestone: goal
                  Positioned(
                    left: _calculatePosition(1.0, context),
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
                            color: currentPoints >= goalPoints
                                ? AppColors.primary
                                : AppColors.accent,
                            child: Center(
                              child: SvgPicture.asset(
                                currentPoints >= goalPoints
                                    ? 'lib/assets/icons/ic_check.svg'
                                    : 'lib/assets/icons/ic_crown.svg',
                                width: currentPoints >= goalPoints ? 35 : 22,
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildMilestone(BuildContext context,
      {required double ratio,
        required bool unlocked,
        required String icon,
        required double iconSize}) {
    return Positioned(
      left: _calculatePosition(ratio, context),
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
            color: unlocked
                ? AppColors.primary
                : AppColors.accent,
            child: Center(
              child: SvgPicture.asset(icon, width: iconSize),
            ),
          ),
        ),
      ),
    );
  }
}
