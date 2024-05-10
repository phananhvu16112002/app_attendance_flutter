import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';

class SmartCameraUploadImage extends StatefulWidget {
  const SmartCameraUploadImage({
    super.key,
  });

  @override
  State<SmartCameraUploadImage> createState() => _SmartCameraUploadImageState();
}

class _SmartCameraUploadImageState extends State<SmartCameraUploadImage> {
  late File _imageTest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openCamera();
  }

  Future<void> openCamera() async {
    await FaceCamera.initialize();
    print('ákdasjdlasjdlkasjdskas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
      ),
      body: SmartFaceCamera(
        performanceMode: FaceDetectorMode.accurate,
        imageResolution: ImageResolution.veryHigh,
        showCaptureControl: true,
        showControls: true,
        onCapture: (File? image) async {
          if (image != null) {
            setState(() {
              _imageTest = image;
            });
          }
        },
        onFaceDetected: (face) {},
        messageBuilder: (context, face) {
          if (face == null) {
            return _message('Place your face in the camera');
          }
          if (!face.wellPositioned) {
            return _message('Center your face in the square');
          }
          print('alo alo');
          return const SizedBox.shrink();
        },
        showFlashControl: false,
        showCameraLensControl: false,
        autoCapture: true,
        defaultCameraLens: CameraLens.front,
        captureControlIcon: CircleAvatar(
          backgroundColor: const Color(0xff96f0ff).withOpacity(0.5),
          radius: 50,
          child: const Icon(Icons.camera_enhance_outlined,
              size: 30, color: Colors.black),
        ),
        lensControlIcon: const CircleAvatar(
          backgroundColor: Color(0xff96f0ff),
          radius: 35,
          child: Icon(
            Icons.crop_rotate_outlined,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget _message(String msg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
        child: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
      );
}
