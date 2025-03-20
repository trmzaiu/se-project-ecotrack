import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/guide/guide_detail_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../utils/phone_size.dart';
import '../../widget/bar_title.dart';

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000);
    _autoSlide();
  }

  void _autoSlide() {
    Future.delayed(Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        _autoSlide();
      }
    });
  }

  void _goToScreen(int index) {
    Widget nextScreen;

    switch (index % 4) {
      case 0:
        nextScreen = GuideDetailScreen(slide: 0);
        break;
      case 1:
        nextScreen = GuideDetailScreen(slide: 1);
        break;
      case 2:
        nextScreen = GuideDetailScreen(slide: 2);
        break;
      case 3:
        nextScreen = GuideDetailScreen(slide: 3);
        break;
      default:
        nextScreen = GuideDetailScreen(slide: 4);
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double phoneHeight = getPhoneHeight(context);
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Circle
          Positioned(
            top: -450,
            left: MediaQuery.of(context).size.width / 2 - 400,
            child: Container(
              width: 800,
              height: 800,
              decoration: BoxDecoration(
                color: Color(0xFF7C3F3E),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SizedBox(
            width: phoneWidth,
            height: phoneHeight,
            child: Column(
              children: [
                BarTitle(title: 'Guide', showNotification: true),
                SizedBox(
                  height: 540,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index % 4;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildWasteSlide(index % 4);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () => _goToScreen(_currentIndex),
                  child: Container(
                    width: 280,
                    height: 45,
                    decoration: ShapeDecoration(
                      color: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Read More',
                      style: GoogleFonts.urbanist(
                        color: AppColors.surface,
                        fontSize: 14,
                        fontWeight: AppFontWeight.medium,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      width: _currentIndex == index ? 10 : 5,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _currentIndex == index ? AppColors.secondary : Color(0xFFC4C4C4),
                      ),
                    );
                  }),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildWasteSlide(int index) {

    final List<String> titles = [
      "Recyclable Waste",
      "Organic Waste",
      "Hazardous Waste",
      "General Waste",
    ];

    final List<String> descriptions = [
      "Waste that can be processed into new materials through recycling methods.",
      "Biodegradable materials that naturally break down and return to the environment.",
      "Harmful substances that pose risks to human health and the environment.",
      "Non-recyclable materials that cannot be reused or naturally decomposed.",
    ];

    final List<String> images = [
      "lib/assets/images/recycle_bin.png",
      "lib/assets/images/organic_bin.png",
      "lib/assets/images/hazardous_bin.png",
      "lib/assets/images/general_bin.png",
    ];

    return Column(
      children: [
        SizedBox(height: 40),
        Image.asset(images[index], height: 320),
        SizedBox(height: 30),
        Text(
          titles[index],
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: AppColors.secondary,
            fontSize: 30,
            fontWeight: AppFontWeight.semiBold,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: 310,
          child: Text(
            descriptions[index],
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: 12,
              fontWeight: AppFontWeight.regular,
              letterSpacing: 0.70,
            ),
          ),
        ),
      ],
    );
  }
}


