import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.green,
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
