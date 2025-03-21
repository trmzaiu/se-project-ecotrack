import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

double getPhoneWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getPhoneHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = getPhoneWidth(context);

    Widget buildNotificationCard(String title, String content, {bool withImage = true}) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          width: screenWidth * 0.92,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: ShapeDecoration(
            color: const Color(0xFFFFFCFB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: ShapeDecoration(
                  color: const Color(0xFFD9D9D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF7C3F3E),
                        fontSize: 14,
                        fontWeight: AppFontWeight.semiBold,
                        height: 0.86,
                        letterSpacing: 0.14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF9C9385),
                        fontSize: 14,
                        fontWeight: AppFontWeight.semiBold,
                        height: 0.86,
                        letterSpacing: 0.14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Transform.translate(
                    offset: const Offset(-6, -15),
                    child: Text(
                      '1:00 PM',
                      style: GoogleFonts.urbanist(
                        color: const Color(0xFF9C9385),
                        fontSize: 12,
                        fontWeight: AppFontWeight.semiBold,
                        height: 1,
                        letterSpacing: 0.12,
                      ),
                    ),
                  ),
                  if (withImage)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 32,
                      height: 27,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/assets/images/guide_buttonnoti.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF7C3F3E),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 12),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'lib/assets/icons/ic_back.svg',
                      height: 24,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Notification',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      color: AppColors.surface,
                      fontSize: 18,
                      fontWeight: AppFontWeight.semiBold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        print("Delete all selected");
                      } else if (value == 'mark_read') {
                        print("Mark all as read selected");
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            const SizedBox(width: 8),
                            Text('Delete all', style: GoogleFonts.urbanist()),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Image(
                              image: AssetImage('lib/assets/images/guide_buttonnoti.png'),
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8),
                            Text('Mark all as read', style: GoogleFonts.urbanist()),
                          ],
                        ),
                      ),
                    ],
                    icon: Align(
                      alignment: Alignment.topRight,
                      child: Transform.translate(
                        offset: const Offset(-8, -9),
                        child: SvgPicture.asset(
                          'lib/assets/icons/dots-notification.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: screenWidth,
                decoration: const ShapeDecoration(
                  color: Color(0xFFF7EEE7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today',
                        style: GoogleFonts.urbanist(
                          color: const Color(0xFF7C3F3E),
                          fontSize: 20,
                          fontWeight: AppFontWeight.regular,
                          height: 0.60,
                          letterSpacing: 0.20,
                        ),
                      ),
                      buildNotificationCard(
                        'Water Level Reached the Limit!',
                        'The water level has hit the threshold. Check now to prevent overflow or adjust as needed.',
                      ),
                      buildNotificationCard(
                        'Congrats! Your Evidence Was Approved',
                        'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Mar 11, 2015',
                        style: GoogleFonts.urbanist(
                          color: const Color(0xFF7C3F3E),
                          fontSize: 20,
                          fontWeight: AppFontWeight.regular,
                          height: 0.60,
                          letterSpacing: 0.20,
                        ),
                      ),
                      buildNotificationCard(
                        'Water Level Reached the Limit!',
                        'The water level has hit the threshold. Check now to prevent overflow or adjust as needed.',
                        withImage: false,
                      ),
                      buildNotificationCard(
                        'Congrats! Your Evidence Was Approved',
                        'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                      ),
                      buildNotificationCard(
                        'Congrats! Your Evidence Was Approved',
                        'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                        withImage: false,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Feb 11, 2015',
                        style: GoogleFonts.urbanist(
                          color: const Color(0xFF7C3F3E),
                          fontSize: 20,
                          fontWeight: AppFontWeight.regular,
                          height: 0.60,
                          letterSpacing: 0.20,
                        ),
                      ),
                      buildNotificationCard(
                        'Water Level Reached the Limit!',
                        'The water level has hit the threshold. Check now to prevent overflow or adjust as needed.',
                        withImage: false,
                      ),
                      buildNotificationCard(
                        'Congrats! Your Evidence Was Approved',
                        'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                        withImage: false,
                      ),
                      buildNotificationCard(
                        'Congrats! Your Evidence Was Approved',
                        'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                        withImage: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
