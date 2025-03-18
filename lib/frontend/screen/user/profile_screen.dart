import 'package:flutter/material.dart';
import 'package:wastesortapp/frontend/screen/user/setting_screen.dart';
import 'package:wastesortapp/theme/colors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingScreen()),
            );
          },
          child: Text(
            'Welcome ',
            style: TextStyle(fontSize: 20),
          ),
        )
      ),
    );
  }
}