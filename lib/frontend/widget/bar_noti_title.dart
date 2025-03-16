import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/user/notification_screen.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

class BarNotiTitle extends StatelessWidget {
  final String title_small;
  final String title_big;

  const BarNotiTitle({
    Key? key,
    required this.title_small,
    required this.title_big,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 40, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
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
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0d333333),
                    offset: Offset(0, 0),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset('lib/assets/icons/ic_notification.svg'),
              ),
            ),
          )
        ],
      )
    );
  }
}
