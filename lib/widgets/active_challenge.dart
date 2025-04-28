import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';


class ActiveChallenge extends StatelessWidget {
  final String image;
  final String type;
  final String title;
  final String info;
  final String attend;

  const ActiveChallenge({required this.image, required this.type, required this.title, required this.info, required this.attend, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              height: 85,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const Divider(height: 0.5, color: AppColors.accent),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),

          ],
        ),

        // Image
        Positioned(
          left: 14,
          bottom: 12,
          child: Container(
            height: 110,
            // width: 130 - 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.surface, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        Positioned(
          top: 15,
          left: 15 + 110 + 15,
          right: 15,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: GoogleFonts.urbanist(
                    fontSize: phoneWidth * 0.4 * 0.07,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.tertiary,
                  ),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 5),

                Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: phoneWidth * 0.4 * 0.1,
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.left,
                ),

                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: 0.5,
                  color: AppColors.primary,
                  backgroundColor: Colors.grey[300],
                  minHeight: 10,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 15),
                Text('Ends in 2 days', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          )
        ),
      ],
    );
  }
}