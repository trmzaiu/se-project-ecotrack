import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import 'notification_bell.dart';

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
              top: -12.5,
              child: IconButton(
                onPressed: () { Navigator.pop(context); },
                icon: SvgPicture.asset(
                  'lib/assets/icons/ic_back.svg',
                  height: 20,
                  colorFilter: ColorFilter.mode(buttonColor, BlendMode.srcIn),
                )
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
              top: -15,
              child: NotificationBell()
            )
        ],
      ),
    );
  }
}
