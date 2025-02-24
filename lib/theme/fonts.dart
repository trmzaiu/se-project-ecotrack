import 'package:flutter/material.dart';

class AppFonts {
  static const String primaryFont = 'Nunito';
  static const String secondaryFont = 'Domine';

  static const TextStyle heading = TextStyle(
    fontFamily: primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle body = TextStyle(
    fontFamily: secondaryFont,
    fontSize: 16,
    color: Colors.black87,
  );
}
