import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../theme/fonts.dart';

class TextRow extends StatelessWidget {
  final String text;

  const TextRow({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: GoogleFonts.urbanist(
            color: AppColors.secondary,
            fontSize: 16,
            fontWeight: AppFontWeight.bold,
          ),
        ),
        Text(
          "See all",
          style: GoogleFonts.urbanist(
            color: AppColors.tertiary,
            fontSize: 12,
            fontWeight: AppFontWeight.regular,
          ),
        ),
      ],
    );
  }
}