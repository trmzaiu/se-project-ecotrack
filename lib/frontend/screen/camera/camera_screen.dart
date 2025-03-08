import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/src/widgets/camera_awesome_builder.dart';
import 'package:camerawesome/src/widgets/utils/awesome_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wastesortapp/frontend/screen/camera/preview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CameraAwesomeBuilder.awesome(
      saveConfig: SaveConfig.photo(),
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
                    image: AssetImage("lib/assets/images/default.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 70),
            // AwesomeCaptureButton(state: state),
            AwesomeCaptureButton(state: state),
            SizedBox(width: 70),
            AwesomeFlashButton(state: state),
          ],
        ),
      ),
    );
  }
}