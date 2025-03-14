import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 1)],
      ),
      child: Align(
        alignment: Alignment.center,
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.urbanist(fontSize: 13, color: AppColors.tertiary),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15), // Fine-tuning
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: GoogleFonts.urbanist(fontSize: 13, color: AppColors.tertiary.withOpacity(0.8)),
          ),
        ),
      ),
    );
  }
}
