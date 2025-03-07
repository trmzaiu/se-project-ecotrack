import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/svg.dart';
import 'package:wastesortapp/theme/colors.dart';

class VirtualTreeScreen extends StatefulWidget {
  const VirtualTreeScreen({super.key});

  @override
  _VirtualTreeScreenState createState() => _VirtualTreeScreenState();
}

class _VirtualTreeScreenState extends State<VirtualTreeScreen> {
  double progress = 0.0;
  String state = 'lib/assets/images/state1.png';
  int value = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          // SizedBox(width: 20),
          SvgPicture.asset(
            'lib/assets/icons/ic_leaderboard.svg',
            width: 30,
            height: 30,
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 20,
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('lib/assets/images/drop.png', width: 25),
                      Text('10', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/images/tree.png', width: 25),
                      Text('100', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal)),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: CustomPaint(
                painter: GradientProgressPainter(progress: progress),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(state, width: 200, height: 200),
                    SizedBox(height: 20),
                    Text(
                      '${(progress * 20).toInt()}/20',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: AppColors.surface,
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),

            SizedBox(
              width: 200,
              height: 80,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('5', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal)),
                      Image.asset('lib/assets/images/drop.png', width: 25, height: 25),
                    ],
                  ),
                  Text('drops of water left')
                ],
              )
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (progress > 1) {
                    value++;
                    progress = 0;
                    state = getState(value);
                  } else
                    progress = (progress + 0.05);
                });
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                foregroundColor: WidgetStateProperty.all(AppColors.primary),
                overlayColor: WidgetStateProperty.all(Color(0x4CE7E0DA)),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                elevation: WidgetStateProperty.all(1),
                side: WidgetStateProperty.all(BorderSide(color: AppColors.primary, width: 1)),
                fixedSize: WidgetStateProperty.all(Size(200, 50)),
                textStyle: WidgetStateProperty.all(TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
              ),
              child: Text('Watering'),
            ),
          ],
        ),
      ),
    );
  }

  String getState(int value) {
    if (value % 4 == 1) return 'lib/assets/images/state1.png';
    if (value % 4 == 2) return 'lib/assets/images/state2.png';
    if (value % 4 == 3) return 'lib/assets/images/state3.png';
    return 'lib/assets/images/state4.png';
  }
}

class GradientProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;

  GradientProgressPainter({
    this.progress = 0.0,
    this.strokeWidth = 50,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress.clamp(0, 1);

    final backgroundPaint = Paint()
      ..color = Color(0x332C6E49)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    final gradientPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: sweepAngle,
        colors: [
          Color(0xFF54D48C),
          Color(0xFF52CD88),
          Color(0xFF4FC784),
          Color(0xFF4ABA7B),
          Color(0xFF40A16A),
          Color(0xFF2C6E49),
          Color(0xFF54D48C),
          Color(0xFF52CD88),
        ],
        stops: [0.1, 0.2, 0.4, 0.65, 0.75, 0.8, 0.9, 1.0],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, startAngle, sweepAngle, false, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
