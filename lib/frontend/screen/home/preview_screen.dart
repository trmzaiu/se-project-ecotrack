import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wastesortapp/theme/colors.dart';

class PreviewScreen extends StatelessWidget {
  final String imagePath;

  PreviewScreen({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.file(File(imagePath)),
            ),
          ),

          Column(
            children: [
              Spacer(),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Text(
                      "Scan",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                      },
                      child: Text(
                        "Upload Evidence",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF494848).withOpacity(0.5),
                ),
                child: SvgPicture.asset(
                  'lib/assets/icons/ic_close.svg',
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
