import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/evidence/evidence_detail_screen.dart';
import 'package:wastesortapp/frontend/screen/evidence/upload_evidence_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../../theme/colors.dart';
import '../../widget/bar_title.dart';

class EvidenceScreen extends StatefulWidget {
  @override
  _EvidenceScreenState createState() => _EvidenceScreenState();
}

class _EvidenceScreenState extends State<EvidenceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Column(
        children: [
          BarTitle(title: 'Evidence'),
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
                      children: [
                        _buildTabContent("All"),
                        _buildTabContent("Accepted"),
                        _buildTabContent("Rejected"),
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
            MaterialPageRoute(builder: (context) => UploadScreen(imagePath: "")),
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

  Widget _buildTabContent(String category) {
    List<Map<String, String>> evidenceList = [
      {"title": "Recyclable", "date": "Mar 1, 2025", "status": "Pending", "image": "lib/assets/images/img.png"},
      {"title": "Organic", "date": "Feb 28, 2025", "status": "Accepted", "image": "lib/assets/images/caution.png"},
      // {"title": "General", "date": "Feb 27, 2025", "status": "Rejected", "image": "lib/assets/images/caution.png"},
      {"title": "General", "date": "Feb 5, 2025", "status": "Accepted", "image": "lib/assets/images/caution.png"},
    ];

    List<Map<String, String>> filteredList = category == "All"
        ? evidenceList
        : evidenceList.where((item) => item["status"] == category).toList();

    bool hasEvidence = evidenceList.isNotEmpty;
    bool hasApprovedEvidence = evidenceList.any((item) => item["status"] == "Accepted");
    bool hasDisapprovedEvidence = evidenceList.any((item) => item["status"] == "Rejected");

    if (!hasEvidence) {
      return Center(
        child: Text(
          'You have no evidence yet',
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: Color(0xFF7C3F3E),
            fontSize: 16,
            fontWeight: AppFontWeight.medium,
          ),
        ),
      );
    }

    if (category == "Accepted" && !hasApprovedEvidence) {
      return Center(
        child: Text(
          "No approved evidence available",
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: Color(0xFF7C3F3E),
            fontSize: 16,
            fontWeight: AppFontWeight.medium,
          ),
        ),
      );
    }

    if (category == "Rejected" && !hasDisapprovedEvidence) {
      return Center(
        child: Text(
          "No disapproved evidence available",
          textAlign: TextAlign.center,
          style: GoogleFonts.urbanist(
            color: Color(0xFF7C3F3E),
            fontSize: 16,
            fontWeight: AppFontWeight.medium,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(30),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        var item = filteredList[index];
        Color statusColor = item["status"] == "Pending"
            ? Colors.grey
            : item["status"] == "Accepted"
            ? Colors.green
            : Colors.red;

        return Container(
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
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EvidenceDetailScreen()),
              );
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item["image"]!,
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"]!,
                        style: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        item["date"]!,
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
                    item["status"]!,
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
  }
}
