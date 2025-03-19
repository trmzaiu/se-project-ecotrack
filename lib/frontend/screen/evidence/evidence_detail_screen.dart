import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';

import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../widget/bar_title.dart';

class EvidenceDetailScreen extends StatefulWidget {
  final String category;
  final String status;
  final int point;
  final String date;
  final String? description;
  final List<String> imagePaths;

  EvidenceDetailScreen({
    required this.category,
    required this.status,
    required this.point,
    required this.date,
    required this.description,
    required this.imagePaths,
  });

  @override
  _EvidenceScreenState createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceDetailScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // final List<String> imagePaths = [
  //   'lib/assets/images/caution.png',
  //   'lib/assets/images/img.png',
  //   'lib/assets/images/img.png',
  //   'lib/assets/images/img.png',
  // ];


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
                  SizedBox(height: 30),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: phoneWidth - 60,
                          height: phoneWidth - 60,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: widget.imagePaths.length,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  widget.imagePaths[index],
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
                                  '${_currentIndex + 1}/${widget.imagePaths.length}',
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
                          child: _currentIndex < widget.imagePaths.length - 1
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
                    children: List.generate(widget.imagePaths.length, (index) {
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
                          _infoColumn('Category', widget.category, (phoneWidth - 60) / 2),
                          _infoColumn('Status', widget.status, (phoneWidth - 60) / 2)
                        ],
                      )
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                      width: phoneWidth - 60,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _infoColumn('Points Earned', '${widget.point} pts', (phoneWidth - 60) / 2),
                          _infoColumn('Date', widget.date, (phoneWidth - 60) / 2)
                        ],
                      )
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: phoneWidth - 60,
                    child:  _infoColumn(
                        'Description',
                        (widget.description != null && widget.description!.isNotEmpty)
                            ? widget.description!
                            : 'No description available',
                        (phoneWidth - 60)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColumn(String title, String value, double width) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.urbanist(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.urbanist(
              color: AppColors.tertiary,
              fontSize: 20,
              fontWeight: AppFontWeight.regular,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
