import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

import 'my_button.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String description;
  final List<Widget>? children;
  final String text;
  final VoidCallback onSubmit;

  const SectionTitle({
    Key? key,
    required this.title,
    required this.description,
    this.children,
    required this.text,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 5),

        Text(
          description,
          style: GoogleFonts.urbanist(
            fontSize: 14,
            color: AppColors.tertiary,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 35),

        if (children != null) ...children!,

        SizedBox(height: 30),

        SizedBox(
          width: 330,
          child: MyButton(
            text: text,
            onTap: onSubmit,
          ),
        ),

      ],
    );
  }
}
