import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/widget/bar_noti_title.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../service/challenge_service.dart';
import '../../service/user_service.dart';
import '../../utils/phone_size.dart';
import '../../utils/route_transition.dart';
import '../../widget/category_box.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/text_row.dart';
import '../auth/login_screen.dart';
import '../challenge/challenge_detail_screen.dart';
import '../challenge/community_challenge_screen.dart';
import '../challenge/community_challenge_card.dart';
import '../challenge/daily_challenge_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  final List<Map<String, String>> goodToKnowList = [
    {
      "image": "lib/assets/images/good_to_know.png",
      "title": "Smart Solutions for Waste Sorting",
      "date": "January 12, 2022"
    },
    {
      "image": "lib/assets/images/good_to_know2.png",
      "title": "Why Recycling Matters?",
      "date": "February 05, 2022"
    },
    {
      "image": "lib/assets/images/good_to_know3.png",
      "title": "Eco-Friendly Waste Disposal Tips",
      "date": "March 18, 2022"
    }
  ];

  @override
  void initState() {
    super.initState();
    if (_isUserLoggedIn()) {
      _handleStreakCheck();
    }
  }

  void _handleStreakCheck() async {
    await ChallengeService().checkMissedDay(userId);
    await ChallengeService().updateWeeklyProgressForTasks(userId, 'streak');
  }

  bool _isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        message: 'Please log in to upload evidence.',
        status: false,
        buttonTitle: "Login",
        isDirect: true,
        onPressed: () {
          Navigator.pop(context);
          Navigator.of(context).push(
            moveUpRoute(
              LoginScreen(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            userId.isEmpty
                ? const BarNotiTitle(title_small: "Hello", title_big: 'Guest')
                : StreamBuilder<Map<String, dynamic>>(
                    stream: UserService().getCurrentUser(userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const BarNotiTitle(title_small: "Hello", title_big: 'Guest');
                      }

                      final user = snapshot.data ?? {
                        'photoUrl': '',
                        'name': userId.length >= 10 ? userId.substring(0, 10) : userId,
                        'email': '',
                      };

                      return BarNotiTitle(title_small: "Hello", title_big: user['name'] ?? 'Guest');
                    }
                  ),

            const SizedBox(height: 25),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Container(
                            width: phoneWidth - 40,
                            height: 170,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(-1, -1),
                                end: Alignment(1, 1),
                                colors: [Color(0xFF2C6E49), Color(0xFF56725F)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: -7,
                            right: -10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "lib/assets/images/img_home.png",
                                height: 170,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 25,
                            left: 20,
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.urbanist(
                                      color: AppColors.surface,
                                      height: 1.2,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Have you sorted\n',
                                        style: GoogleFonts.urbanist(
                                          fontSize: phoneWidth * 0.043,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'waste today?\n',
                                        style: GoogleFonts.urbanist(
                                          fontSize: phoneWidth * 0.043,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: '\n', style: TextStyle(fontSize: 6)),
                                      TextSpan(
                                        text: 'Upload your evidence\n',
                                        style: GoogleFonts.urbanist(
                                          fontSize: phoneWidth * 0.03,
                                          fontWeight: AppFontWeight.regular,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'to get bonus point.',
                                        style: GoogleFonts.urbanist(
                                          fontSize: phoneWidth * 0.03,
                                          fontWeight: AppFontWeight.regular,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),

                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: () {
                                if (_isUserLoggedIn()) {
                                  Navigator.of(context).push(
                                    moveUpRoute(
                                      UploadScreen(),
                                    ),
                                  );
                                } else {
                                  _showErrorDialog(context);
                                }
                              },
                              child: Container(
                                width: 60,
                                height: 28,
                                padding: const EdgeInsets.all(5),
                                decoration: ShapeDecoration(
                                  color: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Upload',
                                    style: GoogleFonts.urbanist(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: AppFontWeight.semiBold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Categories",
                          style: GoogleFonts.urbanist(
                            color: AppColors.secondary,
                            fontSize: 16,
                            fontWeight: AppFontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      )
                    ),

                    const SizedBox(height: 10),

                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CategoryBox(image: 'lib/assets/icons/ic_recyclable.svg', text: 'Recyclable', slide: 0,),
                          CategoryBox(image: 'lib/assets/icons/ic_organic.svg', text: 'Organic', slide: 1,),
                          CategoryBox(image: 'lib/assets/icons/ic_hazardous.svg', text: 'Hazardous', slide: 2,),
                          CategoryBox(image: 'lib/assets/icons/ic_general.svg', text: 'General', slide: 3,),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    if (_isUserLoggedIn()) ...[
                      Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Your daily mission",
                              style: GoogleFonts.urbanist(
                                color: AppColors.secondary,
                                fontSize: 16,
                                fontWeight: AppFontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          )
                      ),

                      const SizedBox(height: 10),
                      SizedBox(
                        width: phoneWidth - 40,
                        child: StreamBuilder<bool>(
                          stream: ChallengeService().hasCompletedToday(userId),
                          builder: (context, completedSnap) {
                            final isCompleted = completedSnap.data ?? false;

                            return AbsorbPointer(
                              absorbing: isCompleted,
                              child: GestureDetector(
                                onTap: isCompleted
                                    ? null
                                    : () {
                                  Navigator.of(context).push(
                                    scaleRoute(DailyChallengeScreen()),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Daily Challenge',
                                              style: GoogleFonts.urbanist(
                                                fontSize: 24,
                                                fontWeight: AppFontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.local_fire_department,
                                                  color: Colors.deepOrange,
                                                  size: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                StreamBuilder<int>(
                                                  stream: UserService().getUserStreak(userId),
                                                  builder: (context, streakSnap) {
                                                    final streak = streakSnap.data ?? 0;
                                                    return Text(
                                                      '$streak ${streak == 1 ? "day" : "days"} streak',
                                                      style: GoogleFonts.urbanist(
                                                        fontWeight: AppFontWeight.medium,
                                                        fontSize: 14,
                                                        color: AppColors.secondary,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        isCompleted
                                            ? Icons.check
                                            : Icons.arrow_forward_ios,
                                        size: isCompleted ? 25 : 20,
                                        color: AppColors.secondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextRow(
                        text: 'Challenges',
                        onTap: () {
                          Navigator.of(context).push(
                            moveUpRoute(
                              CommunityChallengeScreen(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    FutureBuilder<List<QueryDocumentSnapshot>>(
                      future: ChallengeService().loadChallenges('community'),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No community challenges available.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.urbanist(
                                color: AppColors.secondary,
                                fontSize: 16,
                                fontWeight: AppFontWeight.medium,
                              ),
                            ),
                          );
                        }

                        final challenges = snapshot.data!;

                        final limitedChallenges = challenges.take(3).toList();


                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: limitedChallenges.length,
                          itemBuilder: (context, index) {
                            final doc = challenges[index];
                            final data = doc.data() as Map<String, dynamic>;
                            data['id'] = doc.id;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChallengeDetailScreen(data: data, challengeId: data['id']),
                                  ),
                                );
                              },
                              child: CommunityChallengeCard(data: data)
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 5),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextRow(text: 'Good to know'),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      height: 160,
                      width: phoneWidth - 40,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 3,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          var item = goodToKnowList[index];
                          return Column(
                            children: [
                              Container(
                                width: phoneWidth - 40,
                                height: 100,
                                decoration: ShapeDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(item['image']!),
                                    fit: BoxFit.fitWidth,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(left: 15, top: 5, bottom: 12),
                                width: phoneWidth - 40,
                                height: 60,
                                decoration: ShapeDecoration(
                                  color: AppColors.surface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x0C000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 1),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: GoogleFonts.urbanist(
                                        color: AppColors.secondary,
                                        fontSize: 16,
                                        fontWeight: AppFontWeight.semiBold,
                                      ),
                                    ),
                                    Text(
                                      item['date']!,
                                      style: GoogleFonts.urbanist(
                                        color: AppColors.tertiary,
                                        fontSize: 12,
                                        fontWeight: AppFontWeight.light,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          width: _currentIndex == index ? 15 : 5,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _currentIndex == index ? AppColors.secondary : Color(0xFFC4C4C4),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ]
        ),
      )
    );
  }
}


