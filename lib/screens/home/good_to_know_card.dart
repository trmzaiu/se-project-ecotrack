import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class GoodToKnowPageView extends StatelessWidget {
  GoodToKnowPageView({super.key});

  final List<Map<String, String>> _articles = [
    {
      'title': 'Turning Waste Into Resources',
      'image': 'https://media.nhandan.vn/Uploaded/2024/khoahoccongnghe/td_plastics.jpg',
      'url': 'https://en.nhandan.vn/turning-waste-into-resources-with-sorting-post142814.html',
      'date': 'December 30, 2024'
    },
    {
      'title': 'Garbage Sorting Guidelines',
      'image': 'https://www.reelpaper.com/cdn/shop/articles/understanding-the-different-types-of-waste-the-reel-talk-864585_1024x1024.jpg?v=1698211553',
      'url': 'https://www.reelpaper.com/blogs/reel-talk/types-of-waste?srsltid=AfmBOoqX4UKmsOBfjyTiazu2SpuKwGgajcvoVZ1LvMkFcYXSSBudAQ8K',
      'date': 'October 23, 2023'
    },
    {
      'title': 'Waste Sorting AT Home',
      'image': 'https://static.vietnamnews.vn/uploadvnnews/Article/2022/3/9/121510_wastesorting.jpg',
      'url': 'https://vietnamnews.vn/environment/1160427/waste-sorting-at-home-a-little-act-with-a-big-impact.html',
      'date': 'March 01, 2022'
    },
  ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final phoneWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: 160,
          width: phoneWidth - 40,
          child: PageView.builder(
            itemCount: _articles.length,
            itemBuilder: (context, index) {
              var item = _articles[index];
              return GestureDetector(
                onTap: () => _launchUrl(item['url']!),
                child: Column(
                  children: [
                    Container(
                      width: phoneWidth - 40,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(item['image']!),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 15, top: 5, bottom: 12),
                      width: phoneWidth - 40,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C000000),
                            blurRadius: 10,
                            offset: Offset(0, 1),
                          )
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item['title']!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.urbanist(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
