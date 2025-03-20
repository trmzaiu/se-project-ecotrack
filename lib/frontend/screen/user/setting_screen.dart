import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wastesortapp/theme/colors.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: AppColors.background),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 125,
              color: Color(0xFF7C3F3E),
              padding: EdgeInsets.only(left: 0, top: 70, bottom: 10),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: Color(0xFFF7EEE7),
                        fontSize: 18,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.90,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: IconButton(
                        icon: SvgPicture.asset(
                          'lib/assets/icons/ic_back.svg',
                          width: 20,
                          height: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 35),

            Stack(
              alignment: Alignment.center,
              children: [
                // Hình tròn lớn
                Container(
                  width: 175,
                  height: 175,
                  decoration: ShapeDecoration(
                    shape: OvalBorder(
                      side: BorderSide(
                        width: 2,
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ),
                ),

                // Hình tròn nhỏ
                Container(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('lib/assets/images/avatar.png'), // Ảnh từ assets
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 2,  // Căn dưới cùng
                  right: 3,   // Căn phải
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/camera_setting.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),


              ],
            ),

            SizedBox(height: 35),

            //name
            Align(
              alignment: Alignment.centerLeft, // Căn trái
              child: Padding(
                padding: EdgeInsets.only(left: 35), // Điều chỉnh khoảng cách từ lề trái
                child: Text(
                  'Name',
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 0.88,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35), // Lùi vào 35px từ 2 bên
              child: Container(
                height: 44,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFF9C9385),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                child: Padding( // Điều chỉnh vị trí chữ bên trái
                  padding: EdgeInsets.only(left: 15), // Điều chỉnh khoảng cách chữ từ mép trái
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn chữ về bên trái
                    child: Text(
                      "Melissa Peters",
                      style: TextStyle(
                        color: Color(0xFF9C9385),
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              ),
            ),


            SizedBox(height: 18),

            //email
            Align(
              alignment: Alignment.centerLeft, // Căn trái
              child: Padding(
                padding: EdgeInsets.only(left: 35), // Điều chỉnh khoảng cách từ lề trái
                child: Text(
                  'Email',
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 0.88,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35), // Lùi vào 35px từ 2 bên
              child: Container(
                height: 44,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFF9C9385),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                child: Padding( // Điều chỉnh vị trí chữ bên trái
                  padding: EdgeInsets.only(left: 15), // Điều chỉnh khoảng cách chữ từ mép trái
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn chữ về bên trái
                    child: Text(
                      "melpeters@gmail.com",
                      style: TextStyle(
                        color: Color(0xFF9C9385),
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              ),
            ),

            SizedBox(height: 18),

            //Pass
            Align(
              alignment: Alignment.centerLeft, // Căn trái
              child: Padding(
                padding: EdgeInsets.only(left: 35), // Điều chỉnh khoảng cách từ lề trái
                child: Text(
                  'Password',
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 0.88,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Container(
                height: 44,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Color(0xFF9C9385),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Align(
                    alignment: Alignment.centerLeft, // Căn chữ về bên trái
                    child: Text(
                      "************",
                      style: TextStyle(
                        color: Color(0xFF7C3F3E),
                        fontSize: 14,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              ),
            ),

            SizedBox(height: 18),

            //date
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  'Date of Birth',
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 0.88,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Container(
                height: 44,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFF9C9385)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Ngày tháng
                      Expanded(
                        child: Text(
                          "23/05/1995",
                          style: TextStyle(
                            color: Color(0xFF9C9385),
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Điều chỉnh icon cao hơn bằng Transform.translate
                      Transform.translate(
                        offset: Offset(10, -5), // Đẩy icon lên 2px
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'lib/assets/icons/ic_date_profile.svg',
                            width: 20,
                            height: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),




            SizedBox(height: 18),

            //country
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  'Country/Region',
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 16,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    height: 0.88,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Container(
                height: 44,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: Color(0xFF9C9385)),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Ngày tháng
                      Expanded(
                        child: Text(
                          "Nigeria",
                          style: TextStyle(
                            color: Color(0xFF9C9385),
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Transform.translate(
                        offset: Offset(10, -5),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'lib/assets/icons/ic_country_profile.svg',
                            width: 20,
                            height: 20,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}
