import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../theme/colors.dart';
import '../../service/challenge_service.dart';
import '../../service/tree_service.dart';
import '../../widget/bar_title.dart';
import '../../widget/custom_dialog.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({super.key});

  @override
  State<DailyChallengeScreen> createState() => _DailyChallengeScreenState();
}

class _DailyChallengeScreenState extends State<DailyChallengeScreen> {
  Map<String, dynamic>? _challengeData;
  final Map<String, bool> _itemDragged = {};
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  Future<void> getChallenge() async {
    try {
      await TreeService().increaseDrops(userId, 5);
      print("Challenge drops increased successfully.");
    } catch (e) {
      print("Error in getChallenge: $e");
    }
  }

  Future<void> completeChallenge() async {
    try {
      await ChallengeService().completeChallenge(userId);
      print("Challenge completed successfully.");
    } catch (e) {
      print("Error in completeChallenge: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
      color: AppColors.secondary,
        child: Column(
          children: [
            BarTitle(title: 'Today\'s Challenge', showBackButton: true),

            SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                height: getPhoneHeight(context) - 100,
                color: AppColors.background,
                child: Center(
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: ChallengeService().loadDailyChallenge(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const Center(child: Text('Failed to load challenge.'));
                      } else {
                        _challengeData = snapshot.data!;
                        if (_challengeData!['type'] == 'daily' && _challengeData!['subtype'] == 'quiz') {
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: _buildQuiz(),
                          );
                        } else if (_challengeData!['type'] == 'daily' && _challengeData!['subtype'] == 'dragdrop') {
                          return Padding(
                            padding: const EdgeInsets.all(30),
                            child: _buildDragDropGame(),
                          );
                        } else {
                          return const Center(child: Text('Unsupported challenge type.'));
                        }
                      }
                    },
                  ),
                )
              ),
            )
          ]
        )
      )
    );
  }

  /// QUIZ QUESTION
  Widget _buildQuiz() {
    String question = _challengeData!['question'];
    List<String> options = List<String>.from(_challengeData!['options']);
    int correct = _challengeData!['correct'];

    int? selectedIndex = -1;
    bool answered = false;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            question,
            style: GoogleFonts.urbanist(
              fontSize: 30,
              fontWeight: AppFontWeight.bold,
              color: AppColors.primary,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          StatefulBuilder(
            builder: (context, setLocalState) {
              return Column(
                children: options.asMap().entries.map((entry) {
                  final index = entry.key;
                  final optionText = entry.value;

                  Color buttonColor = AppColors.surface;
                  Color textColor = AppColors.secondary;

                  if (answered) {
                    if (index == correct) {
                      buttonColor = Color(0xFF0C8047);
                      textColor = AppColors.surface;
                    } else if (index == selectedIndex) {
                      buttonColor = Color(0xFFC62828);
                      textColor = AppColors.surface;
                    } else {
                      buttonColor = Color(0xFFD3D3D3);
                      textColor = Color(0xFF808080);
                    }
                  } else {
                    buttonColor = AppColors.surface;
                    textColor = AppColors.secondary;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black12),
                      ),
                      width: double.infinity,
                      height: 80,
                      child: Material(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: answered
                              ? null
                              : () {
                            setLocalState(() {
                              selectedIndex = index;
                            });

                            Future.delayed(const Duration(milliseconds: 300), () {
                              setLocalState(() {
                                answered = true;
                              });
                            });

                            _showResultDialog(selectedIndex == correct);

                            if (selectedIndex == correct) {
                              getChallenge();
                              completeChallenge();
                            }
                          },
                          child: Center(
                            child: Text(
                              optionText,
                              style: GoogleFonts.urbanist(
                                fontSize: 20,
                                fontWeight: AppFontWeight.medium,
                                color: textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  /// DRAG & DROP GAME: ORGANIC VS INORGANIC
  Widget _buildDragDropGame() {
    String question = _challengeData!['question'];
    List<dynamic> items = List.from(_challengeData!['items'])..shuffle(Random());

    List bins = [ 'recyclable', 'organic', 'hazardous', 'general'];

    Map<String, List<String>> binsContents = {
      'recyclable': [],
      'organic': [],
      'hazardous': [],
      'general': [],
    };

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question,
              style: GoogleFonts.urbanist(
                fontSize: 28,
                fontWeight: AppFontWeight.bold,
                color: AppColors.secondary,
                height: 1,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Drag items
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: items.map<Widget>((item) {
                String label = item['label'];
                String target = item['targetBin'];
                bool dragged = _itemDragged[label] == true;

                return dragged
                    ? const SizedBox.shrink()
                    : Draggable<String>(
                  data: '$label::$target',
                  feedback: Material(
                    color: Colors.transparent,
                    child: Image.asset('lib/assets/images/$label.png', height: (getPhoneWidth(context) - 100)/4),
                  ),
                  childWhenDragging: const SizedBox.shrink(),
                  child: Image.asset('lib/assets/images/$label.png', height: (getPhoneWidth(context) - 100)/4),
                );
              }).toList(),
            ),

            const SizedBox(height: 30),

            // Dynamic bins
            SizedBox(
              height: 450,
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 40,
                crossAxisSpacing: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: bins.map((binType) {
                  return DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Image.asset('lib/assets/images/${binType}_trash.png', height: 100);
                    },
                    onAccept: (data) async {
                      var parts = data.split('::');
                      String label = parts[0];
                      String correctBin = parts[1];

                      bool isCorrect = binType == correctBin;

                      setLocalState(() {
                        _itemDragged[label] = true;
                        binsContents[binType]!.add(label);
                      });

                      if (_itemDragged.length == items.length) {
                        bool allCorrect = true;
                        for (var item in items) {
                          String itemLabel = item['label'];
                          String targetBin = item['targetBin'];
                          if (!binsContents[targetBin]!.contains(itemLabel)) {
                            allCorrect = false;
                            break;
                          }
                        }
                        _showResultDialog(allCorrect);

                        if (allCorrect) {
                          await getChallenge();
                          await completeChallenge();
                        }
                      }
                    }
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(bool correct) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        message: correct
            ? 'Great job! You nailed the challenge!'
            : 'Incorrect. Better luck next time.',
        status: correct ? true : false,
        buttonTitle: "OK",
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          }
      ),
    );
  }
}
