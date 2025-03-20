import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wastesortapp/theme/colors.dart';

import 'frontend/screen/camera/camera_screen.dart';
import 'frontend/screen/guide/guide_screen.dart';
import 'frontend/screen/home/home_screen.dart';
import 'frontend/screen/splash_screen.dart';
import 'frontend/screen/tree/virtual_tree_screen.dart';
import 'frontend/screen/auth/opening_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wastesortapp/database/firebase_options.dart';
import 'package:wastesortapp/frontend/screen/user/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoTrack',
      theme: ThemeData(
        primaryColor: AppColors.primary,
      ),
      home: SplashScreen(),
    );

  }
}

class MainScreen extends StatefulWidget {
  final String userId; // Receive userId

  const MainScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(),
      GuideScreen(),
      CameraScreen(),
      VirtualTreeScreen(userId: widget.userId),
      ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => CameraScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.easeOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem('lib/assets/icons/ic_home.svg', 'Home', 0),
                  _buildNavItem('lib/assets/icons/ic_guide.svg', 'Guide', 1),
                  SizedBox(width: 50),
                  _buildNavItem('lib/assets/icons/ic_virtual_tree.svg', 'Virtual Tree', 3),
                  _buildNavItem('lib/assets/icons/ic_profile.svg', 'Profile', 4),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: MediaQuery.of(context).size.width / 2 - 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 85,
                  height: 85/2,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFCFB),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0x4CE7E0DA),
                    shape: BoxShape.circle,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Color(0x66E7E0DA),
                  hoverColor: Colors.transparent,
                  hoverElevation: 0,
                  focusColor: Colors.transparent,
                  focusElevation: 0,
                  highlightElevation: 0,
                  splashColor: Colors.transparent,
                  disabledElevation: 0,
                  elevation: 0,
                  shape: CircleBorder(),
                  onPressed: () => _onItemTapped(2),
                  child: SvgPicture.asset(
                    'lib/assets/icons/ic_camera.svg',
                    width: 30,
                    height: 30,
                    colorFilter: ColorFilter.mode(AppColors.accent, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String iconPath, String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 25,
            height: 25,
            colorFilter: ColorFilter.mode(_selectedIndex == index ? AppColors.primary : AppColors.accent, BlendMode.srcIn),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _selectedIndex == index ? AppColors.primary : AppColors.accent,
            ),
          ),
        ],
      )
    );
  }
}
