import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          'Notification!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}