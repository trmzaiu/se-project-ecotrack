import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wastesortapp/frontend/screen/camera/scan_screen.dart';
import 'package:wastesortapp/frontend/utils/phone_size.dart';
import 'package:wastesortapp/theme/colors.dart';

import '../../../theme/fonts.dart';
import '../../utils/route_transition.dart';
import '../../widget/fading_text.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver{
  String? _latestImagePath;
  bool _isPermissionGranted = false;
  bool _hasRequested = false;
  bool _isInitializing = true;
  bool showCamera = true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isPermissionGranted && mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _initialize() async {
    try {
      await _checkPermission();

      if (_isPermissionGranted) {
        await _getLatestImage();
      }

      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      debugPrint('Error during initialization: $e');
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  Future<void> _checkPermission() async {
    try {
      final status = await Permission.camera.status;
      if (status.isGranted) {
        if (mounted) {
          setState(() {
            _isPermissionGranted = true;
          });
        }
      } else if (!_hasRequested) {
        await _requestPermission();
        _hasRequested = true;
      } else {
        if (mounted) {
          setState(() {
          });
        }
      }
    } catch (e) {
      debugPrint('Error checking permission: $e');
      if (mounted) {
        setState(() {
        });
      }
    }
  }

  Future<void> _requestPermission() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted && mounted) {
        setState(() {
          _isPermissionGranted = true;
        });
      } else if (mounted) {
        setState(() {
        });
      }
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      if (mounted) {
        setState(() {
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      if (await imageFile.exists()) {
        if (!mounted) return;

        setState(() {
          showCamera = false;
        });

        Navigator.of(context).push(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              ScanScreen(imagePath: pickedFile.path),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.easeOut;

            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ));

        setState(() {
          showCamera = true;
        });
      } else {
        debugPrint("❌");
      }
    }
  }

  Future<void> _getLatestImage() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (!permitted.isAuth) return;

    final albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        orders: [
          const OrderOption(type: OrderOptionType.createDate, asc: false),
        ],
      ),
    );

    if (albums.isNotEmpty) {
      final recentAssets = await albums[0].getAssetListPaged(page: 0, size: 1);
      if (recentAssets.isNotEmpty) {
        final file = await recentAssets[0].file;
        if (mounted) {
          setState(() {
            _latestImagePath = file?.path;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = getPhoneWidth(context);
    double phoneHeight = getPhoneHeight(context);
    double statusHeight = getStatusHeight(context);

    if (_isInitializing) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 20),
                Text(
                  "Initializing camera...",
                  style: GoogleFonts.urbanist(
                      fontSize: 16,
                      fontWeight: AppFontWeight.regular,
                      color: AppColors.surface
                  ),
                )
              ],
            )
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: showCamera
      ? _isPermissionGranted
        ? CameraAwesomeBuilder.awesome(
          progressIndicator: Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          previewFit: CameraPreviewFit.fitWidth,
          previewAlignment: Alignment(0, - 0.55),
          sensorConfig: SensorConfig.single(
            aspectRatio: CameraAspectRatios.ratio_16_9,
            sensor: Sensor.position(SensorPosition.back),
            zoom: 0.0
          ),
          saveConfig: SaveConfig.photoAndVideo(
            initialCaptureMode: CaptureMode.photo,
            photoPathBuilder: (sensors) async {
              final Directory extDir = await getTemporaryDirectory();
              final String filePath =
                  '${extDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

              await Directory(extDir.path).create(recursive: true);

              debugPrint("📸 Image will be saved to: $filePath");

              return SingleCaptureRequest(filePath, sensors.first);
            },
          ),
          // onMediaCaptureEvent: (event) {
          //   if (event.status == MediaCaptureStatus.success && event.isPicture) {
          //     event.captureRequest.when(
          //       single: (single) {
          //         if (!mounted) return;
          //         WidgetsBinding.instance.addPostFrameCallback((_) {
          //           Navigator.of(context).push(
          //             moveLeftRoute(
          //               ScanScreen(imagePath: single.file?.path ?? ""),
          //               settings: RouteSettings(name: "ScanScreen"),
          //             ),
          //           );
          //         });
          //       },
          //     );
          //   }
          // },
          onMediaCaptureEvent: (event) {
            if (event.status == MediaCaptureStatus.success && event.isPicture) {
              event.captureRequest.when(
                single: (single) async {
                  if (!mounted) return;

                  setState(() {
                    showCamera = false;
                  });

                  Navigator.of(context).push(
                    moveLeftRoute(
                      ScanScreen(imagePath: single.file?.path ?? ""),
                      settings: const RouteSettings(name: "ScanScreen"),
                    ),
                  );

                  setState(() {
                    showCamera = true;
                  });
                },
              );
            }
          },
          theme: AwesomeTheme(
            bottomActionsBackgroundColor: Colors.transparent,
            buttonTheme: AwesomeButtonTheme(
              backgroundColor: Color(0x80494848),
              iconSize: 24,
              padding: EdgeInsets.all(11),
              buttonBuilder: (child, onTap) => ClipOval(
                child: Material(
                  color: Colors.transparent,
                  shape: CircleBorder(),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: onTap,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
          topActionsBuilder: (state) => Padding(
            padding: EdgeInsets.only(top: 20, right: 15),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x80494848),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'lib/assets/icons/ic_close.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
            ),
          ),
          middleContentBuilder: (state) => Container(
            height: phoneHeight,
            padding: EdgeInsets.only(top: statusHeight + 2.5, bottom: (phoneHeight - (phoneWidth*(16/9)) - (statusHeight + 2.5))),
            child: Center(
              child: SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FadingText(),
                    // Top-left corner
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            top: BorderSide(color: AppColors.surface, width: 3),
                            left: BorderSide(color: AppColors.surface, width: 3),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 4,
                              offset: Offset(-3, -3),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Top-right corner
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.surface, width: 3),
                            right: BorderSide(color: AppColors.surface, width: 3),
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 4,
                              offset: Offset(3, -3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom-left corner
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.surface, width: 3),
                            left: BorderSide(color: AppColors.surface, width: 3),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 4,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom-right corner
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.surface, width: 3),
                            right: BorderSide(color: AppColors.surface, width: 3),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 4,
                              offset: Offset(-3, 3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomActionsBuilder: (state) => Padding(
            padding: EdgeInsets.only(bottom: (phoneHeight - (phoneWidth*(16/9)) - (statusHeight) - 80)/2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      image: DecorationImage(
                        image: _latestImagePath != null
                            ? FileImage(File(_latestImagePath!))
                            : AssetImage("lib/assets/images/default.png") as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 70),
                AwesomeCaptureButton(state: state),
                // SizedBox(width: 70),
                AwesomeFlashButton(state: state),
              ],
            ),
          ),
        )
      : Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Camera Access",
                style: GoogleFonts.urbanist(
                    fontSize: 28,
                    fontWeight: AppFontWeight.bold,
                    color: AppColors.surface
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Please grant camera access \nto capture photos.",
                style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: AppFontWeight.regular,
                    color: AppColors.tertiary,
                    height: 1.2
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: _requestPermission,
                child: Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Grant Permission",
                    style: GoogleFonts.urbanist(
                        fontSize: 16,
                        fontWeight: AppFontWeight.regular,
                        color: AppColors.surface
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    : Container(color: Colors.black,)
    );
  }
}

