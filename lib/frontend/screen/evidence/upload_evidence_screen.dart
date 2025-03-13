import 'dart:io';
import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  final String imagePath;

  UploadScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Evidence"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Image.file(File(imagePath), height: 300),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {

            },
            child: Text("Upload"),
          ),
        ],
      ),
    );
  }
}
