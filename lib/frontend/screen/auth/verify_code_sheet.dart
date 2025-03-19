import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';
import '../../widget/section_tile.dart';

class VerifyCodeSheet extends StatefulWidget {
  final VoidCallback onNext;

  const VerifyCodeSheet({required this.onNext, Key? key}) : super(key: key);

  @override
  _VerifyCodeSheetState createState() => _VerifyCodeSheetState();
}

class _VerifyCodeSheetState extends State<VerifyCodeSheet> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _secondsRemaining = 90;
  Timer? _timer;
  bool _canResend = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 30;
      _canResend = false;
    });

    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    if (_canResend) {
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
      print("Sending OTP again...");
      _startCountdown();
    }
  }

  void verifyCode() {
    String code = _controllers.map((e) => e.text).join();
    print("Entered code: $code");
  }
  void _checkCodeCompletion() {
    setState(() {
      _isButtonEnabled = _controllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  void _onChanged(int index, String value) {
    if (value.isEmpty) {
      if (index > 0) {
        for (int i = index; i < _controllers.length - 1; i++) {
          _controllers[i].text = _controllers[i + 1].text;
        }
        _controllers[_controllers.length - 1].clear();
        _focusNodes[index - 1].requestFocus();
      }
    } else if (value.length == 1 && index < 3) {
      _focusNodes[index].unfocus();
      _focusNodes[index + 1].requestFocus();
    }
    _checkCodeCompletion();
  }


  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (_, controller) => Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            SizedBox(height: 70),

            SectionTitle(
              title: "Get Your Code",
              description: "Please enter the 4-digit code sent \nto your email address.",
              text: "Verify",
              onSubmit: _isButtonEnabled
                  ? () {
                    verifyCode();
                    widget.onNext();
                  }
                  : () {},
              children: [
                SizedBox(
                  width: 330,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (index) {
                      return Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.tertiary, width: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.surface,
                        ),
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: GoogleFonts.urbanist(
                            fontSize: 24,
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.secondary,
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => _onChanged(index, value),
                        ),
                      );
                    }),
                  ),
                ),

                SizedBox(height: 30),

                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Didn't receive the code? ",
                          style: GoogleFonts.urbanist(
                            color: AppColors.primary,
                            fontSize: 14,
                          ),
                        ),

                        TextSpan(
                          text: _canResend
                              ? "Send again"
                              : _formatTime(_secondsRemaining),
                          style: GoogleFonts.urbanist(
                              color: _canResend
                                  ? AppColors.secondary
                                  : AppColors.tertiary,
                              fontSize: 15,
                              fontWeight: _canResend
                                  ? AppFontWeight.bold
                                  : AppFontWeight.semiBold
                          ),
                          recognizer: _canResend
                              ? (TapGestureRecognizer()..onTap = _resendCode)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
