import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:wastesortapp/frontend/screen/home/preview_screen.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  List<CameraDescription> cameras = [];
  bool isCameraReady = false;
  File? _selectedImage;
  bool _isFlashOn = false;
  String _result = "Select an image to classify";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    CameraDescription backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back);

    _controller = CameraController(
      backCamera,
      ResolutionPreset.max,
    );
    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final image = await _controller!.takePicture();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      print("Error taking picture: $e");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      await _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    } catch (e) {
      print("Error toggling flash: $e");
    }
  }

  Future<void> _handleTap(TapDownDetails details) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final size = MediaQuery.of(context).size;
      final x = details.localPosition.dx / size.width;
      final y = details.localPosition.dy / size.height;

      await _controller!.setFocusPoint(Offset(x, y));
      await _controller!.setFocusMode(FocusMode.auto);

      setState(() {});
    } catch (e) {
      print("Error focusing: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? Stack(
        children: [
          GestureDetector(
            onTapDown: _handleTap,
            child: Positioned.fill(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
            ),
          ),

          Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          image: DecorationImage(
                            image: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : AssetImage("lib/assets/images/default.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 100),
                    GestureDetector(
                      onTap: _takePicture,
                      child: SvgPicture.asset(
                        'lib/assets/icons/ic_take_photo.svg',
                        height: 80,
                      ),
                    ),
                    SizedBox(width: 100),
                    GestureDetector(
                      onTap: _toggleFlash,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF494848).withOpacity(0.5),
                        ),
                        child: SvgPicture.asset(
                          _isFlashOn
                              ? 'lib/assets/icons/ic_flash_on.svg'
                              : 'lib/assets/icons/ic_flash_off.svg',
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF494848).withOpacity(0.4),
                ),
                child: SvgPicture.asset(
                  'lib/assets/icons/ic_close.svg',
                  height: 40,
                ),
              ),
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
