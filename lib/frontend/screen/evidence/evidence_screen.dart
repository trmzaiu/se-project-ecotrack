import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wastesortapp/frontend/screen/evidence/evidence_detail_screen.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../database/model/evidence.dart';
import '../../../theme/colors.dart';
import '../../service/evidence_service.dart';
import '../../widget/bar_title.dart';

class EvidenceScreen extends StatefulWidget {
  @override
  _EvidenceScreenState createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, Size> imageSizes = {};
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void preloadImages(List<Evidences> evidences, BuildContext context) {
    for (var item in evidences) {
      if (item.imagesUrl.isNotEmpty) {
        precacheImage(CachedNetworkImageProvider(item.imagesUrl.first), context);
      }
    }
  }

  void getCachedImageSize(String imageUrl) {
    if (imageUrl.isEmpty || imageSizes.containsKey(imageUrl)) return;

    final ImageProvider imageProvider = CachedNetworkImageProvider(imageUrl);
    final ImageStream stream = imageProvider.resolve(ImageConfiguration());

    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        imageSizes[imageUrl] = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          BarTitle(title: 'Evidence', showBackButton: true),
          SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                color: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Container(
                    width: phoneWidth - 60,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: List.generate(3, (index) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _tabController.index = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: _tabController.index == index
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: _tabController.index == index
                                    ? [
                                  BoxShadow(
                                    color: Color(0x0F101828),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                  BoxShadow(
                                    color: Color(0x19101828),
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ]
                                    : [],
                              ),
                              child: Center(
                                child: Text(
                                  ["All", "Approved", "Disapproved"][index],
                                  style: GoogleFonts.urbanist(
                                    color: _tabController.index == index
                                        ? AppColors.primary
                                        : AppColors.tertiary,
                                    fontSize: 14,
                                    fontWeight: _tabController.index == index
                                        ? AppFontWeight.bold
                                        : AppFontWeight.regular,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildTabContent("All", userId),
                        _buildTabContent("Accepted", userId),
                        _buildTabContent("Rejected", userId),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UploadScreen(),
              settings: RouteSettings(name: "UploadScreen"),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        shape: CircleBorder(),
        child: SvgPicture.asset(
          'lib/assets/icons/ic_plus.svg',
          height: 40,
        ),
      ),
    );
  }

  Widget _buildTabContent(String category, String userId) {
    return StreamBuilder<List<Evidences>>(
      stream: EvidenceService(context).fetchEvidences(userId),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(child: CircularProgressIndicator());
        // }
        if (snapshot.hasError) {
          return Center(child: Text("Error fetching evidences"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: Text(
              "Fail to load evidences",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: Color(0xFF7C3F3E),
                fontSize: 16,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          );
        }

        List<Evidences> evidenceList = snapshot.data!;

        List<Evidences> filteredList = category == "All"
            ? evidenceList
            : evidenceList.where((item) => item.status == category).toList();

        if (filteredList.isEmpty) {
          return Center(
            child: Text(
              (category == "All")
                  ? "No evidence available"
                  : "No ${category.toLowerCase()} evidence available",
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                color: Color(0xFF7C3F3E),
                fontSize: 16,
                fontWeight: AppFontWeight.medium,
              ),
            ),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          preloadImages(filteredList, context);
        });

        return ListView.builder(
          padding: EdgeInsets.all(30),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            var item = filteredList[index];
            String imageUrl = item.imagesUrl.isNotEmpty ? item.imagesUrl.first : "";
            if (imageUrl.isNotEmpty) {
              getCachedImageSize(imageUrl);
            }
            Size? imageSize = imageSizes[imageUrl];
            Color statusColor = item.status == "Pending"
                ? Colors.grey
                : item.status == "Accepted"
                ? Colors.green
                : Colors.red;
            return GestureDetector(
              onTap: () {
                preloadImages(filteredList, context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EvidenceDetailScreen(
                      category: item.category,
                      status: item.status,
                      point: item.point,
                      date: DateFormat('dd MMM, yyyy').format(item.date),
                      description: item.description,
                      imagePaths: item.imagesUrl,
                    )),
                );
              },
              child:  Container(
                key: PageStorageKey(item.evidenceId),
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.imagesUrl.isNotEmpty ? item.imagesUrl.first : "",
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                        memCacheWidth: imageSize != null ? (imageSize.width / 3).toInt() : null,
                        memCacheHeight: imageSize != null ? (imageSize.height / 3).toInt() : null,
                        // useOldImageOnUrlChange: true,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.category,
                            style: GoogleFonts.urbanist(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(DateFormat('dd MMM, yyyy').format(item.date),
                            style: GoogleFonts.urbanist(
                              fontSize: 12,
                              color: AppColors.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 30,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        item.status,
                        style: GoogleFonts.urbanist(
                          fontSize: 14,
                          fontWeight: AppFontWeight.medium,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            );
          },
        );
      },
    );
  }
}
