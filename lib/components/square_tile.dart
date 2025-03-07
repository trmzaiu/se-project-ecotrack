import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  const SquareTile({required this.imagePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.surface,
      ),
      child: Image.asset(imagePath, height: 40),
    );
  }
}
