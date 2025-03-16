import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart'; // Chỉ giữ cái này
import 'package:wastesortapp/frontend/screen/home/goodtoknow.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //  Giúp nội dung tràn lên đỉnh màn hình
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Làm trong suốt nếu cần
        elevation: 0, //  Không có bóng
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.background),


              child: Column(

              mainAxisSize: MainAxisSize.min, // Thêm dòng này vào
              crossAxisAlignment: CrossAxisAlignment.start, // Thêm dòng này vào
              children: [

                // Tiêu đề "Hello, EcoTrack"

                // Tiêu đề + Nút thông báo (Gom vào Row)
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, top: 80),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy hai bên ra xa
                    children: [
                      // Chữ "Hello, EcoTrack"
                      Text.rich(
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

                      // Nút thông báo
                      Container(
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
                    ],
                  ),
                ),


                // Hộp xanh lá
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 40, right: 40), // Thay width cứng bằng right
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
                  padding: EdgeInsets.only(top: 20, left: 40), // Điều chỉnh khoảng cách xuống
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
                  padding: EdgeInsets.only(top:5, left: 40, right: 40),
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
                  padding: EdgeInsets.only(top: 10, left: 45, right: 45),
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

                SizedBox(height: 10), // Điều chỉnh khoảng cách hợp lý

                GoodToKnowSection(),

                SizedBox(height: 15), // Điều chỉnh khoảng cách hợp lý

                Padding(
                  padding: EdgeInsets.only(top: 10, left: 45, right: 45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Đẩy về 2 đầu
                    children: [

                      Text(
                        'Challenges',
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


                SizedBox(height: 30), // Điều chỉnh khoảng cách hợp lý

                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Ô màu trắng cũ (120px) với đổ bóng và chứa chữ
                      Container(
                        height: 125,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFCFB),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Align( // Căn nội dung về góc trên bên phải
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 120, top: 15, right: 5), // Đẩy chữ vào trong một chút
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start, // Căn chữ về phải
                              children: [
                                Text(
                                  'Zero Waste Challenge',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7C3F3E),
                                  ),
                                  textAlign: TextAlign.left, // Chữ căn trái
                                ),

                                SizedBox(height: 5),

                                Text(
                                  'Reduce your waste for a whole week! Track your trash, use reusable items, and share your progress with\n#ZeroWasteWeek.',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF9C9385),
                                  ),
                                  textAlign: TextAlign.left, // Chữ căn trái
                                ),

                                SizedBox(height: 10),

                                Text(
                                  '100 attending',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF9C9385),
                                  ),
                                  textAlign: TextAlign.left, // Chữ căn trái
                                ),



                              ],
                            ),
                          ),
                        ),

                      ),

                      // Ô màu trắng mới (150px) chứa ảnh và tràn ra ngoài
                      Positioned(
                        left: 15,
                        right: 220,
                        top: -20,
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'lib/assets/images/zero_waste_challenge.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        right: 15, // Căn lề phải
                        bottom: 20, // Căn lề dưới
                        child: Container(
                          width: 45, // Kích thước ô
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(0xFF7C3F3E),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Join now',  // Chữ hiển thị trong ô
                              style: TextStyle(
                                color: Colors.white,  // Màu chữ
                                fontSize: 8,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center, // Căn giữa
                            ),
                          ),
                        ),
                      ),





                    ],
                  ),
                ),

                SizedBox(height: 30), // Điều chỉnh khoảng cách hợp lý

                Padding(
                  padding: EdgeInsets.only(left: 40, right: 40),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Ô màu trắng cũ (120px) với đổ bóng và chứa chữ
                      Container(
                        height: 125,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFCFB),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Align( // Căn nội dung về góc trên bên phải
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 120, top: 15, right: 5), // Đẩy chữ vào trong một chút
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start, // Căn chữ về phải
                              children: [
                                Text(
                                  'Trash to Treasure Challenge',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7C3F3E),
                                  ),
                                  textAlign: TextAlign.left, // Chữ căn trái
                                ),

                                SizedBox(height: 5),

                                Text(
                                  'Turn waste into something useful! Upcycle old materials into creative DIY products and share with\n#TrashToTreasure',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF9C9385),
                                  ),
                                  textAlign: TextAlign.left, // Chữ căn trái
                                ),

                                SizedBox(height: 10),

                                Text(
                                  '100 attending',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF9C9385),
                                  ),
                                  textAlign: TextAlign.left, // Chữ căn trái
                                ),



                              ],
                            ),
                          ),
                        ),

                      ),

                      // Ô màu trắng mới (150px) chứa ảnh và tràn ra ngoài
                      Positioned(
                        left: 15,
                        right: 220,
                        top: -20,
                        child: Container(
                          height: 130,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'lib/assets/images/trash_to_treasure_challenge.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        right: 15, // Căn lề phải
                        bottom: 20, // Căn lề dưới
                        child: Container(
                          width: 45, // Kích thước ô
                          height: 18,
                          decoration: BoxDecoration(
                            color: Color(0xFF7C3F3E),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Join now',  // Chữ hiển thị trong ô
                              style: TextStyle(
                                color: Colors.white,  // Màu chữ
                                fontSize: 8,
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center, // Căn giữa
                            ),
                          ),
                        ),
                      ),





                    ],
                  ),
                ),








                SizedBox(height: 200), // Điều chỉnh khoảng cách hợp lý



              ],
            ),

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