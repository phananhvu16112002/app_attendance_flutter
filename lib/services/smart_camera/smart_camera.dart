import 'dart:io';

import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/screens/Home/attendanceform_page/attendance_form_page.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_offline/attendance_form_page_offline.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_QR/attendance_form_page_qr.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:face_camera/face_camera.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:firebase_ml_vision/firebase_ml_vision.dart'
//     as firebase_ml_vision;

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
    requestCameraPermission();
    boxAttendanceForm = Hive.box<AttendanceForm>('AttendanceFormBoxes');
    classStudents = widget.classesStudent;
  }

  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;
    if (!status.isGranted) {
      PermissionStatus newStatus = await Permission.camera.request();
      if (newStatus == PermissionStatus.denied ||
          newStatus == PermissionStatus.permanentlyDenied) {
        await requestCameraPermission();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // Future<bool> checkLiveFace(File imageFile) async {
  //   final firebase_ml_vision.FirebaseVisionImage visionImage =
  //       firebase_ml_vision.FirebaseVisionImage.fromFile(imageFile);
  //   final firebase_ml_vision.FaceDetector faceDetector =
  //       firebase_ml_vision.FirebaseVision.instance.faceDetector();
  //   final List<firebase_ml_vision.Face> faces =
  //       await faceDetector.processImage(visionImage);

  //   for (final firebase_ml_vision.Face face in faces) {
  //     final eyeOpenProbability =
  //         (face.leftEyeOpenProbability ?? 0.0).toDouble() +
  //             (face.rightEyeOpenProbability ?? 0.0).toDouble();

  //     if (eyeOpenProbability < 0.3) {
  //       return true;
  //     }

  //     final topLeft = face.boundingBox!.topLeft;
  //     final bottomRight = face.boundingBox!.bottomRight;
  //     final faceSize =
  //         (bottomRight.dx - topLeft.dx) * (bottomRight.dy - topLeft.dy);
  //     final minFaceSize = 100;
  //     if (faceSize > minFaceSize) {
  //       return true;
  //     }
  //   }
  //   return false;
  // }

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
            bool isLiveFace = true;
            if (isLiveFace) {
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
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Warning'),
                      content: Text(
                          'The captured face is not live. Please try again.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  });
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
          return const SizedBox.shrink();
        },
        showFlashControl: false,
        showCameraLensControl: false,
        autoCapture: true,
        defaultCameraLens: CameraLens.front,
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
        padding: EdgeInsets.symmetric(horizontal: 55.w, vertical: 15.h),
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 12.sp, height: 1.5, fontWeight: FontWeight.w400),
        ),
      );
}
