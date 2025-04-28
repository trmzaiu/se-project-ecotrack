import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/tree/virtual_tree_screen.dart';
import 'package:wastesortapp/frontend/service/evidence_service.dart';
import 'package:wastesortapp/frontend/service/notification_service.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../database/model/notification.dart';
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
  late final Stream<List<Notifications>> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _notificationsStream = _notificationService.fetchNotifications(userId);
  }

  Widget buildNotificationItem(Notifications notification) {
    EvidenceService evidenceService = EvidenceService();

    return GestureDetector(
      onTap: () async {
        if (notification.type == 'water') {
          Navigator.of(context).push(moveUpRoute(VirtualTreeScreen()));
        } else if (notification.type == 'evidence') {
          final evidence = await evidenceService.getEvidenceById(notification.notificationId);
          print("Evidence details: ${evidence!.toMap()}");
          Navigator.of(context).push(
            moveLeftRoute(
                EvidenceDetailScreen(evidence: evidence)
            ),
          );
        }
        await NotificationService().markNotificationAsRead(notification.notificationId);
        print("Notification $notification.notificationId marked as read.");
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
                      notification.title,
                      style: GoogleFonts.urbanist(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontWeight: AppFontWeight.semiBold,
                      ),
                    ),
                    Text(
                      notification.body,
                      style: GoogleFonts.urbanist(
                        color: AppColors.tertiary,
                        fontSize: 14,
                        fontWeight: AppFontWeight.regular,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatDate(notification.time, type: 'time'),
                      style: GoogleFonts.urbanist(
                        color: AppColors.tertiary,
                        fontSize: 12,
                        fontWeight: AppFontWeight.regular,
                      ),
                    ),
                    if (notification.isRead)
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
              child: StreamBuilder<List<Notifications>>(
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
                            final List<Notifications> items = group['items'];
                            final item = items.map((item) {
                              return buildNotificationItem(item);
                            }).toList();

                            return buildNotificationCard(date, item);
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
