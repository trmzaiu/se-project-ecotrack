import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
          child: GestureDetector(
            child: Text(
              'Welcome ',
              style: TextStyle(fontSize: 20),
            ),
          )
      ),
    );
  }
}