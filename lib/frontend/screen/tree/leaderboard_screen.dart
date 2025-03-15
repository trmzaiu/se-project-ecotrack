import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          'Welcome to Waste Sorting App!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}