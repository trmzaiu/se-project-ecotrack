import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/user/notification_screen.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import 'notification_bell.dart';

class BarNotiTitle extends StatelessWidget {
  final String title_small;
  final String title_big;

  const BarNotiTitle({
    required this.title_small,
    required this.title_big,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title_small,
                style: GoogleFonts.urbanist(
                  color: AppColors.tertiary,
                  fontSize: 20,
                  fontWeight: AppFontWeight.medium,
                  height: 1.5,
                ),
              ),
              Text(
                title_big,
                style: GoogleFonts.urbanist(
                  color: AppColors.secondary,
                  fontSize: 30,
                  fontWeight: AppFontWeight.bold,
                  height: 1,
                ),
              ),
            ],
          ),
          NotificationBell(size: 30)
        ],
      )
    );
  }
}
