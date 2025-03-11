import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';

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
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: AppColors.secondary,
            padding: EdgeInsets.only(top: 60, bottom: 20),
            child: Stack(
              children: [
                Positioned(
                  left: 15,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'lib/assets/icons/ic_back.svg',
                      height: 20,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Upload Evidence',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.urbanist(
                      color: AppColors.surface,
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 26),
                width: double.infinity,
                color: AppColors.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Evidence',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 20,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.only(left: selectedImages.isEmpty ? 0 : 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var image in selectedImages) ...[
                                Container(
                                  width: 360,
                                  height: 360,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20)
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
                                        width: 360,
                                        height: 360,
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
                        )
                      )
                    ),

                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Category',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 20,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            width: 360,
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
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        'Description',
                        style: GoogleFonts.urbanist(
                          color: AppColors.secondary,
                          fontSize: 20,
                          fontWeight: AppFontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 360,
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

                    SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 300,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}