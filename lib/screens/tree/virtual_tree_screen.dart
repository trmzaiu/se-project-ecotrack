import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:wastesortapp/services/tree_service.dart';
import 'package:wastesortapp/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../models/tree.dart';
import '../../services/challenge_service.dart';
import '../../utils/route_transition.dart';
import '../../widgets/bar_title.dart';
import 'leaderboard_screen.dart';

class VirtualTreeScreen extends StatefulWidget {

  const VirtualTreeScreen({super.key});

  @override
  _VirtualTreeScreenState createState() => _VirtualTreeScreenState();
}

class _VirtualTreeScreenState extends State<VirtualTreeScreen> with SingleTickerProviderStateMixin {
  static const Duration ANIMATION_DURATION = Duration(milliseconds: 1000);
  final TreeService _treeService = TreeService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  late AnimationController _controller;
  int neededDrops = 0;
  int grownTrees = 0;
  bool _dialogShown = false;

  int leftDrops = 0;
  int _drops = 0;
  int _trees = 0;
  int _levelOfTree = 0;
  double _progress = 0.0;

  final List<dynamic> _state = [
    ['lib/assets/images/state1.png', 5],
    ['lib/assets/images/state2.png', 15],
    ['lib/assets/images/state3.png', 30],
    ['lib/assets/images/state4.png', 50],
  ];
  StreamSubscription? _treeSubscription;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ANIMATION_DURATION,
    );
    _loadTreeData();
  }

  void _loadTreeData() {
    // Subscribe to the tree data stream for real-time updates
    _treeSubscription = _treeService.getTreeProgress(userId).listen((snapshot) {
      if (snapshot.exists) {
        Tree tree = Tree.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);

        if (!mounted) return;

        setState(() {
          _levelOfTree = (tree.levelOfTree ?? 0).clamp(0, 3);
          _progress = tree.progress ?? 0.0;
          _drops = tree.drops ?? 0;
          _trees = tree.trees ?? 0;

          leftDrops = getLeftDrops(_levelOfTree, _progress);
        });
      }
    });
  }

  @override
  void dispose() {
    _treeSubscription?.cancel();
    super.dispose();
  }

  int getLeftDrops(int state, double currentProgress) {
    int totalDrops = 0;
    List<int> reductions = [5, 15, 30, 50];

    for (int i = 0; i < state; i++) {
      totalDrops += reductions[i];
    }

    if (state < reductions.length) {
      totalDrops += (currentProgress * reductions[state]).round();
    }
    return 100 - totalDrops;
  }

  void animateProgress(double newProgress, VoidCallback onComplete) {
    if (_drops <= 0 || _controller.isAnimating) return;

    double startProgress = _progress;
    _controller.reset();

    final animation = Tween<double>(
      begin: startProgress,
      end: newProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    animation.addListener(() {
      if (_progress != animation.value) {
        setState(() {
          _progress = animation.value;
        });
      }
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 500), () {
          if (_progress >= 1.0) {
            onComplete();
          }
        });
      }
    });

    _controller.forward();
  }

  void waterTree() {
    if (_drops <= 0) {
      if (_dialogShown) return;

      _dialogShown = true;

      print("Tree: $grownTrees");
      Future.delayed(Duration(seconds: 2), () {
        if (grownTrees > 0) {
          showTreeDialog(grownTrees, 0);
        } else {
          showTreeDialog(0, _levelOfTree + 1);
        }
      });
      return;
    } else {
      int totalNeededDrops = _state[_levelOfTree][1];
      int currentNeededDrops = (totalNeededDrops * (1.0 - _progress)).round();


      if (_drops <= currentNeededDrops) {
        double newProgress = _progress + (_drops / totalNeededDrops);
        if (newProgress >= 0.99) {
          animateProgress(1.0, () {
            _levelOfTree++;

            if (_levelOfTree >= _state.length) {
              _levelOfTree = 0;
              grownTrees++;
            }
            print("Tree: $grownTrees");

            _progress = 0;

            _treeService.updateLevelOfTree(userId, _levelOfTree >= 3 ? 0 : _levelOfTree);
            _treeService.updateProgress(userId, _progress);
            leftDrops = getLeftDrops(_levelOfTree, _progress);
            print('Progress:  $_progress and newProgress: $newProgress');
          });
        } else if (newProgress < 0.99) {
          print('newProgress: $newProgress');
          animateProgress(newProgress, () {});
          setState(() {
            _progress = newProgress;
            leftDrops = getLeftDrops(_levelOfTree, _progress);
          });
          _treeService.updateProgress(userId, _progress);
          print('Progress:  $_progress and newProgress: $newProgress');
        }
        _drops = 0;
        _treeService.updateWater(userId, _drops);
        waterTree();
      } else if (_drops > currentNeededDrops) {
        _drops -= currentNeededDrops;
        _treeService.updateWater(userId, _drops);

        if (_progress <= 1.0) {
          animateProgress(1.0, () async {
            setState(() {
              _progress = 0;
              print("Before: value = $_levelOfTree");
              _levelOfTree ++;
              _treeService.updateProgress(userId, _progress);
              _treeService.updateLevelOfTree(userId, _levelOfTree);
            });

            print("After: value = $_levelOfTree");

            if (_levelOfTree >= _state.length) {
              _levelOfTree = 0;
              grownTrees++;
              _treeService.updateLevelOfTree(userId, 0);
            }

            setState(() {
              leftDrops = getLeftDrops(_levelOfTree, _progress);
            });

            waterTree();
          });
        }
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
                Image.asset('lib/assets/images/state4.png', width: getPhoneWidth(context)/3.5),
                SizedBox(height: 10),
                Text(
                    "Congratulations! You have grown $totalTrees ${totalTrees >
                        1 ? 'trees' : 'tree'}!",
                    style: GoogleFonts.urbanist(color: AppColors.secondary)
                ),
              ] else
                ...[
                  Image.asset('lib/assets/images/state$state.png', width: getPhoneWidth(context)/3.5),
                  SizedBox(height: 10),
                  Text("You are at level $state",
                      style: GoogleFonts.urbanist(color: AppColors.secondary)),
                ],
            ]),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () async {
                setState(() {
                  _trees += totalTrees;
                  grownTrees = 0;
                  _dialogShown = false;
                });

                Navigator.of(context).pop();

                _treeService.updateTree(userId, _trees);
                ChallengeService().updateChallengeProgress(subtype: 'tree', value: totalTrees);

                for (int i = 0; i < totalTrees; i++) {
                  ChallengeService().updateWeeklyProgressForTasks(userId, 'tree');
                }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.primary),
              foregroundColor: WidgetStateProperty.all(AppColors.surface),
              overlayColor: WidgetStateProperty.all(Color(0x4CE7E0DA)),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
              ),
              elevation: WidgetStateProperty.all(1),
              fixedSize: WidgetStateProperty.all(Size(100, 40)),
              textStyle: WidgetStateProperty.all(
                  GoogleFonts.urbanist(fontSize: 13, fontWeight: AppFontWeight.semiBold)),
            ),
            child: (totalTrees == 0) ? Text("Continue") : Text("Donate"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext  context) {
    double phoneHeight = getPhoneHeight(context);
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Positioned(
            top: -65,
            left: -80,
            child: SizedBox(
              height: phoneHeight*0.46,
              width:phoneWidth*1.05,
              child: CustomPaint(
                painter: BlobPainter(),
              ),
            ),
          ),
          Column(
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      BarTitle(title: '', showNotification: true),
                      SizedBox(height: phoneHeight*0.035),
                    ],
                  ),
                  Positioned(
                    left: 20,
                    top: 47,
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            moveUpRoute(
                              LeaderboardScreen(),
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          'lib/assets/icons/ic_leaderboard.svg',
                          width: 24,
                          height: 24,
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(AppColors.surface),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          shadowColor: WidgetStateProperty.all(Color(0x33333333)),
                          elevation: WidgetStateProperty.all(2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: phoneHeight*0.035),
              Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 25,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // spacing: 10,
                          children: [
                            SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset('lib/assets/images/drop.png', width: 25),
                                  const SizedBox(width: 5),
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: _drops.toDouble(), end: _drops.toDouble()),
                                    duration: Duration(milliseconds: 500),
                                    builder: (_, double value, __) {
                                      return Text('${value.round()}',
                                          style: GoogleFonts.urbanist(fontSize: 30,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.secondary));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 150,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset('lib/assets/images/tree.png', width: 25),
                                  const SizedBox(width: 5),
                                  TweenAnimationBuilder(
                                    tween: Tween<double>(begin: _trees.toDouble(), end: _trees.toDouble()),
                                    duration: Duration(milliseconds: 500),
                                    builder: (_, double value, __) {
                                      return Text('${value.round()}',
                                          style: GoogleFonts.urbanist(fontSize: 30,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.secondary));
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: phoneWidth - 80,
                          width: phoneWidth - 80,
                          child: CustomPaint(
                            painter: GradientProgressPainter(progress: _progress),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                RepaintBoundary(
                                  child: Image.asset(_state[_levelOfTree][0], width: 200, height: 200),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  '${(_progress * _state[_levelOfTree][1]).round()}/${_state[_levelOfTree][1]}',
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.surface,
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        SizedBox(
                            width: 200,
                            height: phoneWidth/6,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TweenAnimationBuilder(
                                      tween: Tween<double>(begin: leftDrops.toDouble(), end: leftDrops.toDouble()),
                                      duration: Duration(milliseconds: 500),
                                      builder: (_, double value, __) {
                                        return Text('${value.round()}',
                                            style: GoogleFonts.urbanist(
                                                fontSize: 30,
                                                fontWeight: FontWeight.normal,
                                                color: AppColors.secondary));
                                      },
                                    ),
                                    // Text('$leftDrops', style: GoogleFonts.urbanist(
                                    //     fontSize: 30,
                                    //     fontWeight: FontWeight.normal,
                                    //     color: AppColors.secondary)),
                                    Image.asset(
                                        'lib/assets/images/drop.png', width: 25,
                                        height: 25),
                                  ],
                                ),
                                Text('drops of water left',
                                    style: GoogleFonts.urbanist(color: AppColors.secondary)),
                              ],
                            )
                        ),
                        ElevatedButton(
                          onPressed: _drops > 0
                              ? () {
                            waterTree();
                          } : null,
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

                            overlayColor: WidgetStateProperty.all(
                                Color(0x4CE7E0DA)),
                            shadowColor: WidgetStateProperty.all(
                                Colors.transparent),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                            ),
                            elevation: WidgetStateProperty.all(1),
                            fixedSize: WidgetStateProperty.all(Size(200, 50)),
                            textStyle: WidgetStateProperty.all(GoogleFonts.urbanist(
                                fontSize: 20, fontWeight: FontWeight.normal)),
                          ),
                          child: Text('Watering'),
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
        ],
      )
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

class BlobPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0
      ..color = Colors.black
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFCFF7D3),
          Color(0xFFD3F8D6),
          Color(0xFFD6F9DA),
          Color(0xFFDDFBE1),
          Color(0xFFEBFFEE),
        ],
        stops: [0.0, 0.5, 0.75, 0.88, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path path = Path();
    path.moveTo(size.width * 0.5, size.height * 0.02); // Điểm bắt đầu (đầu dài hơn)

// Phần trên cùng được kéo dài hơn
    path.cubicTo(size.width * 1.2, size.height * 0.05,
        size.width * 1.1, size.height * -0.3,
        size.width * 1.3, size.height * 0.25);

// Làm mượt đường cong bên phải
    path.cubicTo(size.width * 1.2, size.height * 1.0,
        size.width * 1.15, size.height * 1.1,
        size.width * 1.3, size.height * 1.2);

// Bo tròn phần đáy tránh nhọn
    path.cubicTo(size.width * 1.15, size.height * 1.4,
        size.width * 0.85, size.height * 1.55,
        size.width * 0.7, size.height * 1.6);

// Làm mềm phần góc dưới
    path.cubicTo(size.width * 0.55, size.height * 1.65,
        size.width * 0.3, size.height * 1.6,
        size.width * 0.2, size.height * 1.4);

// Làm mượt phần dưới bên trái
    path.cubicTo(size.width * 0.12, size.height * 1.2,
        size.width * 0.12, size.height * 1.0,
        size.width * 0.15, size.height * 0.8);

// Đóng đường Path với phần trên dài hơn
    path.cubicTo(size.width * 0.1, size.height * 0.1,
        size.width * -0.1, size.height * 0.05,
        size.width * 0.5, size.height * 0.02);

    path.close();

    canvas.drawPath(path, paint);

    Paint outlinePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, outlinePaint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}