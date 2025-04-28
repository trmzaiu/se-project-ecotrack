import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

class FadingText extends StatefulWidget {
  @override
  _FadingTextState createState() => _FadingTextState();
}

class _FadingTextState extends State<FadingText> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _isVisible,
      child: Text(
        "Align the object in the center",
        style: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: AppFontWeight.medium,
          color: AppColors.surface,
          shadows: [
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 30,
              color: Color(0x4DFFFFFF),
            ),
            Shadow(
              offset: Offset(0, 2),
              blurRadius: 8,
              color: Color(0x1A000000),
            ),
          ],
        ),
      ),
    );
  }
}