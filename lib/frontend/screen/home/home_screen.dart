import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/widget/bar_noti_title.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../service/user_service.dart';
import '../../utils/phone_size.dart';
import '../../utils/route_transition.dart';
import '../../widget/category_box.dart';
import '../../widget/challenge_item.dart';
import '../../widget/custom_dialog.dart';
import '../../widget/text_row.dart';
import '../auth/login_screen.dart';

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
            FutureBuilder<Map<String, dynamic>>(
              future: UserService().getCurrentUser(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return BarNotiTitle(title_small: "Hello", title_big: '');
                }
                final isLoggedIn = userId.isNotEmpty;
                final user = snapshot.data ?? {
                  'photoUrl': '',
                  'name': isLoggedIn
                      ? (userId.length >= 10 ? userId.substring(0, 10) : userId)
                      : 'Guest',
                  'email': '',
                };
                return BarNotiTitle(title_small: "Hello", title_big: user['name'] ?? 'Guest');
              }
            ),

            SizedBox(height: 25),

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
                            child: SizedBox(
                              width: 135,
                              height: 40,
                              child: Text(
                                'Have you sorted waste today?',
                                style: GoogleFonts.urbanist(
                                  color: AppColors.surface,
                                  fontSize: phoneWidth * 0.5 * 0.1,
                                  fontWeight: AppFontWeight.bold,
                                  height: 0.9,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 70,
                            left: 20,
                            child: SizedBox(
                              width: (phoneWidth - 40)/3,
                              child: Text(
                                'Upload your evidence \nto get bonus point.',
                                style: GoogleFonts.urbanist(
                                  color: AppColors.surface,
                                  fontSize: phoneWidth * 0.3 * 0.1,
                                  fontWeight: AppFontWeight.regular,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
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

                    SizedBox(height: 20),

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

                    SizedBox(height: 10),

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

                    SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextRow(text: 'Good to know'),
                    ),

                    SizedBox(height: 10),

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

                    SizedBox(height: 10),

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

                    SizedBox(height: 20),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextRow(text: 'Challenges'),
                    ),

                    SizedBox(height: 30),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ChallengeItem(
                        image: 'lib/assets/images/zero_waste_challenge.png',
                        title: 'Zero Waste Challenge',
                        info: 'Reduce your waste for a whole week! Track your trash, use reusable items, and share your progress with #ZeroWasteWeek.',
                        attend: '345',
                      ),
                    ),

                    SizedBox(height: 35),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ChallengeItem(
                        image: 'lib/assets/images/trash_to_treasure_challenge.png',
                        title: 'Trash to Treasure Challenge',
                        info: 'Turn waste into something useful! Up cycle old materials into creative DIY products and share with #TrashToTreasure.',
                        attend: '243',
                      ),
                    ),

                    SizedBox(height: 35),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ChallengeItem(
                        image: 'lib/assets/images/waste_sorting_challenge.png',
                        title: 'Waste Sorting Challenge',
                        info: 'Test your skills! Correctly classify waste and promote a cleaner planet.',
                        attend: '476',
                      ),
                    ),

                    SizedBox(height: 40),
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


