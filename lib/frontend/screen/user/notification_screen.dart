import 'package:flutter/material.dart';
import 'package:wastesortapp/theme/colors.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment(-0.3, -0.3), // Điều chỉnh vị trí gần X: 155, Y: 73 (dựa trên tỷ lệ)
          child: Text(
            'Notification\n',
            textAlign: TextAlign.center,  // Căn giữa chữ
            style: TextStyle(
              color: Color(0xFFF7EEE7),  // Màu chữ
              fontSize: 18,
              fontFamily: 'Urbanist',  // Font chữ
              fontWeight: FontWeight.w600,  // Độ đậm của chữ
              letterSpacing: 0.90,  // Khoảng cách giữa các chữ
            ),
          ),
        ),
        backgroundColor: Color(0xFF7C3F3E),  // Màu nền của AppBar
      ),
      body: Stack(
        children: [
          // Thêm Container vào Body
          Container(
            width: 412,
            height: 795,
            decoration: ShapeDecoration(
              color: Color(0xFFF7EEE7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ),

          // Column để xếp các widget theo chiều dọc
          Column(
            children: [
              // Căn chữ "Today" ở vị trí X: 16, Y: 159 bằng cách dùng Padding
              Align(
                alignment: Alignment.topLeft, // Điều chỉnh vị trí X: 16, Y: 159
                child: Container(
                  width: 57,  // Chiều rộng chữ "Today"
                  height: 12, // Chiều cao chữ "Today"
                  child: Text(
                    'Today',
                    style: TextStyle(
                      color: Color(0xFF7C3F3E),
                      fontSize: 20,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w400,
                      height: 0.60,
                      letterSpacing: 0.20,
                    ),
                  ),
                ),
              ),

              // Thêm Column vào dưới chữ "Today"
              Padding(
                padding: const EdgeInsets.only(top: 10),  // Khoảng cách giữa "Today" và Container
                child: Container(
                  width: 380,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFFCFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],

                      ),
                      SizedBox(width: 5,),
                      Column(
                        children: [
                          // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                          Align(
                            alignment: Alignment.topLeft,  // X: 60, Y: 15
                            child: SizedBox(
                              width: 260,
                              child: Text(
                                'Water Level Reached the Limit!',
                                style: TextStyle(
                                  color: Color(0xFF7C3F3E),
                                  fontSize: 14,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w600,
                                  height: 0.86,
                                  letterSpacing: 0.14,
                                ),
                              ),
                            ),
                          ),
                          // Thêm khoảng cách 4 giữa 2 SizedBox
                          SizedBox(height: 4),
                          // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                          Align(
                            alignment: Alignment.topLeft,  // X: 60, Y: 31
                            child: SizedBox(
                              width: 260,
                              child: Text(
                                'The water level has hit the threshold. Check now to prevent overflow or adjust as needed.',
                                style: TextStyle(
                                  color: Color(0xFF9C9385),
                                  fontSize: 14,
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w600,
                                  height: 0.86,
                                  letterSpacing: 0.14,
                                ),
                              ),
                            ),
                          ),
                        ],

                      ),

                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight, // Align it to the top-left
                            child: Transform.translate(
                              offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                              child: SizedBox(
                                width: 41,
                                height: 13.71,
                                child: Text(
                                  '1:00 PM',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 12,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 1,
                                    letterSpacing: 0.12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center, // Adjust the alignment as needed
                            child: Transform.translate(
                              offset: Offset(10, 0), // Translate the image to the specific position
                              child: Container(
                                width: 32,
                                height: 27,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("lib/assets/images/guide_buttonnoti.png"), // Image from assets
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )


                    ],

                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFFCFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],

                        ),
                        SizedBox(width: 5,),
                        Column(
                          children: [
                            // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 15
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Congrats! Your Evidence Was Approved',
                                  style: TextStyle(
                                    color: Color(0xFF7C3F3E),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            // Thêm khoảng cách 4 giữa 2 SizedBox
                            SizedBox(height: 4),
                            // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 31
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight, // Align it to the top-left
                              child: Transform.translate(
                                offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                                child: SizedBox(
                                  width: 41,
                                  height: 13.71,
                                  child: Text(
                                    '1:00 PM',
                                    style: TextStyle(
                                      color: Color(0xFF9C9385),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center, // Adjust the alignment as needed
                              child: Transform.translate(
                                offset: Offset(10, 0), // Translate the image to the specific position
                                child: Container(
                                  width: 32,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("lib/assets/images/guide_buttonnoti.png"), // Image from assets
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )


                      ],

                    )
                ),
              ),   //Congrats today
            ],
          ),
          //Column Mar 11, 2015
          Column(
            children: [
              // Căn chữ "Mar" ở vị trí X: 16, Y: 159 bằng cách dùng Padding
              Align(
                alignment: Alignment.topLeft, // Align the text to the top-left
                child: Transform.translate(
                  offset: Offset(16, 210), // Shift to position X: 16, Y: 362
                  child: Container(
                    width: 120,  // Width of the text box
                    height: 12,  // Height of the text box
                    child: Text(
                      'Mar 11, 2015',
                      style: TextStyle(
                        color: Color(0xFF7C3F3E),
                        fontSize: 20,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w400,
                        height: 0.60,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 220),  // Khoảng cách giữa "Today" và Container
                child: Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFFCFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],

                        ),
                        SizedBox(width: 5,),
                        Column(
                          children: [
                            // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 15
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Water Level Reached the Limit!',
                                  style: TextStyle(
                                    color: Color(0xFF7C3F3E),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            // Thêm khoảng cách 4 giữa 2 SizedBox
                            SizedBox(height: 4),
                            // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 31
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'The water level has hit the threshold. Check now to prevent overflow or adjust as needed.',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight, // Align it to the top-left
                              child: Transform.translate(
                                offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                                child: SizedBox(
                                  width: 40,
                                  height: 13.71,
                                  child: Text(
                                    '1:00 PM',
                                    style: TextStyle(
                                      color: Color(0xFF9C9385),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )


                      ],

                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFFCFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],

                        ),
                        SizedBox(width: 5,),
                        Column(
                          children: [
                            // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 15
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Congrats! Your Evidence Was Approved',
                                  style: TextStyle(
                                    color: Color(0xFF7C3F3E),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            // Thêm khoảng cách 4 giữa 2 SizedBox
                            SizedBox(height: 4),
                            // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 31
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight, // Align it to the top-left
                              child: Transform.translate(
                                offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                                child: SizedBox(
                                  width: 41,
                                  height: 13.71,
                                  child: Text(
                                    '1:00 PM',
                                    style: TextStyle(
                                      color: Color(0xFF9C9385),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center, // Adjust the alignment as needed
                              child: Transform.translate(
                                offset: Offset(10, 0), // Translate the image to the specific position
                                child: Container(
                                  width: 32,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("lib/assets/images/guide_buttonnoti.png"), // Image from assets
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )


                      ],

                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFFCFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],

                        ),
                        SizedBox(width: 5,),
                        Column(
                          children: [
                            // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 15
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Congrats! Your Evidence Was Approved',
                                  style: TextStyle(
                                    color: Color(0xFF7C3F3E),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            // Thêm khoảng cách 4 giữa 2 SizedBox
                            SizedBox(height: 4),
                            // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 31
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight, // Align it to the top-left
                              child: Transform.translate(
                                offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                                child: SizedBox(
                                  width: 41,
                                  height: 13.71,
                                  child: Text(
                                    '1:00 PM',
                                    style: TextStyle(
                                      color: Color(0xFF9C9385),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )


                      ],

                    )
                ),
              ),




            ],
          ),

          //Column Feb 11,2025

          Column(
            children: [
              // Căn chữ "Feb" ở vị trí X: 16, Y: 159 bằng cách dùng Padding
              Align(
                alignment: Alignment.topLeft, // Align the text to the top-left
                child: Transform.translate(
                  offset: Offset(16, 510), // Shift to position X: 16, Y: 362
                  child: Container(
                    width: 120,  // Width of the text box
                    height: 12,  // Height of the text box
                    child: Text(
                      'Feb 11, 2015',
                      style: TextStyle(
                        color: Color(0xFF7C3F3E),
                        fontSize: 20,
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w400,
                        height: 0.60,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 520),  // Khoảng cách giữa "Today" và Container
                child: Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFFCFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],

                        ),
                        SizedBox(width: 5,),
                        Column(
                          children: [
                            // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 15
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Water Level Reached the Limit!',
                                  style: TextStyle(
                                    color: Color(0xFF7C3F3E),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            // Thêm khoảng cách 4 giữa 2 SizedBox
                            SizedBox(height: 4),
                            // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 31
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'The water level has hit the threshold. Check now to prevent overflow or adjust as needed.',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight, // Align it to the top-left
                              child: Transform.translate(
                                offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                                child: SizedBox(
                                  width: 41,
                                  height: 13.71,
                                  child: Text(
                                    '1:00 PM',
                                    style: TextStyle(
                                      color: Color(0xFF9C9385),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )


                      ],

                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFFCFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],

                        ),
                        SizedBox(width: 5,),
                        Column(
                          children: [
                            // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 15
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Congrats! Your Evidence Was Approved',
                                  style: TextStyle(
                                    color: Color(0xFF7C3F3E),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            // Thêm khoảng cách 4 giữa 2 SizedBox
                            SizedBox(height: 4),
                            // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 31
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight, // Align it to the top-left
                              child: Transform.translate(
                                offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                                child: SizedBox(
                                  width: 41,
                                  height: 13.71,
                                  child: Text(
                                    '1:00 PM',
                                    style: TextStyle(
                                      color: Color(0xFF9C9385),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )


                      ],

                    )
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                    width: 380,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: ShapeDecoration(
                      color: Color(0xFFFFFCFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Color(0xFFD9D9D9),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],

                        ),
                        SizedBox(width: 5,),
                        Column(
                          children: [
                            // SizedBox đầu tiên, căn chỉnh với Padding X: 60, Y: 15
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 15
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Congrats! Your Evidence Was Approved',
                                  style: TextStyle(
                                    color: Color(0xFF7C3F3E),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                            // Thêm khoảng cách 4 giữa 2 SizedBox
                            SizedBox(height: 4),
                            // SizedBox thứ hai, căn chỉnh với Padding X: 60, Y: 31
                            Align(
                              alignment: Alignment.topLeft,  // X: 60, Y: 31
                              child: SizedBox(
                                width: 260,
                                child: Text(
                                  'Your evidence submission is approved! You earned [X] points. Keep contributing for more rewards!',
                                  style: TextStyle(
                                    color: Color(0xFF9C9385),
                                    fontSize: 14,
                                    fontFamily: 'Urbanist',
                                    fontWeight: FontWeight.w600,
                                    height: 0.86,
                                    letterSpacing: 0.14,
                                  ),
                                ),
                              ),
                            ),
                          ],

                        ),

                        Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight, // Align it to the top-left
                              child: Transform.translate(
                                offset: Offset(20, 0), // Shift to the left by 10 units (negative value for left, positive for right)
                                child: SizedBox(
                                  width: 41,
                                  height: 13.71,
                                  child: Text(
                                    '1:00 PM',
                                    style: TextStyle(
                                      color: Color(0xFF9C9385),
                                      fontSize: 12,
                                      fontFamily: 'Urbanist',
                                      fontWeight: FontWeight.w600,
                                      height: 1,
                                      letterSpacing: 0.12,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )


                      ],

                    )
                ),
              ),




            ],
          ),


        ],
      ),
    );
  }
}
