import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonTitle;
  final VoidCallback? onPressed;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.buttonTitle,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      title: Text(
        title,
        style: GoogleFonts.urbanist(
          fontSize: 20,
          color: AppColors.secondary,
          fontWeight: AppFontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          color: AppColors.tertiary,
          fontWeight: AppFontWeight.regular,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(),
          child: Container(
            width: 100,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
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
