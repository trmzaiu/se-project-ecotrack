import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../../theme/fonts.dart';
import '../../utils/phone_size.dart';
import '../../widget/bar_title.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController _dateController = TextEditingController();
  // String? selectedCountry;
  Country? selectedCountry;

  @override
  void initState() {
    super.initState();
    _dateController.text = user['dob'];
  }

  final Map<String, dynamic> user = {
    'photoUrl': 'lib/assets/images/user_image.png',
    'name': 'Gwen Stacy',
    'email': 'gwenstacy@example.com',
    'dob': '23/05/1995',
    'tree': '4',
    'evidence': '14'
  };

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            canvasColor: AppColors.background,
            primaryColor: AppColors.primary,
            hintColor: AppColors.secondary,
            colorScheme: ColorScheme.light(primary: AppColors.primary),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
              ),
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.background),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0]; // Format Date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.secondary,
        child: Column(
          children: [
            BarTitle(title: 'Edit Profile', showBackButton: true),

            SizedBox(height: 30),

            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.background,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 175,
                              height: 175,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.accent.withOpacity(0.5),
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  user['photoUrl'],
                                  fit: BoxFit.cover,
                                  width: 170,
                                  height: 170,
                                ),
                              ),
                            ),

                            Positioned(
                              right: 5,
                              bottom: 0,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  // color: AppColors.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.accent.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    shape: CircleBorder(),
                                    padding: EdgeInsets.zero,
                                    backgroundColor: AppColors.surface,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    overlayColor: AppColors.primary
                                  ),
                                  child: Icon(Icons.camera_alt, color: AppColors.accent),
                                )
                              ),
                            )
                          ],
                        ),
                      ),

                      _information('Name', user['name']),
                      _information('Email', user['email']),
                      _information('Password', '••••••••••••'),

                      SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            'Date of Birth',
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 18,
                              fontWeight: AppFontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 5),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: AppColors.secondary.withOpacity(0.3),
                          splashColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            print("${user['name']} tapped");
                          },
                          child: SizedBox(
                            width: getPhoneWidth(context) - 60,
                            height: 50,
                            child: Container(
                              width: getPhoneWidth(context) - 60,
                              height: 50,
                              padding: EdgeInsets.only(left: 15, right: 5),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: AppColors.tertiary,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: TextFormField(
                                controller: _dateController,
                                readOnly: true,
                                style: GoogleFonts.urbanist(
                                  fontSize: 15,
                                  color: AppColors.tertiary,
                                  fontWeight: AppFontWeight.medium
                                ),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.calendar_today, color: AppColors.tertiary),
                                    onPressed: () => _selectDate(context),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide.none
                                  ),
                                ),
                                onTap: () => _selectDate(context),
                              ),
                            )
                          )
                        ),
                      ),

                      SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            'Country',
                            style: GoogleFonts.urbanist(
                              color: AppColors.secondary,
                              fontSize: 18,
                              fontWeight: AppFontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 5),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: AppColors.secondary.withOpacity(0.3),
                          splashColor: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              countryListTheme: CountryListThemeData(
                                backgroundColor: AppColors.background,
                                textStyle: GoogleFonts.urbanist(
                                  color: AppColors.secondary,
                                  fontSize: 15,
                                  fontWeight: AppFontWeight.medium,
                                ),
                                bottomSheetHeight: getPhoneHeight(context)/2,
                                borderRadius: BorderRadius.circular(15),
                                searchTextStyle: GoogleFonts.urbanist(
                                  color: AppColors.secondary,
                                  fontSize: 15,
                                  fontWeight: AppFontWeight.medium,
                                ),
                                inputDecoration: InputDecoration(
                                  hintText: "Search country...",
                                  hintStyle: GoogleFonts.urbanist(
                                    color: AppColors.tertiary,
                                    fontSize: 15,
                                    fontWeight: AppFontWeight.medium,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: AppColors.tertiary),
                                  ),
                                ),
                              ),
                              onSelect: (Country country) {
                                setState(() {
                                  selectedCountry = country;
                                });
                              },
                            );
                          },
                          child: SizedBox(
                            width: getPhoneWidth(context) - 60,
                            height: 50,
                            child: Container(
                              width: getPhoneWidth(context) - 60,
                              height: 50,
                              padding: EdgeInsets.only(left: 15, right: 15),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: AppColors.tertiary,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Row(
                                children: [
                                  if (selectedCountry != null) ...[
                                    Text(
                                      selectedCountry!.flagEmoji,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      selectedCountry!.name,
                                      style: GoogleFonts.urbanist(
                                        color: AppColors.tertiary,
                                        fontSize: 15,
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      "Select Country",
                                      style: GoogleFonts.urbanist(
                                        color: AppColors.tertiary,
                                        fontSize: 15,
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                    ),
                                  Spacer(),
                                  Icon(Icons.arrow_drop_down, color: AppColors.tertiary),
                                ],
                              ),
                            )
                          )
                        ),
                      ),

                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _information(String title, String input) {
    double phoneWidth = getPhoneWidth(context);

    return Column(
      children: [
        SizedBox(height: 20),

        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              title,
              style: GoogleFonts.urbanist(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: AppFontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),

        SizedBox(height: 5),

        Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: AppColors.secondary.withOpacity(0.3),
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              print("${user['name']} tapped");
            },
            child: Container(
              width: phoneWidth - 60,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: AppColors.tertiary,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  input,
                  style: GoogleFonts.urbanist(
                    color: AppColors.tertiary,
                    fontSize: input == '••••••••••••' ? 24 : 15,
                    fontWeight: AppFontWeight.medium,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}