import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

class CustomErrorDialog extends StatelessWidget {
  final String title;
  final String message;

  const CustomErrorDialog({
    Key? key,
    required this.title,
    required this.message,
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
          fontWeight: AppFontWeight.bold
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.urbanist(
          fontSize: 14,
          color: AppColors.tertiary,
          fontWeight: AppFontWeight.regular
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Container(
            width: 50,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              "OK",
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
