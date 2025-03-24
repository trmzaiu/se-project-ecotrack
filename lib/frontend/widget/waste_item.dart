import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';

class WasteItem extends StatefulWidget {
  final String imagePath;
  final String title;
  final Color svgColor;
  final String detail;

  const WasteItem({Key? key, required this.imagePath, required this.title, required this.svgColor, required this.detail}) : super(key: key);

  @override
  _WasteItemState createState() => _WasteItemState();
}

class _WasteItemState extends State<WasteItem> {
  double _imagePosition = 0;
  bool _isExpanded = false;

  void _moveImage() {
    setState(() {
      _imagePosition = _imagePosition == 0 ? 75 : 0;
    });

    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _moveImage,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _isExpanded ? 235 : 150,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SvgPicture.asset('lib/assets/icons/base.svg', height: 150, color: AppColors.surface,),
            Positioned(
                left: 10,
                top: 15,
                child: SizedBox(
                  width: 120,
                  child: Text(
                    widget.detail,
                    style: GoogleFonts.urbanist(
                      color: AppColors.secondary,
                      fontSize: 12,
                      fontWeight: AppFontWeight.regular,
                      height: 1.2,
                    ),
                  ),
                )
            ),
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: _imagePosition,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset('lib/assets/icons/base.svg', height: 150, color: widget.svgColor,),
                  Positioned(
                    left: 15,
                    bottom: 20,
                    child: Text(
                      widget.title,
                      style: GoogleFonts.urbanist(
                        color: AppColors.surface,
                        fontSize: 14,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 35,
                    right: -15,
                    child: Image.asset(
                      widget.imagePath,
                      width: 145,
                      height: 145,
                      // fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
