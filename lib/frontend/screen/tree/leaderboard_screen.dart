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
      appBar: AppBar(
        title: Text(
          'LeaderBoard',
          style: GoogleFonts.urbanist(
            color: AppColors.secondary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildTopThree(),
          const SizedBox(height: 10),
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

  Widget _buildTopThree() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end, // Align 1st place higher
        children: [
          // 2nd Place (Left, Lower)
          Column(
            children: [
              const SizedBox(height: 30), // Push down
              _buildTopUser(users[1], Colors.grey.shade300, 50), // Smaller avatar
            ],
          ),

          // 1st Place (Center, Higher)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), // Add spacing
            child: Column(
              children: [
                _buildTopUser(users[0], Colors.amber, 65), // Larger avatar
              ],
            ),
          ),

          // 3rd Place (Right, Lower)
          Column(
            children: [
              const SizedBox(height: 40), // Push down more than 2nd place
              _buildTopUser(users[2], Colors.brown.shade300, 50), // Smaller avatar
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTopUser(Map<String, dynamic> user, Color color, double avatarSize) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(user['image']),
          radius: avatarSize, // Adjust avatar size dynamically
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Text(
            user['rank'].toString(),
            style: GoogleFonts.urbanist(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          user['name'],
          style: GoogleFonts.urbanist(fontSize: 14),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user['score'].toString(),
              style: GoogleFonts.urbanist(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Image.asset(
              'lib/assets/images/tree.png',
              width: 7.08,
              height: 15,
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildUserTile(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: user['rank'] == 7 ? AppColors.secondary : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            user['rank'].toString(),
            style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.bold),
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
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text(
                user['score'].toString(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
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
