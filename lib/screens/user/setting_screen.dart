import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:wastesortapp/services/user_service.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../../models/user.dart';
import '../../../theme/fonts.dart';
import '../../services/auth_service.dart';
import '../../utils/format_time.dart';
import '../../utils/phone_size.dart';
import '../../widgets/bar_title.dart';
import '../../widgets/input_dialog.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController dateController = TextEditingController();

  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  ValueNotifier<Country?> selectedCountryNotifier = ValueNotifier<Country?>(null);

  Map<String, dynamic>? user;
  bool _isDialogOpen = false;
  bool isDataInitialized = false;
  DateTime? selectedDOB;
  File? selectedImage;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: AppFontWeight.semiBold,
              color: AppColors.surface,
            ),
          ),
        ),
        backgroundColor: AppColors.board2,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _updatePassword(String newPassword, String confirmPassword) async {
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('All fields are required');
      return;
    }

    if (newPassword != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    try {
      await AuthenticationService().updateUserPassword(newPassword);
      _showSnackBar('Password updated successfully');
    } catch (e) {
      print('Failed to update password: $e');
      _showSnackBar('Failed to update password');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        _showImageCropper(imageFile);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
      _showSnackBar('Failed to pick image!');
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

  void _showImageCropper(File imageFile) async {
    final cropped = await cropImage(imageFile);

    if (cropped != null && await cropped.exists()) {
      setState(() {
        selectedImage = cropped;
      });

      _showSnackBar('Uploading avatar...');

      try {
        await UserService().updateUserProfile(userId, image: cropped);
        _showSnackBar('Avatar updated successfully');
      } catch (e) {
        _showSnackBar('Error: $e');
      }
    }
  }

  Future<File?> cropImage(File imageFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Avatar',
          toolbarColor: Colors.black,
          toolbarWidgetColor: AppColors.surface,
          statusBarColor: Colors.transparent,
          backgroundColor: Colors.black,
          activeControlsWidgetColor: AppColors.primary,
          cropStyle: CropStyle.circle,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          showCropGrid: true,
          hideBottomControls: false,
        )
      ],
    );

    return croppedFile != null ? File(croppedFile.path) : null;
  }

  Future<void> showDatePicker(BuildContext context) async {
    DateTime selectedDate = parseDate(dateController.text, type: 'euroStyle');
    DateTime focusedDate = selectedDate;
    int selectedYear = selectedDate.year;
    int selectedMonth = selectedDate.month;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext builder) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 440,
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 130,
                        height: 35,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            value: selectedMonth,
                            isExpanded: true,
                            customButton: Container(
                              padding: EdgeInsets.only(left: 15),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    getMonthName(selectedMonth),
                                    style: GoogleFonts.urbanist(
                                      fontSize: 18,
                                      fontWeight: AppFontWeight.medium,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down, color: AppColors.primary),
                                ],
                              )
                            ),
                            iconStyleData: IconStyleData(
                              icon: SizedBox.shrink(),
                            ),
                            dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.surface,
                                ),
                                elevation: 0,
                                maxHeight: 200,
                                scrollbarTheme: ScrollbarThemeData(
                                  thumbColor: MaterialStateProperty.all(AppColors.board2),
                                  thickness: MaterialStateProperty.all(2),
                                ),
                                isOverButton: true
                            ),
                            items: List.generate(12, (index) {
                              bool isDisabled = selectedYear == DateTime.now().year && (index + 1) > DateTime.now().month;
                              int monthValue = index + 1;
                              bool isSelected = monthValue == selectedMonth;
                              return DropdownMenuItem(
                                value: monthValue,
                                enabled: !isDisabled,
                                child: Text(
                                  getMonthName(index + 1),
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: AppFontWeight.medium,
                                    color: isDisabled ? AppColors.tertiary : isSelected ? AppColors.board2 : AppColors.primary,
                                  ),
                                ),
                              );
                            }),
                            menuItemStyleData: MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                            ),
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
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 80,
                        height: 35,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            value: selectedYear,
                            isExpanded: true,
                            customButton: Container(
                              padding: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                              ),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      selectedYear.toString(),
                                      style: GoogleFonts.urbanist(
                                        fontSize: 16,
                                        fontWeight: AppFontWeight.medium,
                                        color: AppColors.primary,
                                      )
                                    ),
                                    Icon(Icons.arrow_drop_down, color: AppColors.primary),
                                  ],
                                ),
                              )
                            ),
                            iconStyleData: IconStyleData(
                              icon: SizedBox.shrink(),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surface,
                              ),
                              elevation: 0,
                              maxHeight: 200,
                              scrollbarTheme: ScrollbarThemeData(
                                thumbColor: MaterialStateProperty.all(AppColors.board2),
                                thickness: MaterialStateProperty.all(2),
                              ),
                              isOverButton: true
                            ),
                            menuItemStyleData: MenuItemStyleData(
                              height: 30,
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            ),
                            items: List.generate(DateTime.now().year - 1900 + 1, (index) => DateTime.now().year - index)
                                .map((year) {
                              bool isSelected = year == selectedYear;
                              return DropdownMenuItem(
                                alignment: Alignment.center,
                                value: year,
                                child: Text(
                                  "$year",
                                  style: GoogleFonts.urbanist(
                                    fontSize: 16,
                                    fontWeight: AppFontWeight.medium,
                                    color: isSelected ? AppColors.board2 : AppColors.primary,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedYear = value!;
                                focusedDate = DateTime(selectedYear, selectedMonth, 1);
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
                          color: AppColors.secondary,
                        ),
                        weekendStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.medium,
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
                          color: AppColors.secondary,
                        ),
                        weekendTextStyle: GoogleFonts.urbanist(
                          fontSize: 16,
                          fontWeight: AppFontWeight.regular,
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
                      onDaySelected: (selectedDay, focusedDay) async {
                        setState(() {
                          selectedDOB = selectedDay;
                          dateController.text = formatDate(selectedDay, type: 'euroStyle');
                        });

                        await UserService().updateUserProfile(userId, dob: selectedDOB!);

                        _showSnackBar('Date of birth updated successfully!');
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
      onSelect: (Country country) async {
        selectedCountryNotifier.value = country;
        await UserService().updateUserProfile(userId, country: country.name);
        _showSnackBar('Country updated successfully!');
      },
    );
  }

  void _showDialogName(BuildContext context, String hintText) {
    final TextEditingController controller = TextEditingController(text: hintText);

    _isDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            _isDialogOpen = false;
            return true;
          },
          child: InputDialog(
            information: 'name',
            controller: controller,
            hintText: hintText,
            onPressed: () async {
              final newValue = controller.text.trim();

              if (newValue.isNotEmpty && newValue != hintText) {
                try {
                  await UserService().updateUserProfile(userId, name: newValue);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          'Failed to update name',
                          style: GoogleFonts.urbanist(
                            fontSize: 16,
                            fontWeight: AppFontWeight.semiBold,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                      backgroundColor: AppColors.board2,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              }
              _isDialogOpen = false;
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  void _showDialogPassword(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    passwordController.clear();
    confirmPasswordController.clear();

    showDialog(
      context: context,
      builder: (context) => InputDialog(
        information: 'password',
        controller: passwordController,
        hintText: 'Enter new password',
        isPass: true,
        controllerPass: confirmPasswordController,
        onPressed: () async {
          final newPassword = passwordController.text.trim();
          final confirmPassword = confirmPasswordController.text.trim();

          _updatePassword(newPassword, confirmPassword);
          Navigator.pop(context);
        },
      ),
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

                      StreamBuilder<Usr?>(
                        stream: UserService().getCurrentUser(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting && !_isDialogOpen) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final user = snapshot.data!;

                          if (user.dob != null && user.dob.toString().isNotEmpty) {
                            try {
                              selectedDOB = user.dob;
                            } catch (e) {
                              print('❌ Error parsing DOB: $e');
                              selectedDOB = DateTime.now();
                            }
                          } else {
                            selectedDOB = DateTime.now();
                          }

                          dateController.text = formatDate(selectedDOB!, type: 'euroStyle');
                          if (user.country.isNotEmpty) {
                            selectedCountryNotifier.value = Country.tryParse(user.country);
                          }
                          isDataInitialized = true;

                          return Column(
                            children: [
                              _avatarTile(user.photoUrl),
                              _informationTile('Name', user.name, () {
                                _showDialogName(context, user.name);
                              }),
                              _informationTile('Email', user.email, () {}),
                              _informationTile('Password', '••••••••••••', () {
                                _showDialogPassword(context);
                              }),
                              _dobTile(),
                              _countryTile(),
                              SizedBox(height: 20),
                            ],
                          );
                        },
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

  Widget _avatarTile(String photoUrl) {
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
                  child: photoUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: photoUrl,
                    width: 170,
                    height: 170,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset('lib/assets/images/avatar_default.png'),
                  )
                      : Image.asset(
                    'lib/assets/images/avatar_default.png',
                    width: 170,
                    height: 170,
                    fit: BoxFit.cover,
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

  Widget _informationTile(String title, String input, VoidCallback onTap) {
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
            highlightColor: onTap != null ? AppColors.secondary.withOpacity(0.3) : Colors.transparent,
            splashColor: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
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
                  controller: dateController,
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
    return ValueListenableBuilder<Country?>(
      valueListenable: selectedCountryNotifier,
      builder: (context, selectedCountry, _) {
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
                    child: Row(
                      children: [
                        if (selectedCountry != null) ...[
                          Text(
                            selectedCountry.flagEmoji,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(width: 10),
                          Text(
                            selectedCountry.name,
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
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}