import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/widget/bar_noti_title.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../database/model/challenge.dart';
import '../../../database/model/user.dart';
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
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> goodToKnowList = [
    {
      'title': 'Turning Waste Into Resources',
      'image': 'https://image-en.nhandan.vn/w800/Uploaded/2025/kdrejwqxj/2024_12_30/41111-4701-205-4501.jpg',
      'url': 'https://en.nhandan.vn/turning-waste-into-resources-with-sorting-post142814.html',
      'date': 'December 30, 2024'
    },
    {
      'title': 'Garbage Sorting Guidelines',
      'image': 'https://www.reelpaper.com/cdn/shop/articles/understanding-the-different-types-of-waste-the-reel-talk-864585_1024x1024.jpg?v=1698211553',
      'url': 'https://www.reelpaper.com/blogs/reel-talk/types-of-waste?srsltid=AfmBOoqX4UKmsOBfjyTiazu2SpuKwGgajcvoVZ1LvMkFcYXSSBudAQ8K',
      'date': 'October 23, 2023'
    },
    {
      'title': 'Waste Sorting At Home',
      'image': 'https://image.vietnamnews.vn/uploadvnnews/Article/2022/3/1/202968_e6a_vwpf.jpg',
      'url': 'https://vietnamnews.vn/environment/1160427/waste-sorting-at-home-a-little-act-with-a-big-impact.html',
      'date': 'March 01, 2022'
    },
  ];

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    debugPrint('Opening: $url');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Could not launch $url');
    }
  }

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
    await ChallengeService().loadWeeklyChallenge(userId);
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
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: AppColors.background,
        child: Column(
          children: [
            userId.isEmpty
                ? const BarNotiTitle(title_small: 'Hello', title_big: 'Guest')
                : StreamBuilder<Users?>(
                stream: UserService().getCurrentUser(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const BarNotiTitle(title_small: 'Hello', title_big: 'Guest');
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const BarNotiTitle(title_small: 'Hello', title_big: 'Guest');
                  }

                  final user = snapshot.data!;

                  return BarNotiTitle(title_small: 'Hello', title_big: user.name);
                }
            ),

            const SizedBox(height: 25),

            Expanded(
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
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
                                    Navigator.of(context).pushAndRemoveUntil(
                                      moveLeftRoute(
                                        UploadScreen(),
                                        settings: RouteSettings(name: "UploadScreen"),
                                      ),
                                          (route) => route.settings.name != "ScanScreen" || route.isFirst,
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

                    Align(
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
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CategoryBox(image: 'lib/assets/icons/ic_recyclable.svg', text: 'Recyclable', slide: 0,),
                        CategoryBox(image: 'lib/assets/icons/ic_organic.svg', text: 'Organic', slide: 1,),
                        CategoryBox(image: 'lib/assets/icons/ic_hazardous.svg', text: 'Hazardous', slide: 2,),
                        CategoryBox(image: 'lib/assets/icons/ic_general.svg', text: 'General', slide: 3,),
                      ],
                    ),

                    const SizedBox(height: 25),

                    if (_isUserLoggedIn()) ...[
                      Align(
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
                      ),

                      const SizedBox(height: 10),
                      StreamBuilder<bool>(
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
                                  color: AppColors.secondary,
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
                                              color: AppColors.surface,
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
                                              StreamBuilder<Users?>(
                                                stream: UserService().getCurrentUser(userId),
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return const SizedBox();
                                                  }

                                                  if (!snapshot.hasData || snapshot.data == null) {
                                                    return const SizedBox();
                                                  }

                                                  final streak = snapshot.data!.streak;
                                                  return Text(
                                                    '$streak ${streak == 1 ? "day" : "days"} streak',
                                                    style: GoogleFonts.urbanist(
                                                        fontWeight: AppFontWeight.medium,
                                                        fontSize: 14,
                                                        color: AppColors.surface
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
                                      color: AppColors.surface
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 25),
                    ],

                    FutureBuilder<List<CommunityChallenge>>(
                      future: ChallengeService().loadCommunityChallenges(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return SizedBox();
                        }

                        final challenges = snapshot.data!;
                        final limitedChallenges = challenges.take(3).toList();

                        return Column(
                          children: [
                            TextRow(
                              text: 'Challenges',
                              onTap: () {
                                Navigator.of(context).push(
                                  moveUpRoute(
                                    CommunityChallengeScreen(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 10),

                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(top: 0),
                              itemCount: limitedChallenges.length,
                              itemBuilder: (context, index) {
                                final challenge = limitedChallenges[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      scaleRoute(
                                        ChallengeDetailScreen(challengeId: challenge.id),
                                      ),
                                    );
                                  },
                                  child: CommunityChallengeCard(challenge: challenge)
                                );
                              },
                            )
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 5),

                    TextRow(text: 'Good to know'),

                    const SizedBox(height: 10),

                    SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(goodToKnowList.length, (index) {
                          var item = goodToKnowList[index];
                          return GestureDetector(
                            onTap: () {
                              debugPrint("Opening: ${item['url']}");
                              _launchUrl(item['url']!);
                            },
                            child: Container(
                              width: 330,
                              margin: EdgeInsets.only(right: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 120,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(item['image']!),
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
                                    width: double.infinity,
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
                                            fontSize: 18,
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
                              ),
                            ),
                          );
                        }),
                      ),
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


