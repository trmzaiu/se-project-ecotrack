import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/guide/guide_detail_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../utils/phone_size.dart';
import '../../utils/route_transition.dart';
import '../../widget/bar_title.dart';

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> with AutomaticKeepAliveClientMixin {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

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

    Navigator.of(context).push(
      moveUpRoute(
        nextScreen,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    double phoneHeight = getPhoneHeight(context);
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Circle
          Positioned(
            bottom: phoneHeight <= 700 ? phoneHeight*0.55 : phoneHeight*0.51,
            left: phoneWidth / 2 - (phoneWidth*2.1)/2,
            child: Container(
              width: phoneWidth*2.1,
              height: phoneWidth*2.1,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),

          SizedBox(
              width: phoneWidth,
              height: phoneHeight - 85,
              child: Column(
                children: [
                  BarTitle(title: 'Guide', showNotification: true),
                  SizedBox(
                    height: phoneHeight * 0.64,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index % 4;
                        });
                      },
                      itemBuilder: (context, index) {
                        return _buildWasteSlide(context, index % 4);
                      },
                    ),
                  ),

                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () => _goToScreen(_currentIndex),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: Size(phoneWidth - 100, 45),
                              ),
                              child: Text(
                                'Read More',
                                style: GoogleFonts.urbanist(
                                  color: AppColors.surface,
                                  fontSize: 14,
                                  fontWeight: AppFontWeight.medium,
                                ),
                              ),
                            ),

                            SizedBox(height: phoneWidth/8),

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
                        ),
                      )
                  )
                ],
              )
          ),
        ],
      ),
    );
  }

  Widget _buildWasteSlide(BuildContext context, int index) {
    double phoneHeight = getPhoneHeight(context);

    final List<String> titles = [
      "Recyclable Waste",
      "Organic Waste",
      "Hazardous Waste",
      "General Waste",
    ];

    final List<String> descriptions = [
      "Waste that can be processed into new \nmaterials through recycling methods.",
      "Biodegradable materials that naturally break \ndown and return to the environment.",
      "Harmful substances that pose risks to \nhuman health and the environment.",
      "Non-recyclable materials that cannot \nbe reused or naturally decomposed.",
    ];

    final List<String> images = [
      "lib/assets/images/bin_recycle.png",
      "lib/assets/images/bin_organic.png",
      "lib/assets/images/bin_hazardous.png",
      "lib/assets/images/bin_general.png",
    ];

    return Column(
      children: [
        SizedBox(height: phoneHeight*0.045),
        Image.asset(images[index], height: phoneHeight * 0.38),
        SizedBox(height: phoneHeight*0.035),
        Text(
          titles[index],
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: AppColors.secondary,
            fontSize: phoneHeight*0.036,
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
              fontSize: phoneHeight*0.018,
              fontWeight: AppFontWeight.regular,
              letterSpacing: 0.70,
            ),
          ),
        ),
      ],
    );
  }
}


