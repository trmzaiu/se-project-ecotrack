import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../../theme/fonts.dart';
import '../../utils/phone_size.dart';
import '../../widget/bar_title.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _dateController = TextEditingController();
  Country? selectedCountry;
  List<File> selectedImages = [];

  @override
  void initState() {
    super.initState();
    _dateController.text = user['dob'];
    selectedCountry = Country.tryParse(user['country']);
  }

  final Map<String, dynamic> user = {
    'photoUrl': 'lib/assets/images/user_image.png',
    'name': 'Gwen Stacy',
    'email': 'gwenstacy@example.com',
    'dob': '20/03/2025',
    'country': 'Vietnam',
  };

  Future<void> _pickImage(source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image!')),
      );
    }
  }

  void showImageSelection() {
    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text('Take a new photo', style: GoogleFonts.urbanist(color: AppColors.tertiary, fontWeight: AppFontWeight.regular)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Choose from your device', style: GoogleFonts.urbanist(color: AppColors.tertiary, fontWeight: AppFontWeight.regular)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showDatePicker(BuildContext context) async {
    DateTime selectedDate = DateFormat("dd/MM/yyyy").parse(_dateController.text);
    DateTime focusedDate = selectedDate;
    int selectedYear = selectedDate.year;
    int selectedMonth = selectedDate.month;
    bool isDropdownMonthOpened = false;
    bool isDropdownYearOpened = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 440,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 135,
                        height: 35,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            value: selectedMonth,
                            isExpanded: true,
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: isDropdownMonthOpened
                                    ? BorderRadius.vertical(top: Radius.circular(10))
                                    : BorderRadius.circular(10),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                color: AppColors.surface,
                              ),
                              elevation: 0,
                              maxHeight: 200,
                            ),
                            items: List.generate(12, (index) {
                              bool isDisabled = selectedYear == DateTime.now().year && (index + 1) > DateTime.now().month;
                              int monthValue = index + 1;
                              return DropdownMenuItem(
                                value: monthValue,
                                enabled: !isDisabled,
                                child: Text(
                                  DateFormat.MMMM().format(DateTime(0, index + 1)),
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: AppFontWeight.medium,
                                    color: isDisabled ? AppColors.tertiary : AppColors.primary,
                                  ),
                                ),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                if (value != null) {
                                  setState(() {
                                    selectedMonth = value;
                                  });
                                }

                                if (selectedYear == DateTime.now().year && selectedMonth > DateTime.now().month) {
                                  selectedMonth = DateTime.now().month;
                                }

                                focusedDate = DateTime(selectedYear, selectedMonth, 1);
                              });
                            },

                            onMenuStateChange: (isOpen) {
                              setState(() {
                                isDropdownMonthOpened = isOpen;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(width: 20),

                      SizedBox(
                        width: 100,
                        height: 35,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            value: selectedYear,
                            isExpanded: true,
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: isDropdownYearOpened
                                    ? BorderRadius.vertical(top: Radius.circular(10))
                                    : BorderRadius.circular(10),
                              ),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                                color: AppColors.surface,
                              ),
                              elevation: 0,
                              maxHeight: 200,
                            ),
                            items: List.generate(DateTime.now().year - 1900 + 1, (index) => DateTime.now().year - index)
                                .map((year) => DropdownMenuItem(
                              value: year,
                              child: Text(
                                "$year",
                                style: GoogleFonts.urbanist(
                                  fontSize: 16,
                                  fontWeight: AppFontWeight.medium,
                                  color: AppColors.primary,
                                )
                              ),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedYear = value!;
                                focusedDate = DateTime(selectedYear, selectedMonth, 1);
                              });
                            },
                            onMenuStateChange: (isOpen) {
                              setState(() {
                                isDropdownYearOpened = isOpen;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: TableCalendar(
                      firstDay: DateTime(1900),
                      lastDay: DateTime.now(),
                      focusedDay: focusedDate,
                      calendarFormat: CalendarFormat.month,
                      headerVisible: false,
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.board1,
                        ),
                        weekendStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.secondary,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        cellPadding: EdgeInsets.all(0),
                        todayDecoration: BoxDecoration(
                          color: AppColors.board2.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.surface,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.surface,
                        ),
                        defaultTextStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.board1,
                        ),
                        weekendTextStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.medium,
                          color: AppColors.secondary,
                        ),
                        disabledTextStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.accent,
                        ),
                        outsideTextStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.regular,
                          color: AppColors.tertiary,
                        ),
                      ),
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        _dateController.text = DateFormat("dd/MM/yyyy").format(selectedDay);
                        Navigator.pop(context);
                      },
                      onPageChanged: (focusedDay) {
                        setState(() {
                          focusedDate = focusedDay;
                          selectedYear = focusedDay.year;
                          selectedMonth = focusedDay.month;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showCountryPickerDialog(BuildContext context) {
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
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SizedBox(height: 30),

                      _avatarTile(),

                      _informationTile('Name', user['name']),
                      _informationTile('Email', user['email']),
                      _informationTile('Password', '••••••••••••'),

                      _dobTile(),

                      _countryTile(),

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

  Widget _avatarTile() {
    return Column(
      children: [
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
                    onPressed: () => showImageSelection(),
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
      ],
    );
  }

  Widget _informationTile(String title, String input) {
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

  Widget _dobTile() {
    return Column(
      children: [
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
                          onPressed: () => showDatePicker(context),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide.none
                        ),
                      ),
                      onTap: () => showDatePicker(context),
                    ),
                  )
              )
          ),
        ),
      ],
    );
  }

  Widget _countryTile() {
    return Column(
      children: [
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
              onTap: () => showCountryPickerDialog(context),
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
      ],
    );
  }
}