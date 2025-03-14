import 'package:flutter/material.dart';
import 'package:wastesortapp/frontend/screen/guide/guide_recyclable_screen.dart';
import 'package:wastesortapp/theme/colors.dart';

import 'guide_general_screen.dart';
import 'guide_hazardous_screen.dart';
import 'guide_organic_screen.dart';

class GuideScreen extends StatefulWidget {
  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  int _currentIndex = 0;

  // Danh sách ảnh
  final List<String> images = [
    "lib/assets/images/recycle_bin.png",
    "lib/assets/images/organic_bin.png",
    "lib/assets/images/hazardous_bin.png",
    "lib/assets/images/general_bin.png",
  ];

  // Danh sách tiêu đề
  final List<String> titles = [
    "Recyclable Waste",
    "Organic Waste",
    "Hazardous Waste",
    "General Waste",
  ];

  // Danh sách mô tả
  final List<String> descriptions = [
    "Waste can be reprocessed into new products, such as paper, plastic, glass, and metal.",
    "Biodegradable waste that decomposes naturally, such as food scraps, leaves, and plant-based materials.",
    "Waste that poses a risk to health or the environment, such as chemicals, batteries, and medical waste.",
    "Waste that cannot be recycled or composted, such as contaminated plastics, used tissues, and broken ceramics.",
  ];

  // Chuyển đổi hình ảnh, tiêu đề và mô tả khi nhấn vào hình tròn
  void _nextWasteType() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % images.length;
    });
  }

  void _goToScreen() {
    Widget nextScreen;

    switch (_currentIndex) {
      case 0:
        nextScreen = RecyclableScreen();
        break;
      case 1:
        nextScreen = OrganicScreen();
        break;
      case 2:
        nextScreen = HazardousScreen();
        break;
      case 3:
        nextScreen = GeneralScreen();
        break;
      default:
        nextScreen = RecyclableScreen();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Circle
          Positioned(
            top: -419,
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

          // Tiêu đề "Guide"
          Positioned(
            top: 73,
            left: 0,
            right: 0,
            child: Text(
              'Guide',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFF7EEE7),
                fontSize: 18,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w800,
                letterSpacing: 0.90,
              ),
            ),
          ),

          // Hình tròn chứa hình ảnh (có hiệu ứng chuyển đổi)
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 200,
            top: 146,
            child: GestureDetector(
              onTap: _nextWasteType,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Container(
                  key: ValueKey<int>(_currentIndex),
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(images[_currentIndex]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Tiêu đề loại rác thải (có hiệu ứng chuyển đổi)
          Positioned(
            top: 570,
            left: MediaQuery.of(context).size.width / 2 - 155,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: SizedBox(
                key: ValueKey<int>(_currentIndex),
                width: 311,
                height: 62,
                child: Text(
                  titles[_currentIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 30,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.50,
                  ),
                ),
              ),
            ),
          ),

          // Mô tả loại rác thải (có hiệu ứng chuyển đổi)
          Positioned(
            top: 630,
            left: MediaQuery.of(context).size.width / 2 - 155,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: SizedBox(
                key: ValueKey<int>(_currentIndex),
                width: 311,
                height: 44,
                child: Opacity(
                  opacity: 0.55,
                  child: Text(
                    descriptions[_currentIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9C9385),
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.70,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Nút "Read More"
          Positioned(
            top: 690,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: GestureDetector(
              onTap: _goToScreen,
              child: Container(
                width: 300,
                height: 46,
                decoration: ShapeDecoration(
                  color: Color(0xFF2C6E49),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Center(
                  child: Text(
                    'Read More',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Thanh trang trí di chuyển giữa các chấm
          Positioned(
            top: 800,
            left: MediaQuery.of(context).size.width / 2 - 25 + (_currentIndex * 12.0),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 17,
              height: 4,
              decoration: ShapeDecoration(
                color: Color(0xFF7C3F3E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              ),
            ),
          ),

          // Dấu chấm chỉ mục
          Positioned(
            top: 800,
            left: MediaQuery.of(context).size.width / 2 - 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Opacity(
                    opacity: 0.30,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Color(0x7F7C3F3E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}


