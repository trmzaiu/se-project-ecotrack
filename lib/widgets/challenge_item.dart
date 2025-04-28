import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';


class ChallengeItem extends StatelessWidget {
  final String image;
  final String title;
  final String info;
  final String attend;

  const ChallengeItem({required this.image, required this.title, required this.info, required this.attend, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

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
            // height: 140,
            width: 110,
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
          top: 14,
          left: 14 + 110 + 14,
          right: 14,
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.urbanist(
                    fontSize: phoneWidth * 0.4 * 0.1,
                    fontWeight: AppFontWeight.semiBold,
                    color: AppColors.secondary,
                  ),
                  textAlign: TextAlign.left,
                ),

                SizedBox(height: 5),

                Text(
                  info,
                  style: GoogleFonts.urbanist(
                    fontSize: 11,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.tertiary,
                    letterSpacing: 0,
                    height: 1.2
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          )
        ),

        Positioned(
          left: 14 + 110 + 14,
          bottom: 14,
          child: SizedBox(
            width: phoneWidth - 40 - 14*3 - 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: attend,
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.secondary,
                        ),
                      ),

                      TextSpan(
                        text: ' attending',
                        style: GoogleFonts.urbanist(
                          fontSize: 11,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.tertiary,
                        ),
                      ),
                    ]
                  )
                ),

                Container(
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
                        fontSize: 11,
                        fontWeight: AppFontWeight.semiBold,
                        color: AppColors.surface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          )
        )
      ],
    );
  }
}