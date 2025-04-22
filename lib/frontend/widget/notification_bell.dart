import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/user/notification_screen.dart';
import 'package:wastesortapp/frontend/utils/route_transition.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../screen/auth/login_screen.dart';
import '../service/notification_service.dart';
import 'custom_dialog.dart';

class NotificationBell extends StatelessWidget {
  final double size;

  const NotificationBell({
    Key? key,
    this.size = 24,
  }) : super(key: key);

  bool _isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        message: 'Please log in to continue.',
        status: false,
        buttonTitle: "Login",
        isDirect: true,
        onPressed: () {
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
    return StreamBuilder<int>(
      stream: NotificationService().countUnreadNotifications(),
      builder: (context, snapshot) {
        // If the request is still loading, show no badge (or a placeholder if desired)
        int count = snapshot.data ?? 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {
                if (_isUserLoggedIn()) {
                  Navigator.of(context).push(
                    moveLeftRoute(
                      NotificationScreen(),
                    ),
                  );
                } else {
                  _showErrorDialog(context);
                }
              },
              icon: SvgPicture.asset(
                'lib/assets/icons/ic_notification.svg',
                width: size,
                height: size,
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.surface),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                shadowColor: MaterialStateProperty.all(const Color(0x33333333)),
                elevation: MaterialStateProperty.all(2),
              ),
            ),
            // Only show the badge if there's at least one unread notification.
            if (count > 0)
              Positioned(
                left: 20,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.surface,
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(minWidth: 18, maxHeight: 18),
                  child: Center(
                    child: Text(
                      count > 9 ? "9+" : count.toString(),
                      style: GoogleFonts.urbanist(
                        fontSize: 11,
                        color: AppColors.surface,
                        fontWeight: AppFontWeight.semiBold,
                        height: 0.9
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
