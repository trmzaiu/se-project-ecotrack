import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import thư viện SVG
import 'package:wastesortapp/theme/colors.dart'; // Đảm bảo đã import AppColors

class HazardousScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100), // Tăng chiều cao AppBar nếu cần
        child: AppBar(
          backgroundColor: AppColors.background,
          title: Align(
            alignment: Alignment.centerLeft, // Căn sát trái
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Căn toàn bộ nội dung về trái
              children: [
                Text(
                  'About',
                  style: TextStyle(
                    color: Color(0xFF9C9385),
                    fontSize: 24,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                Text(
                  'Hazarduos waste',
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
          centerTitle: false, // Không căn giữa tiêu đề
          toolbarHeight: 100, // Tăng chiều cao AppBar
          titleSpacing: 0, // Đảm bảo không có khoảng cách thừa
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.background,
        child: Stack(
          clipBehavior: Clip.none, // Để hình tròn có thể hiển thị vượt ra ngoài
          children: [
            // Hình chữ nhật bo góc 20 độ
            Positioned(
              left: 18,
              top: 20,
              child: Container(
                width: 378,
                height: 160,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFCFB), // Màu nền #FFFCFB
                  borderRadius: BorderRadius.circular(20), // Bo góc 20
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Hiệu ứng đổ bóng nhẹ
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16), // Thêm padding để nội dung đẹp hơn
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 210,
                        child: Text(
                          'Hazardous waste consists   of materials that harms   health and the environment due to toxicity, flammability,   or contamination.',
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 15,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Hình tròn màu xanh (nằm một phần ra ngoài hình chữ nhật) + SVG icon
            Positioned(
              left: 50, // Điều chỉnh vị trí ngang của hình tròn
              top: 155, // Hình tròn nhô ra ngoài khung
              child: Container(
                width: 52.19,
                height: 52.19,
                decoration: ShapeDecoration(
                  color: Color(0xFF2C6E49),
                  shape: OvalBorder(),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 10,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'lib/assets/icons/ic_backward.svg', // Đường dẫn đến file SVG
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn), // Đổi màu SVG thành trắng
                  ),
                ),
              ),
            ),

            // Hình ảnh thùng rác trùng khung
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 20, // Căn giữa theo chiều ngang
              top: 20, // Điều chỉnh vị trí theo nhu cầu
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bo góc khung hình trùng với ảnh
                child: Image.asset(
                  "lib/assets/images/hazardous_bin_waste1.png", // Đường dẫn đến ảnh local
                  width: 235, // Đảm bảo kích thước hình trùng với khung
                  height: 235,
                  fit: BoxFit.fill, // Đảm bảo ảnh trùng khung, không bị méo
                ),
              ),
            ),

            // Văn bản "Materials" nằm dưới khung
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 220, // Căn giữa theo chiều ngang
              top: 250, // Đặt bên dưới khung
              child: SizedBox(
                width: 176,
                child: Text(
                  'Materials',
                  textAlign: TextAlign.center, // Căn giữa văn bản
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 28,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),

            // Bọc tất cả khung trong SingleChildScrollView để tạo hiệu ứng vuốt ngang
            Positioned(
              left: 8, // Căn sát lề trái
              top: 295.21, // Giữ cùng vị trí theo chiều dọc
              child: Container(
                width: MediaQuery.of(context).size.width, // Chiều rộng toàn màn hình
                height: 180, // Chiều cao đủ hiển thị khung
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Vuốt ngang
                  child: Row(
                    children: [
                      // Khung thứ nhất - "Medical"
                      Container(
                        width: 157.86,
                        height: 176.07,
                        decoration: BoxDecoration(
                          color: Color(0xFFA08D7E), // Màu nền #A08D7E
                          borderRadius: BorderRadius.circular(30), // Bo góc 30 độ
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Hiệu ứng bóng
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start, // Căn chữ về bên trái
                          children: [
                            // Hình ảnh
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15), // Bo góc hình ảnh
                                child: Image.asset(
                                  'lib/assets/images/hazarduos_bin_medical.png', // Hình ảnh
                                  width: 100, // Điều chỉnh kích thước ảnh
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10), // Khoảng cách giữa ảnh và chữ
                            // Văn bản "Medical" căn trái
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Medical',
                                style: TextStyle(
                                  color: Color(0xFFFFFCFB),
                                  fontSize: 18,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10), // Khoảng cách giữa các khung

                      // Khung thứ hai - "Electronic"
                      Container(
                        width: 157.86,
                        height: 176.07,
                        decoration: BoxDecoration(
                          color: Color(0xFFB6AA9A), // Màu nền #B6AA9A
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hình ảnh
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'lib/assets/images/hazarduos_bin_electronic.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Văn bản "Electronic" căn trái
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Electronic',
                                style: TextStyle(
                                  color: Color(0xFFFFFCFB),
                                  fontSize: 18,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),

                      // Khung thứ ba - "Glass"
                      Container(
                        width: 157.86,
                        height: 176.07,
                        decoration: BoxDecoration(
                          color: Color(0xFF5E926F), // Màu nền #5E926F
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hình ảnh
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'lib/assets/images/hazarduos_bin_chemical.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            // Văn bản "Glass" căn trái
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Chemical',
                                style: TextStyle(
                                  color: Color(0xFFFFFCFB),
                                  fontSize: 18,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),

                      // Khung thứ tư - "Industrial"
                      Container(
                        width: 157.86,
                        height: 176.07,
                        decoration: BoxDecoration(
                          color: Color(0xFFA46160), // Màu nền #A46160
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Hình ảnh
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  'lib/assets/images/hazarduos_bin_industrial.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            // Văn bản "Industrial" căn trái
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                'Industrial',
                                style: TextStyle(
                                  color: Color(0xFFFFFCFB),
                                  fontSize: 18,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 18,  // Căn trái theo khung
              top: 490,  // Vị trí Y cụ thể, căn dưới khung Material
              child: SizedBox(
                width: 176,
                height: 50,
                child: Text(
                  'Guidelines',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xFF7C3F3E),
                    fontSize: 27,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              width: 383,
              margin: EdgeInsets.only(top: 540, left: 16), // Cách lề trên 20px
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Khung "BEST PRACTICES" với ảnh recycle_bin_rectangle.png

                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Image.asset(
                          'lib/assets/images/recycle_bin_rectangle.png', // Ảnh đầu tiên
                          width: 383,
                          height: 88,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 30,
                          top: 16,
                          child: SizedBox(
                            width: 243.48,
                            child: Text(
                              'BEST PRACTICES',
                              style: TextStyle(
                                color: Color(0xFFFFFCFB),
                                fontSize: 27,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w800,
                                height: 1.17,
                                letterSpacing: 1.20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16), // Khoảng cách giữa hai khung

                  // Khung "COMMON MISTAKES" với ảnh recycle_bin_rectangle2.png
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      children: [
                        Image.asset(
                          'lib/assets/images/recycle_bin_rectangle2.png', // Ảnh thứ hai
                          width: 383,
                          height: 88,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 77,
                          top: 16,
                          child: SizedBox(
                            width: 243.48,
                            child: Text(
                              'COMMON MISTAKES',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Color(0xFFFFFCFB),
                                fontSize: 27,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w800,
                                height: 1.17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}