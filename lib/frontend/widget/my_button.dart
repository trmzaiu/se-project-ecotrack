import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';
import '../../theme/fonts.dart';

class MyButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDisabled;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  void _handleTap() {
    if (widget.isDisabled) return;
    setState(() {
      _isPressed = true;
    });
    widget.onTap();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _isPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isDisabled ? null : _handleTap,
      borderRadius: BorderRadius.circular(10),
      splashColor: widget.isDisabled ? Colors.transparent : AppColors.surface,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: widget.isDisabled ? AppColors.board2 : (_isPressed ? AppColors.board2 : AppColors.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: GoogleFonts.urbanist(
            color: widget.isDisabled ? AppColors.surface : AppColors.surface,
            fontSize: 16,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
    );
  }
}
