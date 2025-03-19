import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> users = [
    {'rank': 1, 'name': 'You', 'score': 43, 'image': 'assets/user1.png'},
    {'rank': 2, 'name': 'Meghan Jes...', 'score': 40, 'image': 'assets/user2.png'},
    {'rank': 3, 'name': 'Alex Turner', 'score': 38, 'image': 'assets/user3.png'},
    {'rank': 4, 'name': 'Marsha Fisher', 'score': 36, 'image': 'assets/user4.png'},
    {'rank': 5, 'name': 'Juanita Cormier', 'score': 36, 'image': 'assets/user5.png'},
    {'rank': 6, 'name': 'Jenifer Hamlet', 'score': 36, 'image': 'assets/user6.png'},
    {'rank': 7, 'name': 'Tamara Schmidt', 'score': 36, 'image': 'assets/user7.png'},
    {'rank': 8, 'name': 'Ricardo Veum', 'score': 36, 'image': 'assets/user8.png'},
    {'rank': 9, 'name': 'Gary Sanford', 'score': 36, 'image': 'assets/user9.png'},
    {'rank': 10, 'name': 'Becky Bartell', 'score': 36, 'image': 'assets/user10.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildTopThree(),
          const SizedBox(height: 34),
          Expanded(
            child: ListView.builder(
              itemCount: users.length - 3,
              itemBuilder: (context, index) {
                final user = users[index + 3];
                return _buildUserTile(user);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 73),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          'LeaderBoard',
          style: GoogleFonts.urbanist(
            color: AppColors.secondary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTopThree() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 39),
                  _buildTopUser(users[1], AppColors.background, 74),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 0),
                  _buildTopUser(users[0], AppColors.background, 84),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 39),
                  _buildTopUser(users[2], AppColors.background, 74),
                ],
              ),
            ),
          ],
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
              bottom: -14,
              child: Container(
                width: 28,
                height: 28,
                decoration: ShapeDecoration(
                  color: AppColors.background,
                  shape: const OvalBorder(
                    side: BorderSide(width: 1, color: AppColors.background),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  user['rank'].toString(),
                  style: GoogleFonts.urbanist(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 0),
                        blurRadius: 13,
                        color: const Color(0xFF000000).withOpacity(0.25),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          user['name'],
          style: GoogleFonts.urbanist(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.secondary,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user['score'].toString(),
              style: GoogleFonts.urbanist(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 5),
            Image.asset(
              'lib/assets/images/tree.png',
              width: 12,
              height: 18,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user) {
    bool isHighlighted = user['rank'] == 7;

    return Container(
      width: 376,
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: ShapeDecoration(
        color: isHighlighted ? AppColors.secondary : const Color(0x4CF7EEE7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Text(
            user['rank'].toString(),
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isHighlighted ? AppColors.surface : AppColors.primary,
            ),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            backgroundImage: AssetImage(user['image']),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              user['name'],
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
                  fontWeight: FontWeight.bold,
                  color: isHighlighted ? AppColors.surface : AppColors.primary,
                ),
              ),
              const SizedBox(width: 5),
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
