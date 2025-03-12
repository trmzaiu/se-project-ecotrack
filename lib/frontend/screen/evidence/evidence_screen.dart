import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

class EvidenceScreen extends StatefulWidget {
  @override
  _EvidenceScreenState createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> {
  final PageController _pageController = PageController();

  final List<String> imagePaths = [
    'lib/assets/images/caution.png',
    'lib/assets/images/img.png',
    'lib/assets/images/img.png',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: Stack(
              children: [
                Positioned(
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'lib/assets/icons/ic_back.svg',
                      height: 20,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Evidence',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      color: AppColors.surface,
                      fontSize: 18,
                      fontWeight: AppFontWeight.semiBold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
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
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Container(
                          width: 360,
                          height: 360,
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
                                  width: 360,
                                  height: 360,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(imagePaths.length, (index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: _currentIndex == index ? 12 : 8,
                          height: _currentIndex == index ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index ? Colors.blue : Colors.grey,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
