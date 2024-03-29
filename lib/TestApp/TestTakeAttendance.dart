// import 'dart:io';

// import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
// import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
// import 'package:attendance_system_nodejs/common/colors/colors.dart';
// import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
// import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
// import 'package:attendance_system_nodejs/services/smart_camera/smart_camera.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class TestTakeAttendance extends StatefulWidget {
//   const TestTakeAttendance({super.key});

//   @override
//   State<TestTakeAttendance> createState() => _AttendancePageState();
// }

// class _AttendancePageState extends State<TestTakeAttendance> {
//   XFile? file;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       if (mounted) {
//         var socketProvider =
//             Provider.of<SocketServerProvider>(context, listen: false);
//         socketProvider.connectToSocketServer("5202111_09_t000");
//       }
//     });
//     getImage();
//   }

//   Future<void> getImage() async {
//     var value = await SecureStorage().readSecureData('image');
//     if (value.isNotEmpty && value != 'No Data Found') {
//       print(value);
//       setState(() {
//         file = XFile(value);
//       });
//     } else {
//       // Handle the case where the file path is empty or invalid
//       setState(() {
//         file = null;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final studentDataProvider =
//         Provider.of<StudentDataProvider>(context, listen: true);
//     final socketServerProvider =
//         Provider.of<SocketServerProvider>(context, listen: true);
//     return Scaffold(
//       appBar: AppBar(
//         leading: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: Container(
//             padding: const EdgeInsets.all(8.0),
//             child: const Icon(Icons.arrow_back,
//                 color: Colors.white), // Thay đổi icon và màu sắc tùy ý
//           ),
//         ),
//         title: const Text(
//           'Attendance Form',
//           style: TextStyle(
//               color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.primaryButton,
//       ),
//       body: bodyAttendance(studentDataProvider, socketServerProvider),
//     );
//   }

//   SingleChildScrollView bodyAttendance(StudentDataProvider studentDataProvider,
//       SocketServerProvider socketServerProvider) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.only(left: 15, right: 15),
//         // Column Tổng
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: 20,
//             ),
//             infoClass(socketServerProvider),
//             const SizedBox(
//               height: 15,
//             ),
//             infoLocation(studentDataProvider.userData.location),
//             const SizedBox(
//               height: 15,
//             ),
//             CustomButton(
//                 buttonName: 'Scan your face',
//                 colorShadow: AppColors.colorShadow,
//                 backgroundColorButton: AppColors.cardAttendance,
//                 borderColor: Colors.transparent,
//                 textColor: AppColors.primaryButton,
//                 function: () {
//                   // Navigator.pushReplacement(
//                   //   context,
//                   //   PageRouteBuilder(
//                   //     pageBuilder: (context, animation, secondaryAnimation) =>
//                   //         SmartCamera(),
//                   //     transitionDuration: const Duration(milliseconds: 300),
//                   //     transitionsBuilder:
//                   //         (context, animation, secondaryAnimation, child) {
//                   //       return ScaleTransition(
//                   //         scale: animation,
//                   //         child: child,
//                   //       );
//                   //     },
//                   //   ),
//                   // );
//                   showModalBottomSheet(
//                       context: context, builder: (builder) => bottomSheet());
//                 },
//                 height: 40,
//                 width: 140,
//                 fontSize: 15),
//             const SizedBox(
//               height: 15,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 15),
//               child: file != null
//                   ? Container(
//                       width: 350,
//                       height: 320,
//                       child: Center(
//                         child: file != null
//                             ? Image.file(File(file!.path))
//                             : Container(),
//                       ),
//                     )
//                   : Container(),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 0),
//               child: CustomButton(
//                   buttonName: 'Attendance',
//                   colorShadow: AppColors.colorShadow,
//                   backgroundColorButton: AppColors.primaryButton,
//                   borderColor: Colors.transparent,
//                   textColor: Colors.white,
//                   function: () async {
//                     await SecureStorage().deleteSecureData('image');
//                   },
//                   height: 55,
//                   width: 380,
//                   fontSize: 20),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Container infoLocation(String location) {
//     return Container(
//       width: 405,
//       height: 70,
//       decoration: const BoxDecoration(
//           color: AppColors.cardAttendance,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColors.secondaryText,
//                 blurRadius: 5.0,
//                 offset: Offset(0.0, 0.0))
//           ]),
//       child: Padding(
//         padding: const EdgeInsets.only(left: 12, top: 15, bottom: 15),
//         child: customRichText('Location: ', location, FontWeight.bold,
//             FontWeight.w500, AppColors.primaryText, AppColors.primaryText),
//       ),
//     );
//   }

//   Container infoClass(SocketServerProvider socketServerProvider) {
//     return Container(
//       width: 405,
//       height: 200,
//       decoration: const BoxDecoration(
//           color: AppColors.cardAttendance,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColors.secondaryText,
//                 blurRadius: 5.0,
//                 offset: Offset(0.0, 0.0))
//           ]),
//       child: Column(
//         children: [
//           const CustomText(
//               message: 'Tuesday 7 January, 2023',
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: AppColors.primaryText),
//           const SizedBox(
//             height: 2,
//           ),
//           Container(
//             height: 1,
//             width: 405,
//             color: const Color.fromARGB(105, 190, 188, 188),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(left: 15, top: 10),
//                 child: Container(
//                   width: 190,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       customRichText(
//                           'Class: ',
//                           'Phát triển hệ thống thông tin doanh nghiệp',
//                           FontWeight.bold,
//                           FontWeight.w500,
//                           AppColors.primaryText,
//                           AppColors.primaryText),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       customRichText(
//                           'Status: ',
//                           'Absent',
//                           FontWeight.bold,
//                           FontWeight.w500,
//                           AppColors.primaryText,
//                           AppColors.importantText),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           customRichText(
//                               'Shift: ',
//                               '4',
//                               FontWeight.bold,
//                               FontWeight.w500,
//                               AppColors.primaryText,
//                               AppColors.primaryText),
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           customRichText(
//                               'Room: ',
//                               'A0405',
//                               FontWeight.bold,
//                               FontWeight.w500,
//                               AppColors.primaryText,
//                               AppColors.primaryText),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       // customRichText(
//                       //     'Start Time: ',
//                       //     '${socketServerProvider.attendanceForm.startTime}',
//                       //     FontWeight.bold,
//                       //     FontWeight.w500,
//                       //     AppColors.primaryText,
//                       //     AppColors.primaryText),
//                       // const SizedBox(
//                       //   height: 10,
//                       // ),
//                       // customRichText(
//                       //     'End Time: ',
//                       //     '${socketServerProvider.attendanceForm.endTime}',
//                       //     FontWeight.bold,
//                       //     FontWeight.w500,
//                       //     AppColors.primaryText,
//                       //     AppColors.primaryText),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(right: 10, top: 10),
//                 height: 140,
//                 width: 140,
//                 color: Colors.amber,
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   RichText customRichText(
//       String title,
//       String message,
//       FontWeight fontWeightTitle,
//       FontWeight fontWeightMessage,
//       Color colorTextTitle,
//       Color colorTextMessage) {
//     return RichText(
//         text: TextSpan(children: [
//       TextSpan(
//         text: title,
//         style: TextStyle(
//           fontWeight: fontWeightTitle,
//           fontSize: 15,
//           color: colorTextTitle,
//         ),
//       ),
//       TextSpan(
//         text: message,
//         style: TextStyle(
//           fontWeight: fontWeightMessage,
//           fontSize: 15,
//           color: colorTextMessage,
//         ),
//       ),
//     ]));
//   }

//   String formatDate(String date) {
//     DateTime serverDateTime = DateTime.parse(date);
//     String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
//     return formattedDate;
//   }

//   String formatTime(String time) {
//     DateTime serverDateTime = DateTime.parse(time);
//     String formattedTime = DateFormat('HH:mm:ss').format(serverDateTime);
//     return formattedTime;
//   }

//   Widget bottomSheet() {
//     return Container(
//       height: 100,
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Column(
//         children: <Widget>[
//           const Text(
//             'Choose Your Photo',
//             style: TextStyle(fontSize: 20.0),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton.icon(
//                 onPressed: () {
                  
//                 },
//                 icon: const Icon(Icons.camera),
//                 label: const Text('Camera'),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   takePhoto(ImageSource.gallery);
//                 },
//                 icon: const Icon(Icons.camera),
//                 label: const Text('Gallery'),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   void takePhoto(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         file = pickedFile;
//       });
//     }
//   }
// }
