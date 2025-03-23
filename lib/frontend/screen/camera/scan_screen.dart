import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';

import '../../../ScanAI/processImage.dart';
import '../../../theme/colors.dart';
import '../../../theme/fonts.dart';
import '../../utils/route_transition.dart';
import '../../widget/scan_animation.dart';
import '../evidence/upload_evidence_screen.dart';

class ScanScreen extends StatefulWidget {
  final String imagePath;

  ScanScreen({required this.imagePath});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool _isScanning = false;
  String? _scanResult;
  bool _scanCompleted = false;
  Future<File>? _imageFuture;
  late double imageTop;
  late double imageHeight;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _imageFuture = _loadImage().then((file) {
      _getImageSize(file);
      return file;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _scanImage() async {
    setState(() {
      _isScanning = true;
      _scanResult = null;
      _scanCompleted = false;
    });

    controller.repeat(reverse: true);

    String? result = await ApiService.classifyImage(File(widget.imagePath));

    setState(() {
      _isScanning = false;
      _scanCompleted = true;
      _scanResult = result;
    });

    controller.stop();
  }

  Future<File> _loadImage() async {
    return File(widget.imagePath);
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.file(imageFile);

    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double imageHeight = info.image.height.toDouble();
        final double imageTop = (screenHeight - imageHeight) / 2;

        setState(() {
          this.imageHeight = imageHeight;
          this.imageTop = imageTop;
        });

        completer.complete(Size(info.image.width.toDouble(), imageHeight));
      }),
    );

    await completer.future;
  }

  // void _handleTap() {
  //   final validCategories = {"Recyclable", "Organic", "Hazardous", "General"};
  //
  //   if (validCategories.contains(_scanResult)) {
  //     Navigator.of(context).push(moveLeftRoute(UploadScreen(
  //       imagePath: widget.imagePath,
  //       category: _scanResult!,
  //     )));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    bool isValidCategory = ["Recyclable", "Organic", "Hazardous", "General"].contains(_scanResult);

    double statusHeight = getStatusHeight(context);
    double phoneWidth = getPhoneWidth(context);
    double phoneHeight = getPhoneHeight(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<File>(
            future: _imageFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: AppColors.primary),);
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading image"));
              } else {
                return Align(
                  alignment: Alignment.center,
                  child: Image.file(snapshot.data!),
                );
              }
            }
          ),

          if (_isScanning) ...[
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Scanning...",
                    style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: AppFontWeight.regular,
                      color: AppColors.surface,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        backgroundColor: Color(0xFFDEF3E7),
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.board2),
                        color: AppColors.board2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ScanAnimation(),
          ],

          if (_scanCompleted && _scanResult != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: [
                  Container(
                    width: 280,
                    height: 82,
                    margin: EdgeInsets.only(bottom: 102),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.5),
                          blurRadius: 40,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 17),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            _scanResult == "Recyclable"
                              ? 'lib/assets/images/recycle.png'
                              : _scanResult == "Organic"
                              ? 'lib/assets/images/organic.png'
                              :_scanResult == "Hazardous"
                              ? 'lib/assets/images/hazard.png'
                              :_scanResult == "General"
                              ? 'lib/assets/images/general.png'
                              : 'lib/assets/images/caution.png',
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "CATEGORY",
                              style: GoogleFonts.urbanist(
                                fontSize: 12,
                                fontWeight: AppFontWeight.regular,
                                color: AppColors.tertiary,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _scanResult!,
                              style: GoogleFonts.urbanist(
                                fontSize: 18,
                                fontWeight: AppFontWeight.medium,
                                color: AppColors.secondary,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    right: 17,
                    top: 19,
                    child: GestureDetector(
                      onTap: isValidCategory
                        ? () => Navigator.of(context).pushAndRemoveUntil(
                            moveLeftRoute(
                              UploadScreen(imagePath: widget.imagePath, category: _scanResult!),
                              settings: RouteSettings(name: "UploadScreen"),
                            ),
                              (route) => route.settings.name != "ScanScreen" || route.isFirst,
                          )
                        : null,
                      child: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: isValidCategory ? AppColors.primary : AppColors.board2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'lib/assets/icons/ic_arrow_right.svg',
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (!_isScanning && !_scanCompleted)
            Padding(
              padding: EdgeInsets.only(bottom: (phoneHeight - (phoneWidth*(16/9)) - (statusHeight + 2.5) - 80)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _isScanning ? null : _scanImage,
                      child: Container(
                        width: phoneWidth - 60,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Scan",
                            style: GoogleFonts.urbanist(
                              fontSize: 24,
                              fontWeight: AppFontWeight.semiBold,
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          moveUpRoute(
                            UploadScreen(imagePath: widget.imagePath),
                            settings: RouteSettings(name: "UploadScreen"),
                          )
                        );
                      },
                      child: Text(
                        "Upload Evidence",
                        style: GoogleFonts.urbanist(
                          fontSize: 20,
                          fontWeight: AppFontWeight.semiBold,
                          color: AppColors.surface,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 30,
                              color: Colors.white.withOpacity(0.3),
                            ),
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (!_isScanning)
            Positioned(
              top: statusHeight + 20,
              right: 15,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    // shape: BoxShape.circle,
                    // color: Color(0x80494848),
                    boxShadow: [BoxShadow(
                      color: Color(0x80494848),
                      offset: Offset(0,0),
                      blurRadius: 35,
                      spreadRadius: 1
                    )]
                  ),
                  child: SvgPicture.asset(
                    'lib/assets/icons/ic_close.svg',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
