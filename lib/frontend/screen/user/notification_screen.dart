import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/tree/virtual_tree_screen.dart';
import 'package:wastesortapp/frontend/service/evidence_service.dart';
import 'package:wastesortapp/frontend/service/notification_service.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../database/model/evidence.dart';
import '../../utils/format_time.dart';
import '../../utils/route_transition.dart';
import '../../widget/bar_title.dart';
import '../evidence/evidence_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationService _notificationService = NotificationService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  late final Stream<List<Map<String, dynamic>>> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _notificationsStream = _notificationService.fetchNotifications(userId);
  }

  Widget buildNotificationItem(
      BuildContext context,
      String notificationId,
      String type,
      String title,
      String body,
      bool isRead,
      String time
  ) {
    EvidenceService evidenceService = EvidenceService(context);
    Evidences evidence;

    return GestureDetector(
      onTap: () async {
        if (type == 'water') {
          Navigator.of(context).push(moveUpRoute(VirtualTreeScreen()));
        } else if (type == 'evidence') {
          evidence = await evidenceService.getEvidenceById(notificationId);
          print("Evidence details: ${evidence.toMap()}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EvidenceDetailScreen(
                category: evidence.category,
                status: evidence.status,
                description: '${evidence.description}',
                date: formatDate(evidence.date),
                point: evidence.point,
                imagePaths: evidence.imagesUrl,
              ),
            ),
          );
        }
        await NotificationService().markNotificationAsRead(notificationId);
        print("Notification $notificationId marked as read.");
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
                      title,
                      style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                    Text(
                      body,
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
                      time,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotificationCard(String date, List<Widget> children) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Text(
            date,
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
                _notificationService.deleteAllNotifications();
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
                _notificationService.markAllNotificationsAsRead();
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
                stream: _notificationsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No notifications yet',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: AppFontWeight.regular,
                        ),
                      ),
                    );
                  }

                  final grouped = groupFromRawList(snapshot.data!);
                  print("Notification Data: ${snapshot.data}");
                  return SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: grouped.map((group) {
                            final date = group['date'];
                            final items = group['items'] as List<Map<String, dynamic>>;
                            final children = items.map((item) {
                              return buildNotificationItem(
                                context,
                                item['notificationId'],
                                item['type'],
                                item['title'],
                                item['body'],
                                item['isRead'],
                                item['time'],
                              );
                            }).toList();

                            return buildNotificationCard(date, children);
                          }).toList()
                        )
                      )
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
