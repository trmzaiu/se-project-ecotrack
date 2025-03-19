import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/widget/bar_title.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../utils/phone_size.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {'rank': 1, 'name': 'You', 'score': 43, 'image': 'lib/assets/images/caution.png'},
    {'rank': 2, 'name': 'Meghan Jesjghyuv ku', 'score': 40, 'image': 'lib/assets/images/caution.png'},
    {'rank': 3, 'name': 'Alex Turner', 'score': 38, 'image': 'lib/assets/images/caution.png'},
    {'rank': 4, 'name': 'Marsha Fisher', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 5, 'name': 'Juanita Cormier', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 6, 'name': 'Jenifer Hamlet', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 7, 'name': 'Tamara Schmidt', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 8, 'name': 'Ricardo Veum', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 9, 'name': 'Gary Sanford', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 10, 'name': 'Becky Bartell', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 10, 'name': 'Becky Bartell', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 10, 'name': 'Becky Bartell', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 10, 'name': 'Becky Bartell', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 10, 'name': 'Becky Bartell', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 10, 'name': 'Becky Bartell', 'score': 36, 'image': 'lib/assets/images/caution.png'},
    {'rank': 99, 'name': 'Becky Bartell', 'score': 36, 'image': 'lib/assets/images/caution.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          BarTitle(title: "Leaderboard", textColor: AppColors.secondary, showBackButton: true, buttonColor: AppColors.secondary,),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _buildTopThree(),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              itemCount: users.length - 3,
              itemBuilder: (context, index) {
                final user = users[index + 3];
                return _buildUserTile(user);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: _buildUserTile(users[6]),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: _buildTopUser(users[1], AppColors.background, 75),
        ),
        _buildTopUser(users[0], AppColors.background, 85),
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: _buildTopUser(users[2], AppColors.background, 75),
        ),
      ],
    );
  }

  Widget _buildTopUser(Map<String, dynamic> user, Color color, double avatarSize) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(user['image']),
              radius: avatarSize / 2,
            ),
            Positioned(
              bottom: -13,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 10,
                      color: Color(0x40000000),
                    )
                  ]
                ),
                alignment: Alignment.center,
                child: Text(
                  user['rank'].toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 18),

        SizedBox(
          width: 100,
          child: Text(
            user['name'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: AppFontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user['score'].toString(),
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            SizedBox(width: 5),
            Image.asset('lib/assets/images/tree.png', width: 12,),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    bool isHighlighted = user['rank'] == 7;

    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: ShapeDecoration(
        color: isHighlighted ? AppColors.secondary : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 4,
            color: Color(0x33000000),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            alignment: Alignment.center,
            child: Text(
              user['rank'].toString(),
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: AppFontWeight.bold,
                color: isHighlighted ? AppColors.surface : AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 10),

          CircleAvatar(
            backgroundImage: AssetImage(user['image']),
            radius: 18,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              user['name'],
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: AppFontWeight.semiBold,
                color: isHighlighted ? AppColors.surface : AppColors.primary,
              ),
            ),
          ),

          Row(
            children: [
              Text(
                user['score'].toString(),
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                  color: isHighlighted ? AppColors.surface : AppColors.primary,
                ),
              ),
              SizedBox(width: 5),
              Image.asset(
                'lib/assets/images/tree.png',
                width: 20,
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
