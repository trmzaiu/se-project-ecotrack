import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class OrganicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guide'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Text(
          'Guide!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}