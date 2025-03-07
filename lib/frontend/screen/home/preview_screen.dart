import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF494848).withOpacity(0.5),
                ),
                child: SvgPicture.asset(
                  'lib/assets/icons/ic_close.svg',
                  height: 40,
                ),
              ),
            ),
          ),
        ]
      )
    );
  }
}
