import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

class WasteItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color svgColor;

  const WasteItem({required this.imagePath, required this.title, required this.svgColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset('lib/assets/icons/base.svg', height: 150, color: svgColor,),
          Positioned(
            left: 15,
            bottom: 20,
            child: Text(
              title,
              style: GoogleFonts.urbanist(
                color: AppColors.surface,
                fontSize: 14,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
          ),
          Positioned(
            bottom: 35,
            right: -20,
            child: Image.asset(
              imagePath,
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
