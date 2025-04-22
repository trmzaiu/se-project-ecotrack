import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import 'frontend/screen/auth/login_screen.dart';
import 'frontend/screen/camera/camera_screen.dart';
import 'frontend/screen/guide/guide_screen.dart';
import 'frontend/screen/home/home_screen.dart';
import 'frontend/screen/navigator_observer.dart';
import 'frontend/screen/splash_screen.dart';
import 'frontend/screen/tree/virtual_tree_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wastesortapp/database/firebase_options.dart';
import 'package:wastesortapp/frontend/screen/user/profile_screen.dart';

import 'frontend/screen/user/notification_screen.dart';
import 'frontend/service/notification_service.dart';
import 'frontend/utils/phone_size.dart';
import 'frontend/widget/custom_dialog.dart';

void main() async{
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  await NotificationService.requestNotificationPermission();

  runApp(
    MyApp()
  );
  // runApp(
  //     MyApp()
  // //   ChangeNotifierProvider(
  // //     create: (context) => InternetCheckerProvider(),
  // //     child: MyApp(),
  // //   ),
  // );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final MyNavigatorObserver myObserver = MyNavigatorObserver();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'EcoTrack',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.tertiary,
          surface: AppColors.surface,
          scrim: AppColors.accent
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      navigatorObservers: [myObserver],
      routes: {
        '/notification': (context) => NotificationScreen(),
      },
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  bool _isFullyOpened = false;

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    if (index == 2 || index == 3) {
      if (!_isUserLoggedIn()) {
        _showErrorDialog(context);
        return;
      }
    }
    _pageController.jumpToPage(
      index,
    );

    setState(() {
      _currentIndex = index;
    });
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
    double phoneHeight = getPhoneHeight(context);
    double minChildSize = 0.15;
    double maxChildSize = 1.0;

    // Provider.of<InternetCheckerProvider>(context, listen: false).setContext(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            width: phoneWidth,
            height: phoneHeight,
            child: Image.asset('lib/assets/images/home_background.png', fit: BoxFit.cover,),
          ),

          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: minChildSize,
            maxChildSize: maxChildSize,
            minChildSize: minChildSize,
            builder: (context, scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent >= maxChildSize && !_isFullyOpened) {
                    setState(() {
                      _isFullyOpened = true;
                    });
                  } else if (notification.extent < maxChildSize && _isFullyOpened) {
                    setState(() {
                      _isFullyOpened = false;
                    });
                  }
                  return true;
                },
                child: Container(
                  height: phoneHeight - 60,
                  width: phoneWidth,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      if (!_isFullyOpened)
                        Center(
                          child: Container(
                            width: 80,
                            height: 5,
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: _isFullyOpened ? null : scrollController,
                          physics: _isFullyOpened ? NeverScrollableScrollPhysics() : null,
                          child: Column(
                            children: [
                              SizedBox(
                                height: _isFullyOpened ? (phoneHeight - 65) : phoneHeight,
                                child: PageView(
                                  physics: NeverScrollableScrollPhysics(),
                                  controller: _pageController,
                                  children: [
                                    HomeScreen(),
                                    GuideScreen(),
                                    VirtualTreeScreen(),
                                    ProfileScreen(),
                                  ],
                                ),
                              ),
                              AnimatedSlide(
                                duration: Duration(milliseconds: 50),
                                curve: Curves.easeInOut,
                                offset: _isFullyOpened ? Offset(0, 0) : Offset(0, 1),
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 50),
                                  opacity: _isFullyOpened ? 1.0 : 0.0,
                                  child: _buildBottomNavigationBar(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: _currentIndex == 2 ? AppColors.surface : AppColors.background,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(0, -2)
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem('lib/assets/icons/ic_home.svg', 'Home', 0),
                  _buildNavItem('lib/assets/icons/ic_guide.svg', 'Guide', 1),
                  SizedBox(width: 50),
                  _buildNavItem('lib/assets/icons/ic_virtual_tree.svg', 'Tree', 2),
                  _buildNavItem('lib/assets/icons/ic_profile.svg', 'Profile', 3),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: MediaQuery.of(context).size.width / 2 - 85/2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(85, 85),
                  painter: TopHalfShadowPainter(),
                ),
                Container(
                  width: 85,
                  height: 85 / 2,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
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
                  onPressed: () => Navigator.of(context).push(moveUpRoute(CameraScreen())),
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
    return ElevatedButton(
      onPressed: () => _onItemTapped(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        overlayColor: Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 25,
            height: 25,
            colorFilter: ColorFilter.mode(
              _currentIndex == index ? AppColors.primary : AppColors.accent,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.urbanist(
              fontSize: 12,
              fontWeight: AppFontWeight.semiBold,
              color: _currentIndex == index ? AppColors.primary : AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class TopHalfShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint shadowPaint = Paint()
      ..color = Colors.black12
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

    double offsetX = 28;
    double offsetY = size.height / 2;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(offsetX, offsetY), radius: size.width / 2),
      4.17,
      1.57,
      false,
      shadowPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
