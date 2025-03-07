// import 'package:flutter/material.dart';
//
// class MyTextField extends StatelessWidget {
//   final controller;
//   final String hintText;
//   final bool obscureText;
//
//   const MyTextField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.obscureText,
//   });
//   @override
//   Widget _buildInputField(String hintText, TextEditingController controller, bool isPassword) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           contentPadding: EdgeInsets.symmetric(horizontal: 20),
//           border: InputBorder.none,
//           hintText: hintText,
//           hintStyle: TextStyle(color: Color(0xFF9C9385)),
//         ),
//       ),
//     );
//   }
// }