import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastesortapp/frontend/service/notification_service.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../widget/bar_title.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notiService = NotificationService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  Stream<List<Map<String, dynamic>>>? _notificationsFuture;

  @override
  void initState() {
    super.initState();
    // Replace "currentUserId" with the actual current user id
    _notificationsFuture = _notiService.fetchNotifications(userId);
  }


  String formatDate(DateTime time) {
    return DateFormat("MMM dd, yyyy").format(time);
  }

  String formatDateTime(DateTime time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String period = hour >= 12 ? 'PM' : 'AM';
    final int formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$formattedHour:${minute.toString().padLeft(2, '0')} $period';
  }

  Widget buildNotificationItem(
     String type,
     String time,
     int points,
     bool isRead, String notificationId
  ) {
    String waterTitle = 'Water Level Reached the Limit!';
    String waterContent = 'Check now to prevent overflow or adjust as needed.';
    String evidenceTitle = 'Your Evidence Was Approved!';
    String evidenceContent = 'You earned $points points. Keep contributing for more rewards!';

    DateTime parsedTime = DateFormat("HH:mm").parse(time);
    String formattedTime = formatDateTime(parsedTime);  // Ensure this function exists.

    return GestureDetector(
      onTap: () async {
        // Call the function to mark the notification as read.
        await NotificationService().markNotificationAsRead(notificationId);
        print("Notification $notificationId marked as read.");

        // Optionally, trigger a UI update or refresh the notification list.
      },
      child: Padding(
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
                  image: const DecorationImage(
                    image: AssetImage("lib/assets/images/logo.png"),
                    fit: BoxFit.fill,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type == 'water' ? waterTitle : evidenceTitle,
                      style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                    Text(
                      type == 'water' ? waterContent : evidenceContent,
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
                    if (isRead == false)
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
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildNotificationCard(DateTime date, List<Widget> children) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            (formatDate(DateTime.now()) == formatDate(date))
                ? 'Today'
                : formatDate(date),
            style: GoogleFonts.urbanist(
              color: AppColors.secondary,
              fontSize: 20,
              fontWeight: AppFontWeight.regular,
            ),
          ),
          ...children,
        ],
      ),
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
              title: Text(
                'Delete all',
                style: GoogleFonts.urbanist(
                  color: AppColors.secondary,
                ),
              ),
              onTap: () {
                _notiService.deleteAllNotifications(userId);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.done_all, color: AppColors.primary),
              title: Text(
                'Mark all as read',
                style: GoogleFonts.urbanist(
                  color: AppColors.primary,
                ),
              ),
              onTap: () {
                _notiService.markAllNotificationsAsRead();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
                  const SizedBox(height: 30),
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
            child: Container(
              color: AppColors.background,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _notiService.fetchNotifications(FirebaseAuth.instance.currentUser!.uid), // ✅ Uses real-time Firestore updates
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    final data = snapshot.data!;
                    return SingleChildScrollView(
                      child: Container(
                        decoration: const BoxDecoration(color: AppColors.background),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data.map((notification) {
                              DateTime date = DateTime.parse(notification["date"]);
                              List<Widget> items = (notification["items"] as List)
                                  .map<Widget>((item) => buildNotificationItem(
                                  item["type"], item["time"], item["points"], item["isRead"], item["notificationId"]
                              )).toList();
                              return buildNotificationCard(date, items);
                            }).toList(),
                          ),
                        ),
                      ),
                    );
                  }

                  // ✅ No notifications found → Show a card instead of plain text
                  return Center(
                    child: Card(
                      elevation: 5,
                      color: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.notifications_off, size: 40, color: Colors.grey),
                            const SizedBox(height: 10),
                            Text(
                              "No notifications",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ),

        ],
      ),
    );
  }
}
