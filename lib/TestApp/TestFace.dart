// // Import necessary libraries
// import 'dart:io';
// import 'package:face_camera/face_camera.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:ekyc_id_flutter/ekyc_id_flutter.dart';

// // Define TestFace StatefulWidget
// class TestFace extends StatefulWidget {
//   const TestFace({Key? key}) : super(key: key);

//   @override
//   State<TestFace> createState() => _TestFaceState();
// }

// // Define _TestFaceState State
// class _TestFaceState extends State<TestFace> {
//   @override
//   void initState() {
//     super.initState();
//     // Initialize camera and request camera permission
//     initializeCamera();
//   }

//   // Initialize camera and request camera permission
//   Future<void> initializeCamera() async {
//     try {
//       await FaceCamera.initialize();
//       print('Camera initialized');

//       await requestCameraPermission();
//     } catch (e) {
//       print('Error initializing camera: $e');
//     }
//   }

//   // Request camera permission
//   Future<void> requestCameraPermission() async {
//     try {
//       PermissionStatus status = await Permission.camera.status;
//       if (!status.isGranted) {
//         PermissionStatus newStatus = await Permission.camera.request();
//         if (newStatus == PermissionStatus.denied ||
//             newStatus == PermissionStatus.permanentlyDenied) {
//           await requestCameraPermission();
//         }
//       }
//     } catch (e) {
//       print('Error requesting camera permission: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: TextButton(
//           onPressed: () async {
//             // Show modal bottom sheet for scanning face or document
//             await showScanningBottomSheet(context);
//           },
//           child: Text("Start KYC"),
//         ),
//       ),
//     );
//   }

//   // Show modal bottom sheet for scanning face or document
//   Future<void> showScanningBottomSheet(BuildContext context) async {
//     try {
//       await showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         builder: (BuildContext context) {
//           // Show FaceScannerView
//           return FaceScannerView(
//             options: FaceScannerOptions(
//               useFrontCamera: true,
//             ),
//             onFaceScanned: (face) async {
//               print(face.toString());
//             },
//           );
//         },
//       );
//     } catch (e) {
//       print('Error showing modal bottom sheet: $e');
//     }
//   }
// }
