import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

class OpenningScreen extends StatelessWidget {
  OpenningScreen({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

// void signUserIn() {
//   // Implement logic here
// }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
            child: Stack(
                children: [
                ]
            )
        )
    );
  }
//
// GestureDetector(
// onTap: signUserIn,
// child: Container(
// width: double.infinity,
// height: 50,
// decoration: BoxDecoration(
// color: AppColors.primary,
// borderRadius: BorderRadius.circular(30),
// ),
// alignment: Alignment.center,
// child: Text("Login",
// style: TextStyle(
// color: AppColors.surface,
// fontSize: 18,
// fontWeight: FontWeight.bold)),
// ),
// ),
}
