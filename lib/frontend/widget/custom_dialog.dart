import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final bool status;
  final String buttonTitle;
  final VoidCallback? onPressed;

  const CustomDialog({
    super.key,
    required this.message,
    required this.status,
    required this.buttonTitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double phoneHeight = getPhoneHeight(context);
    double phoneWidth = getPhoneWidth(context);

    return AlertDialog(
      backgroundColor: AppColors.background,
      contentPadding: EdgeInsets.fromLTRB(25, 50, 25, 0),
      content: SizedBox(
        height: phoneHeight/2.5 - 40,
        width: phoneWidth - 60,
        child: Column(
          children: [
            SvgPicture.asset(
              status ? "lib/assets/icons/ic_green.svg" : "lib/assets/icons/ic_red.svg",
              width: 200,
              height: 200,
            ),
            SizedBox(height: 30),
            Text(
              status ? "Success!" : "Oops!",
              style: GoogleFonts.urbanist(
                fontSize: 24,
                color: status ? AppColors.primary : AppColors.secondary,
                fontWeight: AppFontWeight.bold,
              ),
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: GoogleFonts.urbanist(
                fontSize: 16,
                color: AppColors.tertiary,
                fontWeight: AppFontWeight.regular,
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 50),
      actionsOverflowDirection: VerticalDirection.up,
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Container(
            width: 150,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: status ? AppColors.primary : AppColors.secondary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              buttonTitle,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                color: AppColors.surface,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
