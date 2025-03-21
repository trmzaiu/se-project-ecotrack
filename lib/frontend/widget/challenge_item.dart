import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';


class ChallengeItem extends StatelessWidget {
  final String image;
  final String title;
  final String info;

  const ChallengeItem({required this.image, required this.title, required this.info, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),

        Positioned(
          left: 14,
          bottom: 12,
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
          top: 12,
          left: 130,
          child: Text(
            title,
            style: GoogleFonts.urbanist(
              fontSize: 15,
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.secondary,
            ),
            textAlign: TextAlign.left,
          ),
        ),

        Positioned(
          top: 40,
          left: 130,
          child: SizedBox(
            width: getPhoneWidth(context) - 190,
            child: Text(
              info,
              style: GoogleFonts.urbanist(
                fontSize: 10,
                fontWeight: AppFontWeight.medium,
                color: AppColors.tertiary,
                letterSpacing: 0,
                height: 1.2
              ),
              textAlign: TextAlign.left,
            ),
          )
        ),

        Positioned(
          top: 95,
          left: 130,
          child: SizedBox(
            width: 100,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '100',
                    style: GoogleFonts.urbanist(
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                      color: AppColors.secondary,
                    ),
                  ),

                  TextSpan(
                    text: ' attending',
                    style: GoogleFonts.urbanist(
                      fontSize: 10,
                      fontWeight: AppFontWeight.medium,
                      color: AppColors.tertiary,
                    ),
                  ),
                ]
              )
            ),
          )
        ),

        Positioned(
          right: 15,
          bottom: 14,
          child: Container(
            width: 70,
            height: 25,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Center(
              child: Text(
                'Join now',
                style: GoogleFonts.urbanist(
                  fontSize: 10,
                  fontWeight: AppFontWeight.semiBold,
                  color: AppColors.surface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}