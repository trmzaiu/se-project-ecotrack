import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/fonts.dart';

class GuidelineItem extends StatelessWidget {
  final String emoji;
  final String text;
  final Color color;
  final Color colorFont;

  const GuidelineItem({
    Key? key,
    required this.emoji,
    required this.text,
    required this.color,
    required this.colorFont,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Center(
            child: Text(
              emoji,
              style: GoogleFonts.urbanist(
                fontSize: 14,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.urbanist(
              color: colorFont,
              fontSize: 13,
              fontWeight: AppFontWeight.regular,
            ),
          ),
        )
      ],
    );
  }
}
