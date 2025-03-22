import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/service/auth_service.dart'; // Import AuthenticationService
import 'package:wastesortapp/frontend/service/user_service.dart'; // Import AuthenticationService
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../widget/bar_title.dart';

class LeaderboardScreen extends StatelessWidget {
 final UserService _userService;

  // Update constructor to accept AuthenticationService
  LeaderboardScreen({required UserService userService})
      : _userService = userService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userService.fetchUsersForLeaderboard(), // Use the new service method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading leaderboard'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          }

          final users = snapshot.data!;

          return Column(
            children: [
              BarTitle(
                title: "Leaderboard",
                textColor: AppColors.secondary,
                showBackButton: true,
                buttonColor: AppColors.secondary,
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _buildTopThree(users),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  itemCount: users.length > 3 ? users.length - 3 : 0,
                  itemBuilder: (context, index) {
                    final user = users[index + 3];
                    return _buildUserTile(user);
                  },
                ),
              ),
              if (users.length > 6)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: _buildUserTile(users[6]),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTopThree(List<Map<String, dynamic>> users) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (users.length > 1)
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: _buildTopUser(users[1], AppColors.background, 75),
          )
        else
          SizedBox(),
        if (users.isNotEmpty)
          _buildTopUser(users[0], AppColors.background, 85)
        else
          SizedBox(),
        if (users.length > 2)
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: _buildTopUser(users[2], AppColors.background, 75),
          )
        else
          SizedBox(),
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
                  ],
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
            Image.asset('lib/assets/images/tree.png', width: 12),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    bool isHighlighted = user['rank'] == 12;

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