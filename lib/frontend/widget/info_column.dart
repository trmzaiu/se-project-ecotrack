import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

class InfoColumn extends StatelessWidget {
  final String title;
  final String value;
  final double width;

  const InfoColumn({
    Key? key,
    required this.title,
    required this.value,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: 20,
              fontWeight: AppFontWeight.regular,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
