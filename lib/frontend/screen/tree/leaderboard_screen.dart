import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/service/user_service.dart'; // Import UserService
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

import '../../widget/bar_title.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final UserService _userService = UserService(FirebaseAuth.instance);
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _userService.leaderboardStream(),
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
              if (users.any((user) => user['userId'] == currentUserId && user['rank'] > 12))
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: _buildUserTile(
                    users.firstWhere((user) => user['userId'] == currentUserId),
                  ),
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
    bool isCurrentUser = user['userId'] == currentUserId;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isCurrentUser ? AppColors.secondary : AppColors.surface, width: 3),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(user['image']),
                radius: avatarSize / 2,
              ),
            ),
            Positioned(
              bottom: -10,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCurrentUser ? AppColors.secondary : AppColors.surface,
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
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                    color: isCurrentUser ? AppColors.surface : AppColors.secondary,
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
              user['tree'].toString(),
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
    bool isCurrentUser = user['userId'] == currentUserId;

    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: ShapeDecoration(
        color: isCurrentUser ? AppColors.secondary : AppColors.surface,
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
                color: isCurrentUser ? AppColors.surface : AppColors.primary,
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
                color: isCurrentUser ? AppColors.surface : AppColors.primary,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                user['tree'].toString(),
                style: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: AppFontWeight.bold,
                  color: isCurrentUser ? AppColors.surface : AppColors.primary,
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