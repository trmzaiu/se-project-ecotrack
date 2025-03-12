import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';

import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../widget/bar_title.dart';
import '../../widget/info_column.dart';

class EvidenceDetailScreen extends StatefulWidget {
  @override
  _EvidenceScreenState createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceDetailScreen> {
  final PageController _pageController = PageController();

  final List<String> imagePaths = [
    'lib/assets/images/caution.png',
    'lib/assets/images/img.png',
    'lib/assets/images/img.png',
    'lib/assets/images/img.png',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          BarTitle(title: 'Evidence'),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 800,
              padding: EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: phoneWidth - 60,
                          height: phoneWidth - 60,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: imagePaths.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  imagePaths[index],
                                  width: phoneWidth - 60,
                                  height: phoneWidth - 60,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),

                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                              width: 45,
                              height: 25,
                              decoration: ShapeDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 200),
                                child: Text(
                                  '${_currentIndex + 1}/${imagePaths.length}',
                                  key: ValueKey(_currentIndex),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.urbanist(
                                    color: AppColors.surface,
                                    fontSize: 12,
                                    fontWeight: AppFontWeight.bold,
                                    letterSpacing: 0.25,
                                  ),
                                ),
                              )
                          ),
                        ),

                        Positioned(
                          left: 10,
                          child: _currentIndex > 0
                              ? GestureDetector(
                            onTap: () {
                              _pageController.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                'lib/assets/icons/ic_back.svg',
                                height: 16,
                              ),
                            ),
                          )
                              : SizedBox(),
                        ),

                        Positioned(
                          right: 10,
                          child: _currentIndex < imagePaths.length - 1
                              ? GestureDetector(
                            onTap: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Transform.rotate(
                                angle: math.pi,
                                child: SvgPicture.asset(
                                  'lib/assets/icons/ic_back.svg',
                                  height: 16,
                                ),
                              ),
                            ),
                          )
                              : SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(imagePaths.length, (index) {
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
                  SizedBox(height: 60),
                  SizedBox(
                      width: phoneWidth - 60,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InfoColumn(
                            title: 'Category',
                            value: 'Recyclable',
                            width: (phoneWidth - 60) / 2,
                          ),
                          InfoColumn(
                            title: 'Status',
                            value: 'Approved',
                            width: (phoneWidth - 60) / 2,
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      width: phoneWidth - 60,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InfoColumn(
                            title: 'Points Earned',
                            value: '15 pts',
                            width: (phoneWidth - 60) / 2,
                          ),
                          InfoColumn(
                            title: 'Date',
                            value: '28 Feb, 2025',
                            width: (phoneWidth - 60) / 2,
                          ),
                        ],
                      )
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: phoneWidth - 60,
                    child: InfoColumn(
                      title: 'Description',
                      value: 'The description goes here',
                      width: (phoneWidth - 60),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
