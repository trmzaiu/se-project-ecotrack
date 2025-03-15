import 'package:flutter/material.dart';

final List<Map<String, String>> goodToKnowItems = [
  {
    'image': 'lib/assets/images/goodtoknow.png',
    'title': 'Smart Solutions for Waste Sorting',
    'date': 'January 12, 2022',
  },
  {
    'image': 'lib/assets/images/goodtoknow.png',
    'title': 'Why Recycling Matters?',
    'date': 'February 05, 2022',
  },
  {
    'image': 'lib/assets/images/goodtoknow.png',
    'title': 'Eco-Friendly Waste Disposal Tips',
    'date': 'March 18, 2022',
  },
];

class GoodToKnowSection extends StatefulWidget {
  @override
  _GoodToKnowSectionState createState() => _GoodToKnowSectionState();
}

class _GoodToKnowSectionState extends State<GoodToKnowSection> {
  final ScrollController _scrollController = ScrollController();
  double leftPadding = 40;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        leftPadding = _scrollController.offset > 10 ? 0 : 40;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      top: 415,
      left: leftPadding,
      right: 0,
      child: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width - 80,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: goodToKnowItems.map((item) => Container(
              margin: EdgeInsets.only(right: 10),
              height: 150,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),

              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0), // Điều chỉnh padding nếu cần
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),  // Bo góc trên trái
                          topRight: Radius.circular(15), // Bo góc trên phải
                        ),
                        child: Image.asset(
                          item['image']!,
                          width: 300, // Fit full ngang
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),



                  // Văn bản
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 95),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: TextStyle(
                            color: Color(0xFF7C3F3E),
                            fontSize: 14,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          item['date']!,
                          style: TextStyle(
                            color: Color(0xFF5E926F),
                            fontSize: 12,
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
        ),
      ),
    );
  }
}
