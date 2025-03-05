import 'package:flutter/material.dart';
import 'ScanAI/scanUI.dart';
import 'frontend/screen/home/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste Sorting App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ImageClassifier(), // Màn hình khởi động
    );
  }
}
