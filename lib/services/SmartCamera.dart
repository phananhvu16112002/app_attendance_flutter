import 'dart:io';

import 'package:attendance_system_nodejs/models/AttendanceForm.dart';
import 'package:attendance_system_nodejs/models/ClassesStudent.dart';
import 'package:attendance_system_nodejs/screens/Home/AttendanceFormPage.dart';
import 'package:attendance_system_nodejs/screens/Home/AttendanceFormPageOffline.dart';
import 'package:attendance_system_nodejs/screens/Home/AttendanceFormPageQR.dart';
import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SmartCamera extends StatefulWidget {
  const SmartCamera(
      {super.key, required this.page, required this.classesStudent});

  final String page;
  final ClassesStudent classesStudent;

  @override
  State<SmartCamera> createState() => _SmartCameraState();
}

class _SmartCameraState extends State<SmartCamera> {
  late File _imageTest;
  late Box<AttendanceForm> boxAttendanceForm;
  late ClassesStudent classStudents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    openCamera();
    boxAttendanceForm = Hive.box<AttendanceForm>('AttendanceFormBoxes');
    classStudents = widget.classesStudent!;
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
        imageResolution: ImageResolution.veryHigh,
        showCaptureControl: true,
        showControls: true,
        onCapture: (File? image) async {
          if (image != null) {
            setState(() {
              _imageTest = image;
            });
            await SecureStorage().writeSecureData('image', _imageTest.path);
            await SecureStorage()
                .writeSecureData('imageOffline', _imageTest.path);

            if (mounted) {
              if (widget.page.contains('AttendanceNormal')) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => AttendanceFormPage(
                              classesStudent: classStudents,
                            )),
                    (route) => false);
              } else if (widget.page.contains('AttendanceQR')) {
                AttendanceForm? attendanceForm =
                    boxAttendanceForm.get('AttendanceQR');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => AttendanceFormPageQR(
                            attendanceForm: attendanceForm!)),
                    (route) => false);
              } else {
                AttendanceForm? attendanceForm =
                    boxAttendanceForm.get('AttendanceOffline');
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => AttendanceFormPageOffline(
                            attendanceForm: attendanceForm!)),
                    (route) => false);
              }
            }
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
