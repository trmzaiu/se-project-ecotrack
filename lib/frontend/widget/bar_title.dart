import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/user/notification_screen.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

class BarTitle extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final bool showNotification;
  final Color textColor;
  final Color buttonColor;

  const BarTitle({
    Key? key,
    required this.title,
    this.showBackButton = false,
    this.showNotification = false,
    this.textColor = AppColors.surface,
    this.buttonColor = AppColors.surface,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 60),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (showBackButton)
            Positioned(
              left: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  'lib/assets/icons/ic_back.svg',
                  height: 20,
                  colorFilter: ColorFilter.mode(buttonColor, BlendMode.srcIn),
                ),
              ),
            ),

          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: textColor,
                fontSize: 18,
                fontWeight: AppFontWeight.semiBold,
                letterSpacing: 1,
              ),
            ),
          ),

          if (showNotification)
            Positioned(
              right: 20,
              top: -10,
              child: GestureDetector(
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
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x33333333),
                        offset: Offset(0, 0),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset('lib/assets/icons/ic_notification.svg'),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
