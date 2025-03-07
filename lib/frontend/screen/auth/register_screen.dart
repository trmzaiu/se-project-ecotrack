import 'package:flutter/material.dart';
import 'package:wastesortapp/components/my_button.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

 // class Register extends StatelessWidget {
 //      Register({super.key});
 //      // text editing controllers
 //     final usernameController = TextEditingController();
 //     final passwordController = TextEditingController();

//    @override
//    Widget build(BuildContext context){
//      return Scaffold(
//        backgroundColor: AppColors.background,
//        body: SafeArea(
//      child: SingleChildScrollView(
//      child: Column(
// //     children: [
//     // Top Background with Image
//     Container(
//     width: 414,
//     height: 396,
//     decoration: BoxDecoration(
//     color: Color(0xFF7C3F3E),
//     borderRadius: BorderRadius.vertical(
//     bottom: Radius.circular(20),
//     ),
//     ),
//     child: Center(
//     child: Container(
//     width: 370,
//     height: 370,
//     decoration: BoxDecoration(
//     image: DecorationImage(
//     image: NetworkImage("https://placehold.co/370x370"),
//     fit: BoxFit.fill,
//     ),
//     ),
//     ),
//     ),
//     ),
//
//     SizedBox(height: 24),
//
// // Register form
//     Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 30),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     // Email Input
//     TextField(
//     controller: usernameController,
//     decoration: InputDecoration(
//     labelText: "Email",
//     border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(10),
//     ),
//     filled: true,
//     fillColor: Colors.white,
//     ),
//     ),
//     SizedBox(height: 19),
// // Password Input
//     TextField(
//     controller: passwordController,
//     obscureText: true,
//     decoration: InputDecoration(
//     labelText: "Password",
//     border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(10),
//     ),
//     filled: true,
//     fillColor: Colors.white,
//     ),
//     ),
//
//     SizedBox(height: 15),
// //  Confirm password Input
//   TextField(
//     controller: confirmPasswordController,
//     obscureText: true,
//     decoration: InputDecoration(
//     labelText: "Confirm Password",
//     border: OutlineInputBorder(
//     borderRadius: BorderRadius.circular(10),
//     ),
//     filled: true,
//     fillColor: Colors.white,
//     ),
//     ),
//     // Create account button
//     GestureDetector(
//     onTap: signUserIn,
//     child: Container(
//     width: 330,
//     height: 49,
//     decoration: ShapeDecoration(
//     color: Color(0xFF2C6E49),
//     shape: RoundedRectangleBorder(
//     side: BorderSide(width: 1, color: Color(0xFF2C6E49)),
//     borderRadius: BorderRadius.circular(30),
//     ),
//     ),
//     alignment: Alignment.center,
//     child: Text(
//     "Create Account",
//     style: TextStyle(
//     color: Color(0xFFF3F5F1),
//     fontSize: 18,
//     fontFamily: 'Urbanist',
//     fontWeight: FontWeight.w700,
//     height: 1.11,
//     letterSpacing: -0.23,
//     ),
//     ),
//     ),
//     ),
//
//
//     SizedBox(height: 20),
//       // Login text
//       GestureDetector(
//         onTap: () {
//           Navigator.pushNamed(context, '/login');
//         },
//         child: Center(
//           child: Text.rich(
//             TextSpan(
//               children: [
//                 TextSpan(
//                   text: "Already have an account? ",
//                   style: TextStyle(
//                       color: Color(0xFF2C6E49)
//                   ),
//                 ),
//                 TextSpan(
//                   text: "Login",
//                   style: TextStyle(
//                     color: Color(0xFF7C3F3E),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//
//       SizedBox(height: 30),
//     ],
//     ),
//     ),
//     ],
//     ),
//     ),
//       ),
//     );
//   }
// }
