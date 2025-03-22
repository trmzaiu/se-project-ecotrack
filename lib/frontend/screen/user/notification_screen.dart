import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../widget/bar_title.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<Map<String, dynamic>> notifications = [
    {
      "date": "2025-03-21",
      "items": [
        { "type": "water", "time": "13:30", "points": 10, "isRead": false },
        { "type": "point", "time": "13:00", "points": 5, "isRead": true }
      ]
    },
    {
      "date": "2025-03-20",
      "items": [
        { "type": "water", "time": "12:00", "points": 25, "isRead": true },
        { "type": "point", "time": "11:00", "points": 20, "isRead": true },
        { "type": "water", "time": "10:00", "points": 15, "isRead": true }
      ]
    },
    {
      "date": "2025-03-19",
      "items": [
        { "type": "point", "time": "11:45", "points": 15, "isRead": false },
        { "type": "water", "time": "10:30", "points": 5, "isRead": true },
        { "type": "point", "time": "09:00", "points": 10, "isRead": true }
      ]
    }
  ];

  String formatDate(DateTime time) {
    return DateFormat("MMM dd, yyyy").format(time);
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: notifications.map((notification) {
                      DateTime date = DateTime.parse(notification["date"]);
                      List<Widget> items = notification["items"].map<Widget>((item) {
                        return buildNotificationItem(
                          item["type"],
                          item["time"],
                          item["points"],
                          item["isRead"],
                        );
                      }).toList();
                      return buildNotificationCard(date, items);
                    }).toList(),

                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDateTime(DateTime time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$formattedHour:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget buildNotificationItem(String type, String time, int points, bool isRead) {
    String waterTitle = 'Water Level Reached the Limit!';
    String waterContent = 'Check now to prevent overflow or adjust as needed.';
    String evidenceTitle = 'Your Evidence Was Approved!';
    String evidenceContent = 'You earned ${points} points. Keep contributing for more rewards!';
    DateTime parsedTime = DateFormat("HH:mm").parse(time);
    String formattedTime = formatDateTime(parsedTime);

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
        SizedBox(height: 15),
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
}
