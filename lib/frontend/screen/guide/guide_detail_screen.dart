import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../../theme/fonts.dart';
import '../../utils/phone_size.dart';
import '../../widget/bar_noti_title.dart';
import '../../widget/bar_title.dart';
import '../../widget/guideline_item.dart';
import '../../widget/waste_item.dart';

class GuideDetailScreen extends StatefulWidget {
  final int slide;

  const GuideDetailScreen({Key? key, required this.slide}) : super(key: key);

  @override
  _GuideDetailScreenState createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  bool isGoodExpanded = false;
  bool isBadExpanded = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _bestPracticesKey = GlobalKey();
  final GlobalKey _mistPracticesKey = GlobalKey();

  final List<Map<String, dynamic>> wasteData = [
    {
      "title": "Recyclable Waste",
      "description": "Recyclable waste consists of materials that can be processed and turned \ninto new products.",
      "image": "lib/assets/images/recycle_bin_recyclable_waste.png",
    },
    {
      "title": "Organic Waste",
      "description": "Organic waste consists of biodegradable materials that decompose \nnaturally, turning into \ncompost or biogas.",
      "image": "lib/assets/images/organic_bin_organic_waste.png",
    },
    {
      "title": "Hazardous Waste",
      "description": "Hazardous waste holds \nmaterials that harm \nhealth and environment \ndue to toxicity, flammability, \nor contamination.",
      "image": "lib/assets/images/hazardous_bin_hazardous_waste.png",
    },
    {
      "title": "General Waste",
      "description": "General waste includes items that cannot be recycled, composted, or \nclassified as hazardous, \noften ending up in \nlandfills.",
      "image": "lib/assets/images/general_bin_general_waste.png",
    },
  ];

  final List<Map<String, dynamic>> wasteItems = [
    // Slide 0: Recyclable Waste
    {
      'slide': 0,
      'imagePath': 'lib/assets/images/recycle_bin_plastic.png',
      'title': 'Plastic',
      'svgColor': AppColors.board1,
      'detail': 'Bottles, containers, jugs, clean plastic bags.',
    },
    {
      'slide': 0,
      'imagePath': 'lib/assets/images/recycle_bin_paper.png',
      'title': 'Paper',
      'svgColor': AppColors.board4,
      'detail': 'Newspapers, magazines, cardboard, office paper.',
    },
    {
      'slide': 0,
      'imagePath': 'lib/assets/images/recycle_bin_glass.png',
      'title': 'Glass',
      'svgColor': AppColors.board2,
      'detail': 'Bottles, jars (clear, green, brown).',
    },
    {
      'slide': 0,
      'imagePath': 'lib/assets/images/recycle_bin_metal.png',
      'title': 'Metal',
      'svgColor': AppColors.board3,
      'detail': 'Aluminum cans, tin cans, foil (clean), metal lids.',
    },

    // Slide 1: Organic Waste
    {
      'slide': 1,
      'imagePath': 'lib/assets/images/organic_bin_scrap.png',
      'title': 'Scrap',
      'svgColor': AppColors.board2,
      'detail': 'Fruit peel, eggshell, vegetable leftover.',
    },
    {
      'slide': 1,
      'imagePath': 'lib/assets/images/organic_bin_residue.png',
      'title': 'Residue',
      'svgColor': AppColors.board1,
      'detail': 'Coffee grounds, tea bags, nutshells.',
    },
    {
      'slide': 1,
      'imagePath': 'lib/assets/images/organic_bin_manure.png',
      'title': 'Manure',
      'svgColor': AppColors.board3,
      'detail': 'Animal dung, compostable pet waste.',
    },
    {
      'slide': 1,
      'imagePath': 'lib/assets/images/organic_bin_clipping.png',
      'title': 'Clipping',
      'svgColor': AppColors.board4,
      'detail': 'Grass, leaves, small branches.',
    },

    // Slide 2: Hazardous Waste
    {
      'slide': 2,
      'imagePath': 'lib/assets/images/hazardous_bin_medical.png',
      'title': 'Medical',
      'svgColor': AppColors.board4,
      'detail': 'Expired medicine, needles, syringes.',
    },
    {
      'slide': 2,
      'imagePath': 'lib/assets/images/hazardous_bin_electronic.png',
      'title': 'Electronic',
      'svgColor': AppColors.board3,
      'detail': 'Old phones, batteries, laptops, cables.',
    },
    {
      'slide': 2,
      'imagePath': 'lib/assets/images/hazardous_bin_chemical.png',
      'title': 'Chemical',
      'svgColor': AppColors.board2,
      'detail': 'Paint, pesticides, motor oil, cleaning agents.',
    },
    {
      'slide': 2,
      'imagePath': 'lib/assets/images/hazardous_bin_industrial.png',
      'title': 'Industrial',
      'svgColor': AppColors.board1,
      'detail': 'Heavy metals, solvents, asbestos.',
    },

    // Slide 3: General Waste
    {
      'slide': 3,
      'imagePath': 'lib/assets/images/general_bin_sanitary.png',
      'title': 'Hygiene',
      'svgColor': AppColors.board3,
      'detail': 'Diapers, tissues, sanitary pads.',
    },
    {
      'slide': 3,
      'imagePath': 'lib/assets/images/general_bin_packaging.png',
      'title': 'Packaging',
      'svgColor': AppColors.board2,
      'detail': 'Chip bags, styrofoam, food wrappers.',
    },
    {
      'slide': 3,
      'imagePath': 'lib/assets/images/general_bin_oversized.png',
      'title': 'Oversize',
      'svgColor': AppColors.board1,
      'detail': 'Broken furniture, mattresses, large plastics.',
    },
    {
      'slide': 3,
      'imagePath': 'lib/assets/images/general_bin_fabric.png',
      'title': 'Fabric',
      'svgColor': AppColors.board4,
      'detail': 'Old clothes, worn-out shoes, rags.',
    },
  ];

  final List<Map<String, dynamic>> guideLines = [
    // Slide 0: Recyclable Waste
    // Best Practise
    {
      'slide' : 0,
      'type': 'best',
      'emoji' : '🧽',
      'text': 'Rinse plastic, glass, metal before recycling.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 0,
      'type': 'best',
      'emoji': '📦',
      'text': 'Flatten cardboard and paper to save space.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 0,
      'type': 'best',
      'emoji': '🔄',
      'text': 'Sort materials (plastic, paper, glass, metal).',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 0,
      'type': 'best',
      'emoji': '🏷',
      'text': 'Remove bottle caps if required.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 0,
      'type': 'best',
      'emoji': '🥫',
      'text': 'Drop off aluminum cans at collection points.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },

    // Common Mistake
    {
      'slide' : 0,
      'type': 'mist',
      'emoji': '🚯',
      'text': 'No greasy/contaminated materials.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 0,
      'type': 'mist',
      'emoji': '📌',
      'text': 'No mixing recyclables in one bag.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 0,
      'type': 'mist',
      'emoji': '🛍',
      'text': 'No soft plastics (wrappers) in regular bins.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 0,
      'type': 'mist',
      'emoji': '🍷',
      'text': 'No ceramics, mirrors, or broken glass.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 0,
      'type': 'mist',
      'emoji': '🚮',
      'text': 'No recyclables inside plastic bags.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },

    // Slide 1: Organic Waste
    // Best Practise
    {
      'slide' : 1,
      'type': 'best',
      'emoji' : '🍎',
      'text': 'Separate food scraps for composting.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 1,
      'type': 'best',
      'emoji': '✂️',
      'text': 'Cut large organic waste into smaller pieces.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 1,
      'type': 'best',
      'emoji': '🌾',
      'text': 'Use organic waste for compost or fertilizer.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 1,
      'type': 'best',
      'emoji': '🌿',
      'text': 'Store in biodegradable bags to reduce odor.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 1,
      'type': 'best',
      'emoji': '🗑',
      'text': 'Use a compost bin for nutrient-rich soil.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },

    // Common Mistake
    {
      'slide' : 1,
      'type': 'mist',
      'emoji': '🥩',
      'text': 'No dairy, meat, or oily food (unless allowed).',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 1,
      'type': 'mist',
      'emoji': '🌱',
      'text': 'No diseased plants or invasive weeds.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 1,
      'type': 'mist',
      'emoji': '🐀',
      'text': 'No exposed waste—avoid attracting pests.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 1,
      'type': 'mist',
      'emoji': '🔩',
      'text': 'No mixing with plastic or metal.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 1,
      'type': 'mist',
      'emoji': '🗑',
      'text': 'No tossing in trash if composting is available.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },

    // Slide 2: Hazardous Waste
    // Best Practise
    {
      'slide' : 2,
      'type': 'best',
      'emoji' : '🏷',
      'text': 'Label hazardous waste before disposal.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 2,
      'type': 'best',
      'emoji': '🔋',
      'text': 'Recycle e-waste at proper centers.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 2,
      'type': 'best',
      'emoji': '📜',
      'text': 'Follow local disposal guidelines.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 2,
      'type': 'best',
      'emoji': '💊',
      'text': 'Drop off expired medicines at pharmacies.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 2,
      'type': 'best',
      'emoji': '💡',
      'text': 'Dispose of bulbs and batteries safely.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },

    // Common Mistake
    {
      'slide' : 2,
      'type': 'mist',
      'emoji': '🚮',
      'text': 'No hazardous waste in general trash.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 2,
      'type': 'mist',
      'emoji': '🚰',
      'text': 'No pouring chemicals down drains.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 2,
      'type': 'mist',
      'emoji': '🧪',
      'text': 'Do not mix hazardous materials.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 2,
      'type': 'mist',
      'emoji': '🔥',
      'text': 'No burning hazardous waste.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 2,
      'type': 'mist',
      'emoji': '🛠',
      'text': 'Do not dismantle batteries or electronics.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },

    // Slide 3: General Waste
    // Best Practise
    {
      'slide' : 3,
      'type': 'best',
      'emoji' : '🗑',
      'text': 'Trash non-recyclables properly.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 3,
      'type': 'best',
      'emoji': '🛍',
      'text': 'Wrap sanitary waste before disposal.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 3,
      'type': 'best',
      'emoji': '🗳',
      'text': 'Use trash bags to prevent leaks/odors.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 3,
      'type': 'best',
      'emoji': '🌍',
      'text': 'Reduce waste with reusable.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },
    {
      'slide' : 3,
      'type': 'best',
      'emoji': '📦',
      'text': 'Dispose of mixed-material waste correctly.',
      'color': AppColors.board2,
      'colorFont': AppColors.primary,
    },

    // Common Mistake
    {
      'slide' : 3,
      'type': 'mist',
      'emoji': '🔄',
      'text': 'No mixing waste with recyclables/compost.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 3,
      'type': 'mist',
      'emoji': '☢️',
      'text': 'No hazardous waste in trash bins.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 3,
      'type': 'mist',
      'emoji': '🔌',
      'text': 'No batteries, bulbs, or electronics in trash.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 3,
      'type': 'mist',
      'emoji': '🏭',
      'text': 'Minimize landfill waste.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
    {
      'slide' : 3,
      'type': 'mist',
      'emoji': '🔥',
      'text': 'Do not burn general waste.',
      'color': AppColors.board1,
      'colorFont': AppColors.secondary,
    },
  ];

  List<Map<String, dynamic>> getWasteItemsBySlide(int slide) {
    return wasteItems.where((item) => item['slide'] == slide).toList();
  }

  List<Map<String, dynamic>> getGuileLineBySlide(int slideIndex, String type) {
    return guideLines
        .where((item) => item['slide'] == slideIndex && item['type'] == type)
        .toList();
  }

  void _scrollToExpanded(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 300), () {
        final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero).dy + _scrollController.offset;

          final screenHeight = MediaQuery.of(context).size.height;
          final expandedHeight = renderBox.size.height;

          final isVisible = position >= _scrollController.offset &&
              position + expandedHeight <= _scrollController.offset + screenHeight;

          if (!isVisible) {
            final targetOffset = position - 20;
            _scrollController.animateTo(
              targetOffset - (screenHeight - expandedHeight - 50),
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);
    final waste = wasteData[widget.slide];
    final wasteItem = getWasteItemsBySlide(widget.slide);
    final best = getGuileLineBySlide(widget.slide, 'best');
    final mist = getGuileLineBySlide(widget.slide, 'mist');

    return Scaffold(
      body: Container(
        color: AppColors.background,
        child: Column(
          children: [
            BarNotiTitle(title_small: 'About', title_big: waste['title']),

            SizedBox(height: 25),

            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset('lib/assets/images/background.png', width: 360),

                        Positioned(
                          left: 30,
                          top: 130,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: ShapeDecoration(
                                color: AppColors.primary,
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
                                  'lib/assets/icons/ic_backward.svg', width: 24, height: 24,
                                ),
                              ),
                            ),
                          )
                        ),

                        Positioned(
                          right: -25,
                          top: -30,
                          child: Image.asset(
                            waste['image'],
                            width: 250,
                            height: 250,
                          ),
                        ),

                        Positioned(
                            left: 20,
                            top: 20,
                            child: SizedBox(
                              width: 300,
                              child: Text(
                                waste['description'],
                                style: GoogleFonts.urbanist(
                                  color: AppColors.secondary,
                                  fontSize: 13.5,
                                  fontWeight: AppFontWeight.regular,
                                ),
                              ),
                            )
                        ),
                      ],
                    ),

                    SizedBox(height: 55),

                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Materials',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 20,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          )
                      ),
                    ),

                    SizedBox(height: 28),

                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: wasteItem.map((item) {
                            return Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: WasteItem(
                                imagePath: item['imagePath'],
                                title: item['title'],
                                svgColor: item['svgColor'],
                                detail: item['detail'],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Guidelines',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 20,
                              fontWeight: AppFontWeight.semiBold,
                            ),
                          )
                      ),
                    ),

                    SizedBox(height: 10),

                    GestureDetector(
                      key: _bestPracticesKey,
                      onTap: () {
                        setState(() {
                          isGoodExpanded = !isGoodExpanded;
                          if (isGoodExpanded) {
                            _scrollToExpanded(_bestPracticesKey);
                          }
                        });
                      },
                      child: Column(
                        children: [
                          Container(
                            width: phoneWidth - 40,
                            height: 88,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: isGoodExpanded
                                    ? BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                )
                                    : BorderRadius.circular(15),
                              ),
                              image: DecorationImage(
                                image: isGoodExpanded ? AssetImage('lib/assets/images/best_practices2.png') : AssetImage('lib/assets/images/best_practices.png'),
                                fit: BoxFit.cover
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'BEST\nPRACTICES',
                                  style: GoogleFonts.urbanist(
                                    color: AppColors.surface,
                                    fontSize: 24,
                                    fontWeight: AppFontWeight.extraBold,
                                    height: 1.2,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedSize(
                            duration: Duration(milliseconds: 500),
                            child: Container(
                              width: phoneWidth - 40,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: isGoodExpanded
                                  ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: best
                                      .expand((item) => [
                                    GuidelineItem(
                                      emoji: item['emoji'],
                                      text: item['text'],
                                      color: item['color'],
                                      colorFont: item['colorFont'],
                                    ),
                                    SizedBox(height: 10),
                                  ])
                                      .toList()
                                    ..removeLast(),
                                ),
                              )
                                  : SizedBox.shrink(),
                            ),
                          ),
                        ],
                      )
                    ),

                    SizedBox(height: 15),

                    GestureDetector(
                        key: _mistPracticesKey,
                        onTap: () {
                          setState(() {
                            isBadExpanded = !isBadExpanded;
                            if (isBadExpanded) {
                              _scrollToExpanded(_mistPracticesKey);
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: phoneWidth - 40,
                              height: 88,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: isBadExpanded
                                      ? BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )
                                      : BorderRadius.circular(15),
                                ),
                                image: DecorationImage(
                                    image: isBadExpanded ? AssetImage('lib/assets/images/common_mistakes2.png') : AssetImage('lib/assets/images/common_mistakes.png'),
                                    fit: BoxFit.cover
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(right: 30),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'COMMON\nMISTAKES',
                                    style: GoogleFonts.urbanist(
                                      color: AppColors.surface,
                                      fontSize: 24,
                                      fontWeight: AppFontWeight.extraBold,
                                      height: 1.2,
                                      letterSpacing: 1.2,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                )
                              ),
                            ),
                            AnimatedSize(
                              duration: Duration(milliseconds: 500),
                              child: Container(
                                width: phoneWidth - 40,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: isBadExpanded
                                    ? Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: mist
                                        .expand((item) => [
                                      GuidelineItem(
                                        emoji: item['emoji'],
                                        text: item['text'],
                                        color: item['color'],
                                        colorFont: item['colorFont'],
                                      ),
                                      SizedBox(height: 10),
                                    ])
                                        .toList()
                                      ..removeLast(),
                                  ),
                                )
                                    : SizedBox.shrink(),
                              ),
                            )
                          ],
                        )
                    ),

                    SizedBox(height: 15),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}


