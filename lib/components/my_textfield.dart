import 'package:flutter/material.dart';
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
      // alignment: Alignment.center,
      width: double.infinity,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 13),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12), // Center vertically
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 13, color: AppColors.tertiary),
        ),
      ),
    );
  }
}
