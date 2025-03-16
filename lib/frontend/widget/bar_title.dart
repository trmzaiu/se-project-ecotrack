import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

class BarTitle extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const BarTitle({
    Key? key,
    required this.title,
    this.showBackButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60),
      child: Stack(
        children: [
          if (showBackButton)
            Positioned(
              left: 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  'lib/assets/icons/ic_back.svg',
                  height: 20,
                ),
              ),
            ),

          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: AppColors.surface,
                fontSize: 18,
                fontWeight: AppFontWeight.semiBold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
