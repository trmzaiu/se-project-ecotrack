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
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText, // Using the passed parametera
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: InputBorder.none,
          hintText: hintText, // Using the passed parameter
          hintStyle: TextStyle(color: AppColors.tertiary),

        ),
      ),
    );
  }
}
