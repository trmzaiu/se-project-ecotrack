import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/screen/home/home_screen.dart';
import 'package:wastesortapp/frontend/screen/user/profile_screen.dart';
import 'package:wastesortapp/theme/colors.dart';
import 'package:wastesortapp/theme/fonts.dart';

class EditProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: const Color(0xFF7C3F3E)),
            child: Column(
              children: [
                Container(
                  height: 125,
                  alignment: Alignment.center,
                  child: Text(
                    'Edit Profile',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      color: AppColors.background,
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      letterSpacing: 0.90,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7EEE7),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 165.94,
                              height: 170.30,
                              decoration: ShapeDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("https://placehold.co/166x170"),
                                  fit: BoxFit.cover,
                                ),
                                shape: OvalBorder(),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.camera_alt, color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Name',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        initialValue: 'Melissa Peters',
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.tertiary),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Email',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        initialValue: 'melpeters@gmail.com',
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.tertiary),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Password',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        initialValue: '************',
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.tertiary),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Date of Birth',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        initialValue: '23/05/1995',
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today, color: AppColors.tertiary),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: AppColors.tertiary),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Country/Region',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 16,
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: 'Nigeria',
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color:AppColors.tertiary),
                          ),
                        ),
                        icon: Icon(Icons.arrow_drop_down, color: AppColors.tertiary),
                        items: [
                          'Nigeria',
                          'United States',
                          'Cam Ganh',
                          'Daslas',
                          'Nha Trang',
                          'VietNam',
                          '   ^Hoang Sa Truong Sa cua ^',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: GoogleFonts.urbanist(
                                color: AppColors.secondary,
                                fontSize: 14,
                                fontWeight: AppFontWeight.regular,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          print("Selected Country: $newValue");
                        },
                      ),
                      SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3F3E),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text(
                  'Save',
                  style: GoogleFonts.urbanist(
                    color: AppColors.background,
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
              ),
            ),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
