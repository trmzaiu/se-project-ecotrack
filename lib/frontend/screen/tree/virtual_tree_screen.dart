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
  int neededDrops = 0;
  int drops = 300;
  int leftDrops = 100;
  int trees = 0;
  int value = 0;

  final List<dynamic> _state = [
    ['lib/assets/images/state1.png', 5],
    ['lib/assets/images/state2.png', 15],
    ['lib/assets/images/state3.png', 30],
    ['lib/assets/images/state4.png', 50],
  ];


  void showTreeDialog(bool isDonated, int state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text("Congratulations!"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDonated) ...[
                Image.asset('lib/assets/images/state4.png', width: 100, height: 100),
                SizedBox(height: 10),
                Text("Congratulations! You have grown a tree!"),
              ] else ...[
                Image.asset('lib/assets/images/state${state + 1}.png', width: 100, height: 100),
                SizedBox(height: 10),
                Text("Congratulations! You are at level ${state + 1}"),
              ],
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.primary),
                foregroundColor: WidgetStateProperty.all(AppColors.surface),
                overlayColor: WidgetStateProperty.all(Color(0x4CE7E0DA)),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                elevation: WidgetStateProperty.all(1),
                fixedSize: WidgetStateProperty.all(Size(100, 40)),
                textStyle: WidgetStateProperty.all(TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
              ),
              child: isDonated ? Text("Donate") : Text("Continue"),
            ),
          ],
        );
      },
    );
  }

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
                      Text('$drops', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('lib/assets/images/tree.png', width: 25),
                      Text('$trees', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal)),
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
                    Image.asset(_state[value][0], width: 200, height: 200),
                    SizedBox(height: 20),
                    Text(
                      '${(progress * _state[value][1]).round()}/${_state[value][1]}',
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
                      Text('$leftDrops', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal)),
                      Image.asset('lib/assets/images/drop.png', width: 25, height: 25),
                    ],
                  ),
                  Text('drops of water left')
                ],
              )
            ),
            ElevatedButton(
              onPressed: drops > 0
                  ? () {
                leftDrops = 100 + neededDrops - drops;
                setState(() {
                  while (value < _state.length && drops > 0) {
                    neededDrops = (_state[value][1] - (progress * _state[value][1])).ceil();
                    if (drops >= neededDrops) {
                      drops -= neededDrops;
                      progress = 0;
                      value++;
                    } else {
                      progress += (drops / _state[value][1]);
                      drops = 0;
                    }

                    if (value == _state.length) {
                      trees++;
                      value = 0;
                      progress = 0;
                      showTreeDialog(true, 0);
                    }
                  }
                  showTreeDialog(false, value);
                });
              } : null,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.transparent;
                  },
                ),
                foregroundColor: WidgetStateProperty.all(AppColors.primary),
                overlayColor: WidgetStateProperty.all(Color(0x4CE7E0DA)),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
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
