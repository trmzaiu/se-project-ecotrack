import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_svg/svg.dart';
import 'package:wastesortapp/theme/colors.dart';

import 'leaderboard_screen.dart';

class VirtualTreeScreen extends StatefulWidget {
  const VirtualTreeScreen({super.key});

  @override
  _VirtualTreeScreenState createState() => _VirtualTreeScreenState();
}

class _VirtualTreeScreenState extends State<VirtualTreeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int neededDrops = 0;
  int grownTrees = 0;

  //BE link data
  double progress = 0.5;
  int leftDrops = 100;
  int drops = 1000;
  int trees = 1000;
  int value = 2;

  final List<dynamic> _state = [
    ['lib/assets/images/state1.png', 5],
    ['lib/assets/images/state2.png', 15],
    ['lib/assets/images/state3.png', 30],
    ['lib/assets/images/state4.png', 50],
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateProgress(double newProgress, VoidCallback onComplete) {
    if (drops <= 0) return;

    if (_controller.isAnimating) return;

    _controller.reset();

    final animation = Tween<double>(
      begin: progress,
      end: newProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    animation.addListener(() {
      setState(() {
        progress = animation.value;
      });
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 0), () {
          if (progress >= 1.0) {
            onComplete();
          }
        });
      }
    });

    _controller.forward();
  }

  void waterTree() {
    if (drops <= 0) {
      Future.delayed(Duration(milliseconds: 0), () {
        if (grownTrees > 0) {
          showTreeDialog(grownTrees, 0);
          grownTrees = 0;
        } else {
          showTreeDialog(0, value + 1);
        }
      });
      return;
    }

    int totalNeededDrops = _state[value][1];
    int currentNeededDrops = (totalNeededDrops * (1.0 - progress)).round();

    print("Before: value = $value, drops = $drops, needed = $currentNeededDrops, progress = $progress");

    if (drops < currentNeededDrops) {
      // If not enough to level up, increase progress
      double newProgress = progress + (drops / totalNeededDrops);
      leftDrops = (leftDrops - drops) % 100;
      animateProgress(newProgress, () {});
      drops = 0;
      waterTree();
    } else {
      drops -= currentNeededDrops;

      if (progress < 1.0) {
        animateProgress(1.0, () {
          setState(() {
            progress = 0;
            value += 1;
            print("After: value = $value");

            if (value >= _state.length) {
              value = 0;
              grownTrees++; // Count trees grown in this session
            }

            waterTree(); // Continue the process
          });
        });
        leftDrops = (leftDrops - currentNeededDrops) % 100;
      }
      if (drops == 0) {
        waterTree();
        grownTrees++;
      }
    }
  }

  void showTreeDialog(int totalTrees, int state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (totalTrees > 0) ...[
                Image.asset('lib/assets/images/state4.png', width: 100, height: 100),
                SizedBox(height: 10),
                Text(
                "Congratulations! You have grown ${totalTrees} ${totalTrees > 1 ? 'trees' : 'tree'}!",
                style: TextStyle(color: AppColors.secondary)
                ),
              ] else ...[
                Image.asset('lib/assets/images/state$state.png', width: 100, height: 100),
                SizedBox(height: 10),
                Text("You are at level $state", style: TextStyle(color: AppColors.secondary)),
            ],
          ]),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  trees += totalTrees; // Ensure the UI updates before closing
                });
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.primary),
                foregroundColor: WidgetStateProperty.all(AppColors.surface),
                overlayColor: WidgetStateProperty.all(Color(0x4CE7E0DA)),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                elevation: WidgetStateProperty.all(1),
                fixedSize: WidgetStateProperty.all(Size(100, 40)),
                textStyle: WidgetStateProperty.all(TextStyle(fontSize: 13, fontWeight: FontWeight.normal)),
              ),
              child: (totalTrees == 0) ?Text("Continue") : Text("Donate"),
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LeaderboardScreen(),
                ),
              );
            },
            child: SvgPicture.asset(
              'lib/assets/icons/ic_leaderboard.svg',
              width: 30,
              height: 30,
            ),
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
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset('lib/assets/images/drop.png', width: 25),
                      SizedBox(width: 5),
                      Text('$drops', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal, color: AppColors.secondary)),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('lib/assets/images/tree.png', width: 25),
                      SizedBox(width: 5),
                      Text('$trees', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal, color: AppColors.secondary)),
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
                      Text('$leftDrops', style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal, color: AppColors.secondary)),
                      Image.asset('lib/assets/images/drop.png', width: 25, height: 25),
                    ],
                  ),
                  Text('drops of water left', style: TextStyle(color: AppColors.secondary)),
                ],
              )
            ),
            ElevatedButton(
              onPressed: drops > 0
                  ? () {waterTree();} : null,

              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return Colors.grey;
                    }
                    return AppColors.primary;
                  },
                ),
                foregroundColor: WidgetStateProperty.all(AppColors.surface),
                overlayColor: WidgetStateProperty.all(Color(0x4CE7E0DA)),
                shadowColor: WidgetStateProperty.all(Colors.transparent),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                elevation: WidgetStateProperty.all(1),
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
