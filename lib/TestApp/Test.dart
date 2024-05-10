import 'dart:io';

import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_QR/attendance_form_page_qr.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_offline/attendance_form_page_offline.dart';
import 'package:attendance_system_nodejs/screens/Home/attendanceform_page/attendance_form_page.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class TestApp extends StatefulWidget {
  const TestApp({
    Key? key,
    this.page,
    this.classesStudent,
  }) : super(key: key);

  final String? page;
  final ClassesStudent? classesStudent;

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  late File _imageTest;
  late Box<AttendanceForm> boxAttendanceForm;
  late ClassesStudent classStudents;
  late bool isFaceAlive;
  late bool isSpoof; // New variable to track spoof status
  double previousEyeDistance = 0.0;
  double previousMouthToEyeDistance = 0.0;
  static const double MIN_FACE_WIDTH = 100;
  static const double MIN_FACE_HEIGHT = 100;
  static const double MAX_EYE_WIDTH_DIFFERENCE = 10.0;
  bool autoCapture = false;
  Face? detectedFace;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
    isFaceAlive = false;
    isSpoof = false; // Initialize isSpoof to false
    openCamera();
    boxAttendanceForm = Hive.box<AttendanceForm>('AttendanceFormBoxes');
    // classStudents = widget.classesStudent ?? Clas;
  }

  Future<void> openCamera() async {
    await FaceCamera.initialize();
    print('Camera initialized');
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
    super.dispose();
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
      body: Stack(
        children: [
          SmartFaceCamera(
            performanceMode: FaceDetectorMode.accurate,
            imageResolution: ImageResolution.veryHigh,
            showCaptureControl: false,
            showControls: true,
            onCapture: onCapture,
            onFaceDetected: onFaceDetected,
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
            autoCapture: autoCapture,
            defaultCameraLens: CameraLens.front,
            autoDisableCaptureControl: true,
          ),
          // Hiển thị trạng thái liveness
          Positioned(
            top: 20,
            left: 20,
            child: Text(
              isFaceAlive ? 'Face is alive' : 'Face is not alive or is spoofed',
              style: TextStyle(color: isFaceAlive ? Colors.green : Colors.red),
            ),
          ),
          if (detectedFace != null)
            CustomPaint(
              size: MediaQuery.of(context).size,
              painter: FacePainter(detectedFace, isSpoof),
            ),
        ],
      ),
    );
  }

  Future<void> onCapture(File? image) async {
    if (image != null) {
      if (isFaceAlive && !isSpoof) {
        print('Face is alive');
        // Thực hiện hành động khi khuôn mặt được chụp được xác định là thật
        // Ví dụ: Lưu trữ ảnh
        // await SecureStorage().writeSecureData('image', image.path);
        // await SecureStorage().writeSecureData('imageOffline', image.path);
        // // Điều hướng đến trang tương ứng
        // if (widget.page.contains('AttendanceNormal')) {
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (builder) => AttendanceFormPage(
        //         classesStudent: classStudents,
        //       ),
        //     ),
        //     (route) => false,
        //   );
        // } else if (widget.page.contains('AttendanceQR')) {
        //   AttendanceForm? attendanceForm = boxAttendanceForm.get('AttendanceQR');
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (builder) => AttendanceFormPageQR(
        //         attendanceForm: attendanceForm!,
        //       ),
        //     ),
        //     (route) => false,
        //   );
        // } else {
        //   AttendanceForm? attendanceForm = boxAttendanceForm.get('AttendanceOffline');
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (builder) => AttendanceFormPageOffline(
        //         attendanceForm: attendanceForm!,
        //       ),
        //     ),
        //     (route) => false,
        //   );
        // }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Alert'),
              content: Text('Face is not alive or is spoofed! Please try again.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void onFaceDetected(Face? face) {
    setState(() {
      detectedFace = face;
    });
    if (face != null) {
      setState(() {
        isFaceAlive = isLiveness(face);
        isSpoof = !isFaceAlive;
      });
    }
  }

  Widget _message(String msg) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 55.w, vertical: 15.h),
    child: Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12.sp,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  bool isLiveness(Face face) {
    // Your liveness detection logic here
    bool checkFace = isFaceStable(face);
    bool areEyesOpen = face.leftEyeOpenProbability! > 0.5 &&
        face.rightEyeOpenProbability! > 0.5;
    bool isSmiling = face.smilingProbability! > 0.5;

    // Kiểm tra tính sống và tính chân thực của khuôn mặt
    if (checkFace && areEyesOpen) {
      setState(() {
        autoCapture = true;
      });
      return true;
    } else if (isSmiling && areEyesOpen) {
      setState(() {
        autoCapture = true;
      });
      return true;
    } else {
      return false;
    }
  }

  bool isFaceStable(Face face) {
    double eyeDistance = _calculateDistance(
      Offset(
        face.landmarks[FaceLandmarkType.leftEye]!.position.x.toDouble(),
        face.landmarks[FaceLandmarkType.leftEye]!.position.y.toDouble(),
      ),
      Offset(
        face.landmarks[FaceLandmarkType.rightEye]!.position.x.toDouble(),
        face.landmarks[FaceLandmarkType.rightEye]!.position.y.toDouble(),
      ),
    );

    double mouthToEyeDistance = _calculateDistance(
      Offset(
        face.landmarks[FaceLandmarkType.leftEye]!.position.x.toDouble(),
        face.landmarks[FaceLandmarkType.leftEye]!.position.y.toDouble(),
      ),
      Offset(
        face.landmarks[FaceLandmarkType.bottomMouth]!.position.x.toDouble(),
        face.landmarks[FaceLandmarkType.bottomMouth]!.position.y.toDouble(),
      ),
    );

    double eyeDistanceChange = (eyeDistance - previousEyeDistance).abs();
    double mouthToEyeDistanceChange =
    (mouthToEyeDistance - previousMouthToEyeDistance).abs();
    previousEyeDistance = eyeDistance;
    previousMouthToEyeDistance = mouthToEyeDistance;
    double threshold = 100;

    if (eyeDistanceChange > threshold || mouthToEyeDistanceChange > threshold) {
      return false;
    } else {
      return true;
    }
  }

  double _calculateDistance(Offset a, Offset b) {
    return (a.dx - b.dx).abs() + (a.dy - b.dy).abs();
  }
}

class FacePainter extends CustomPainter {
  final Face? face;
  final bool isSpoof;

  FacePainter(this.face, this.isSpoof);

  @override
  void paint(Canvas canvas, Size size) {
    if (face != null) {
      // Vẽ bounding box cho khuôn mặt
      final Paint facePaint = Paint()
        ..color = isSpoof
            ? Colors.red
            : Colors.green // Đặt màu sắc cho khung viền mặt
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      // Chuyển đổi bounding box từ tọa độ tương đối sang tọa độ tuyệt đối
      final rect = Rect.fromLTWH(
        face!.boundingBox.left * size.width,
        face!.boundingBox.top * size.height,
        face!.boundingBox.width * size.width,
        face!.boundingBox.height * size.height,
      );

      canvas.drawRect(rect, facePaint);

      // Vẽ các landmark (điểm đặc trưng) trên khuôn mặt
      final Paint landmarkPaint = Paint()
        ..color = isSpoof ? Colors.red : Colors.green
        ..style = PaintingStyle.fill
        ..strokeWidth = 2.0;

      for (var landmark in face!.landmarks.values) {
        final position = landmark!.position!;
        canvas.drawCircle(
          Offset(position.x * size.width, position.y * size.height),
          2,
          landmarkPaint,
        );
      }

      // Vẽ các đường kết nối giữa các landmark
      final Paint connectionPaint = Paint()
        ..color = isSpoof ? Colors.red : Colors.green
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final List<List<FaceLandmarkType>> connections = [
        [FaceLandmarkType.leftEar, FaceLandmarkType.leftEye],
        [FaceLandmarkType.rightEar, FaceLandmarkType.rightEye],
        [FaceLandmarkType.leftEye, FaceLandmarkType.noseBase],
        [FaceLandmarkType.rightEye, FaceLandmarkType.noseBase],
        [FaceLandmarkType.leftEye, FaceLandmarkType.leftMouth],
        [FaceLandmarkType.leftMouth, FaceLandmarkType.rightMouth],
        [FaceLandmarkType.rightMouth, FaceLandmarkType.rightEye],
        [FaceLandmarkType.leftMouth, FaceLandmarkType.rightMouth],
      ];

      for (var connection in connections) {
        final start = Offset(
          face!.landmarks[connection[0]]!.position!.x * size.width,
          face!.landmarks[connection[0]]!.position!.y * size.height,
        );
        final end = Offset(
          face!.landmarks[connection[1]]!.position!.x * size.width,
          face!.landmarks[connection[1]]!.position!.y * size.height,
        );
        canvas.drawLine(start, end, connectionPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
