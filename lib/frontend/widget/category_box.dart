import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../theme/fonts.dart';
import '../screen/guide/guide_detail_screen.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GuideDetailScreen(slide: slide)),
        );
      },
      child: Container(
        width: ((phoneWidth - 40) - 3*10)/4,
        height: ((phoneWidth - 40) - 3*10)/4,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
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