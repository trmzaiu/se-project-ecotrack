import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart'; // Chỉ giữ cái này

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: AppColors.background),
          child: Stack(
            children: [
              // Tiêu đề "Hello, EcoTrack"

              Positioned(
                top: 0,
                left: 50,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello,\n',
                        style: TextStyle(
                          color: Color(0xFF9C9385),
                          fontSize: 24,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w900,
                          height: 1.25,
                        ),
                      ),
                      TextSpan(
                        text: 'EcoTrack',
                        style: TextStyle(
                          color: Color(0xFF7C3F3E),
                          fontSize: 32,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w900,
                          height: 0.94,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nút thông báo
              Positioned(
                right: 50, // Căn theo phải thay vì số cứng
                top: 10,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFCFB),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Image.asset(
                      'lib/assets/images/noti.png',
                      width: 25,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Hộp xanh lá
              Positioned(
                top: 80,
                left: 40,
                right: 40, // Thay width cứng bằng `right`
                child: Container(
                  height: 166,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-0.07, -0.12),
                      end: Alignment(1.09, 1.12),
                      colors: [Color(0xFF2C6E49), Color(0xFF5E926F)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 0, bottom: 0),
                          child: Image.asset(
                            'lib/assets/images/sethomemade.png',
                            width: 245,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // Nội dung hộp xanh lá
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 20),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            SizedBox(height: 5),
                            Text(
                              'Have you sorted\nwaste today?',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),

                            SizedBox(height: 5),


                            Text(
                              'Upload your evidence to \nget bonus point.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Nút Upload (Căn phải dưới)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 30), // Cách lề 10px
                          child: Container(
                            width: 60,
                            height: 25,
                            padding: const EdgeInsets.all(5),
                            decoration: ShapeDecoration(
                              color: Color(0xFFFFFCFB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Upload',
                                style: TextStyle(
                                  color: Color(0xFF2C6E49),
                                  fontSize: 10,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),




                    ],
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: 260, left: 40), // Điều chỉnh khoảng cách xuống
                child: SizedBox(
                  width: 176,
                  child: Text(
                    'Categories',
                    style: TextStyle(
                      color: Color(0xFF7C3F3E),
                      fontSize: 16,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              // Hàng danh mục
              Padding(
                padding: EdgeInsets.only(top: 295, left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryBox(image: 'lib/assets/images/recyclable.png', text: 'Recyclable'),
                    CategoryBox(image: 'lib/assets/images/organic_home.png', text: 'Organic'),
                    CategoryBox(image: 'lib/assets/images/hazadous_home.png', text: 'Hazardous'),
                    CategoryBox(image: 'lib/assets/images/general_home.png', text: 'General'),
                  ],
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: 385, left: 45, right: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy về 2 đầu
                  children: [

                    Text(
                      'Good to know',
                      style: TextStyle(
                        color: Color(0xFF7C3F3E),
                        fontSize: 16,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF9C9385),
                        fontSize: 12,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),




            Positioned(
              top: 415,
              left: 40,
              child: Container(
                height: 140,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white, // Nền trắng
                  borderRadius: BorderRadius.circular(15), // Bo góc
                  boxShadow: [ // Thêm đổ bóng nếu muốn
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top:0), // Điều chỉnh padding nếu cần
                        child: Image.asset(
                          'lib/assets/images/goodtoknow.png',
                          width: 300, // Fit full ngang
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                  




                ),
              ),
            )





            ],
          ),
        ),
      ),
    );
  }
}

// Widget tái sử dụng cho từng ô danh mục
class CategoryBox extends StatelessWidget {
  final String image;
  final String text;

  const CategoryBox({required this.image, required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: Color(0xFFFFFCFB),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          Image.asset(image, width: 38, height: 38, fit: BoxFit.contain),
          SizedBox(height: 5),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF5E926F),
              fontSize: 11,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}




