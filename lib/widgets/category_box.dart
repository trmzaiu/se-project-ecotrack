import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../theme/fonts.dart';
import '../screens/guide/guide_detail_screen.dart';
import '../utils/route_transition.dart';

class CategoryBox extends StatelessWidget {
  final String image;
  final String text;
  final int slide;

  const CategoryBox({required this.image, required this.text, required this.slide, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          moveUpRoute(
              GuideDetailScreen(slide: slide)
          ),
        );
      },
      child: Container(
        width: ((phoneWidth - 40) - 3*10)/4,
        height: ((phoneWidth - 40) - 3*10)/4,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(image, width: ((phoneWidth - 40) - 3*70)/4, height: ((phoneWidth - 40) - 3*70)/4, fit: BoxFit.contain),
            SizedBox(height: 6),
            Text(
              text,
              style: GoogleFonts.urbanist(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: AppFontWeight.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}