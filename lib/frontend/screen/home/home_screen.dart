import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class HomeScreen extends StatelessWidget {
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Welcome to Waste Sorting App!',
              style: TextStyle(fontSize: 20),
            ),
            // SizedBox(height: 10), // Add some spacing
            // Text(
            //   userId,
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          ],
        ),
      ),
    );
  }
}