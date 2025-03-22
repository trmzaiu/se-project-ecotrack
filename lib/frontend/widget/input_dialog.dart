import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../utils/phone_size.dart';
import 'my_textfield.dart';

class InputDialog extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController? controllerPass;
  final String hintText;
  final String? hintTextPass;
  final String information;
  final VoidCallback? onPressed;
  final bool isPass;

  const InputDialog({
    super.key,
    required this.controller,
    required this.hintText,
    required this.information,
    this.onPressed,
    this.isPass = false,
    this.controllerPass,
    this.hintTextPass
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      backgroundColor: AppColors.background,
      title: Center(
        child: Text(
          'Enter your new $information',
          style: GoogleFonts.urbanist(
            fontSize: 20,
            color: AppColors.secondary,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
      contentPadding: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
      content: SizedBox(
        width: getPhoneWidth(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextField(
              controller: controller,
              hintText: hintText,
              obscureText: isPass,
            ),

            if (isPass) ...[
              SizedBox(height: 15),
              MyTextField(
                controller: controllerPass ?? TextEditingController(),
                hintText: 'Confirm password',
                obscureText: isPass,
              ),
            ]
          ],
        )
      ),
      actionsPadding: EdgeInsets.all(0),
      actions: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.tertiary, width: 0.5),
                    right: BorderSide(color: AppColors.tertiary, width: 0.5),
                  ),
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: AppColors.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.primary, width: 0.5),
                    left: BorderSide(color: AppColors.primary, width: 0.5),
                  ),
                ),
                child: TextButton(
                  onPressed: onPressed,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(12)),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.urbanist(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
