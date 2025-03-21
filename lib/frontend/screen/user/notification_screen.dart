import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../widget/bar_title.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    String formatDateTime(DateTime time) {
      final int hour = time.hour;
      final int minute = time.minute;
      final String period = hour >= 12 ? 'PM' : 'AM';

      final int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$formattedHour:${minute.toString().padLeft(2, '0')} $period';
    }

    String formatDate(DateTime time) {
      return DateFormat("MMM dd, yyyy").format(time);
    }

    Widget buildNotificationItem(String type, DateTime time, int points, bool isRead) {
      String waterTitle = 'Water Level Reached the Limit!';
      String waterContent = 'Check now to prevent overflow or adjust as needed.';
      String evidenceTitle = 'Your Evidence Was Approved!';
      String evidenceContent = 'You earned ${points} points. Keep contributing for more rewards!';
      String formattedTime = formatDateTime(time);
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: ShapeDecoration(
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: AssetImage("lib/assets/images/logo.png"),
                    fit: BoxFit.fill,
                  ),
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
                      (type == 'water')? waterTitle : evidenceTitle,
                      style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                    Text(
                      (type == 'water')? waterContent : evidenceContent,
                      style: GoogleFonts.urbanist(
                        color: AppColors.tertiary,
                        fontSize: 14,
                        fontWeight: AppFontWeight.regular,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedTime,
                      style: GoogleFonts.urbanist(
                        color: AppColors.tertiary,
                        fontSize: 12,
                        fontWeight: AppFontWeight.regular,
                      ),
                    ),
                    if (isRead)
                      Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("lib/assets/images/tree.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    
    Widget buildNotificationCard(DateTime date, List<Widget> children) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            (formatDate(DateTime.now())==formatDate(date))? 'Today' : formatDate(date),
            style: GoogleFonts.urbanist(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: AppFontWeight.regular,
            ),
          ),
          ...children,
        ],
      );
    }

    void _showMenu(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: AppColors.background,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.delete, color: AppColors.secondary),
                title: Text('Delete all', style: GoogleFonts.urbanist(
                  color: AppColors.secondary,
                )),
                onTap: () {
                  //BE Link
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.done_all, color: AppColors.primary),
                title: Text('Mark all as read', style: GoogleFonts.urbanist(
                  color: AppColors.primary,
                )),
                onTap: () {
                  //BE Link
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  BarTitle(title: 'Notifications', showBackButton: true),
                  SizedBox(height: 30),
                ],
              ),
              Positioned(
                right: 5,
                top: 48,
                child: Center(
                  child: IconButton(
                  icon: SvgPicture.asset(
                    'lib/assets/icons/dots-notification.svg',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () => _showMenu(context),
                ),
              ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  // borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildNotificationCard(
                        DateTime(2025, 3, 21, 13, 0),
                        [
                          buildNotificationItem("water", DateTime(2025, 3, 21, 13, 0), 100, true),
                          buildNotificationItem("water", DateTime(2025, 3, 21, 13, 0), 100, false),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildNotificationCard(
                        DateTime(2025, 3, 20, 13, 0),
                        [
                          buildNotificationItem("point", DateTime(2025, 3, 20, 13, 0), 100, true),
                          buildNotificationItem("point", DateTime(2025, 3, 20, 13, 0), 100, true),
                          buildNotificationItem("point", DateTime(2025, 3, 20, 13, 0), 100, true),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildNotificationCard(
                        DateTime(2025, 3, 19, 13, 0),
                        [
                          buildNotificationItem("water", DateTime(2025, 3, 19, 13, 0), 100, true),
                          buildNotificationItem("water", DateTime(2025, 3, 19, 13, 0), 100, true),
                          buildNotificationItem("water", DateTime(2025, 3, 19, 13, 0), 100, true),
                        ],
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
