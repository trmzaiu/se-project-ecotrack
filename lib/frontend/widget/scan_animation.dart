import 'package:flutter/cupertino.dart';

import '../../theme/colors.dart';

class ScanAnimation extends StatefulWidget {
  @override
  _ScanAnimationState createState() => _ScanAnimationState();
}

class _ScanAnimationState extends State<ScanAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * (_animation.value),
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.board2.withOpacity(0.7),
              boxShadow: [
                BoxShadow(
                  color: AppColors.board2.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
