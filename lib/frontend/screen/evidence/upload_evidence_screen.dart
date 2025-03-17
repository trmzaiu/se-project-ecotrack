import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastesortapp/frontend/widget/bar_title.dart';

import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../utils/phone_size.dart';

class UploadScreen extends StatefulWidget {
  final String imagePath;

  UploadScreen({required this.imagePath});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? selectedCategory;
  bool isDropdownOpened = false;
  List<File> selectedImages = [];
  List<String> categories = ["Recyclable", "Organic", "Hazardous", "General"];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    if (widget.imagePath.isNotEmpty) {
      selectedImages.add(File(widget.imagePath));

      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });

      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: AppColors.secondary,
        child: Column(
          children: [
            BarTitle(title: 'Upload Evidence', showBackButton: true),
            SizedBox(height: 30),
            Expanded(
              child: Container(
                  padding: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  color: AppColors.background,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Evidence',
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 18,
                              fontWeight: AppFontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SingleChildScrollView(
                                controller: _scrollController,
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: EdgeInsets.only(left: selectedImages.isEmpty ? 0 : 30),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (var i = 0; i < selectedImages.length; i++) ...[
                                        Stack(
                                          children: [
                                            Container(
                                              width: phoneWidth - 60,
                                              height: phoneWidth - 60,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                image: DecorationImage(
                                                  image: FileImage(selectedImages[i]),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 10,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedImages.removeAt(i);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.4),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: EdgeInsets.all(5),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: 20),
                                      ],

                                      if (selectedImages.length < 5) ...[
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: DottedBorder(
                                            color: AppColors.primary,
                                            strokeWidth: 3,
                                            dashPattern: [8, 4],
                                            borderType: BorderType.RRect,
                                            radius: Radius.circular(8),
                                            child: GestureDetector(
                                              onTap: _pickImage,
                                              child: Container(
                                                width: phoneWidth - 60,
                                                height: phoneWidth - 60,
                                                decoration: BoxDecoration(
                                                  color: AppColors.accent,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: SvgPicture.asset(
                                                      'lib/assets/icons/ic_plus.svg',
                                                      height: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (selectedImages.isNotEmpty) SizedBox(width: 20),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Category',
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 18,
                              fontWeight: AppFontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                width: phoneWidth - 60,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    value: selectedCategory,
                                    isExpanded: true,

                                    buttonStyleData: ButtonStyleData(
                                      decoration: BoxDecoration(
                                        color: AppColors.accent,
                                        borderRadius: isDropdownOpened
                                            ? BorderRadius.vertical(top: Radius.circular(10))
                                            : BorderRadius.circular(10),
                                      ),
                                    ),

                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                        color: AppColors.accent,
                                      ),
                                      elevation: 0,
                                      maxHeight: 250,
                                    ),

                                    menuItemStyleData: MenuItemStyleData(
                                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                    ),

                                    hint: Text(
                                      'Select category',
                                      style: GoogleFonts.urbanist(
                                        color: AppColors.tertiary,
                                        fontSize: 15,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),

                                    iconStyleData: IconStyleData(
                                      icon: Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(Icons.arrow_drop_down, color: AppColors.tertiary),
                                      ),
                                    ),

                                    onMenuStateChange: (isOpen) {
                                      setState(() {
                                        isDropdownOpened = isOpen;
                                      });
                                    },

                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCategory = newValue;
                                      });
                                    },

                                    items: categories.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(
                                          category,
                                          style: GoogleFonts.urbanist(fontSize: 15, color: AppColors.tertiary),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 15),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            'Description',
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 18,
                              fontWeight: AppFontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Container(
                            width: phoneWidth - 60,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              maxLines: 3,
                              style: GoogleFonts.urbanist(
                                color: AppColors.tertiary,
                                fontSize: 15,
                              ),
                              cursorColor: AppColors.secondary,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                hintText: 'Type some description...',
                                hintStyle: GoogleFonts.urbanist(
                                  color: AppColors.tertiary,
                                  fontSize: 15,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 25),
                        Center(
                          child: Container(
                            width: phoneWidth - 112,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: Color(0xFF2C6E49),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Submit",
                                style: GoogleFonts.urbanist(
                                  color: AppColors.surface,
                                  fontSize: 18,
                                  fontWeight: AppFontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      )
    );
  }
}