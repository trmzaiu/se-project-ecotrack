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
  bool hasScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !hasScrolled) {
        setState(() {
          hasScrolled = true;
        });
      } else if (_scrollController.offset <= 10 && hasScrolled) {
        setState(() {
          hasScrolled = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 415,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(width: hasScrolled ? 0 : 25), // Ban đầu có 40px, khi lướt mất đi
              ...goodToKnowItems.map((item) => Container(
                margin: EdgeInsets.only(right: 10),
                height: 200,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      child: Image.asset(
                        item['image']!,
                        width: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 105),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: TextStyle(
                              color: Color(0xFF7C3F3E),
                              fontSize: 16,
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
            ],
          ),
        ),
      ),
    );
  }
}
