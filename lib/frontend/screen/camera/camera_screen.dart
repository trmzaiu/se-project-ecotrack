import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camerawesome/src/widgets/camera_awesome_builder.dart';
import 'package:camerawesome/src/widgets/utils/awesome_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wastesortapp/frontend/screen/camera/scan_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String? _latestImagePath;

  Future<void> _requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }

    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      if (await imageFile.exists()) {
        if (!mounted) return;
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
      } else {
        print("❌");
      }
    }
  }

  Future<void> _getLatestImage() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (!permitted.hasAccess) return;

    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
      onlyAll: true,
    );

    if (albums.isNotEmpty) {
      final recentAssets = await albums[0].getAssetListRange(start: 0, end: 1);

      if (recentAssets.isNotEmpty) {
        final file = await recentAssets.first.file;
        if (file != null) {
          setState(() {
            _latestImagePath = file.path;
          });
        }
      }
    }
  }

  Future<AnalysisImage> processImage(AnalysisImage analysisImage) async {
    // Add your image processing logic here
    // For now, returning the original image without processing
    return analysisImage;
  }

  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermissions();
      _getLatestImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.awesome(
      enablePhysicalButton: true,
      previewFit: CameraPreviewFit.fitWidth,
      sensorConfig: SensorConfig.single(
        aspectRatio: CameraAspectRatios.ratio_16_9,
      ),
      saveConfig: SaveConfig.photoAndVideo(
        initialCaptureMode: CaptureMode.photo,
        photoPathBuilder: (sensors) async {
          final Directory extDir = await getTemporaryDirectory();
          final String filePath =
              '${extDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

          await Directory('${extDir.path}').create(recursive: true);

          print("📸 Image will be saved to: $filePath");

          return SingleCaptureRequest(filePath, sensors.first);;
        },
      ),
        onMediaCaptureEvent: (event) {
          if (event.status == MediaCaptureStatus.success && event.isPicture) {
            event.captureRequest.when(
              single: (single) async {
                if (!mounted) return;
                Navigator.of(context).push(_createSlideRoute(ScanScreen(imagePath: single.file?.path ?? "")));
              },
            );
          }
        },
        onImageForAnalysis: (analysisImage) {
        return processImage(analysisImage);
      },
      onMediaTap: (mediaCapture) {
        mediaCapture.captureRequest.when(
          single: (single) {
            debugPrint('single: ${single.file?.path}');
          },
        );
      },
      imageAnalysisConfig: AnalysisConfig(
        androidOptions: const AndroidAnalysisOptions.nv21(
          width: 1024,
        ),
        autoStart: true,
      ),
      theme: AwesomeTheme(
        bottomActionsBackgroundColor: Colors.transparent,
        buttonTheme: AwesomeButtonTheme(
          backgroundColor: Color(0x4D333333),
          iconSize: 24,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(11),
          buttonBuilder: (child, onTap) => ClipOval(
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
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
        padding: const EdgeInsets.only(top: 20, right: 20),
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
                color: Color(0x4D333333),
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
      middleContentBuilder: (state) => Column(
        children: [
          const Spacer(),
          Builder(builder: (context) {
            return Container(
              color: AwesomeThemeProvider.of(context)
                  .theme
                  .bottomActionsBackgroundColor,
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            );
          }),
        ],
      ),
      bottomActionsBuilder: (state) => Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 46,
                height: 46,
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
            SizedBox(width: 70),
            AwesomeCaptureButton(state: state),
            SizedBox(width: 70),
            AwesomeFlashButton(state: state),
          ],
        ),
      ),
    );
  }
}