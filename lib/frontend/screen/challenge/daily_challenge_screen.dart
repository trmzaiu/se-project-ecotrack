import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../database/model/challenge.dart';
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

  Future<void> completeChallenge(int value) async {
    try {
      await ChallengeService().completeChallenge(userId, value);
      print("Challenge completed successfully.");
    } catch (e) {
      print("Error in completeChallenge: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
      color: AppColors.secondary,
        child: Column(
          children: [
            BarTitle(title: 'Today\'s Challenge', showBackButton: true),

            SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.background,
                child: SingleChildScrollView(
                  child: FutureBuilder<DailyChallenge?>(
                    future: ChallengeService().loadDailyChallenge(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          margin: const EdgeInsets.only(top: 60),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const Center(child: Text('Failed to load challenge.'));
                      } else {
                        final challenge = snapshot.data!;
                        if (challenge is DailyQuizChallenge) {
                          return Container(
                            padding: const EdgeInsets.all(30),
                            margin: const EdgeInsets.only(top: 60),
                            child: _buildQuiz(challenge),
                          );
                        } else if (challenge is DailyDragDropChallenge) {
                          return Container(
                            padding: const EdgeInsets.all(30),
                            margin: const EdgeInsets.only(top: 30),
                            child: _buildDragDropGame(challenge),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(top: 60),
                            child: Center(
                              child: Text(
                                'Unsupported challenge type.',
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.medium,
                                  color: AppColors.secondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
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
  Widget _buildQuiz(DailyQuizChallenge challenge) {
    String question = challenge.question;
    List<String> options = challenge.options;
    int correct = challenge.correct;

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
                              : () async {
                            setLocalState(() {
                              selectedIndex = index;
                            });

                            Future.delayed(const Duration(milliseconds: 300), () {
                              setLocalState(() {
                                answered = true;
                              });
                            });

                            await Future.delayed(Duration(seconds: 2), () {
                              _showResultDialog(selectedIndex == correct);
                            });

                            if (selectedIndex == correct) {
                              await getChallenge();
                              await completeChallenge(1);
                            } else {
                              await completeChallenge(0);
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
  Widget _buildDragDropGame(DailyDragDropChallenge challenge) {
    String question = challenge.question;
    List<dynamic> items = List.from(challenge.items)..shuffle(Random());

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
                        await Future.delayed(Duration(seconds: 2), () {
                          _showResultDialog(allCorrect);
                        });

                        if (allCorrect) {
                          await getChallenge();
                          await completeChallenge(1);
                        } else {
                          await completeChallenge(0);
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
