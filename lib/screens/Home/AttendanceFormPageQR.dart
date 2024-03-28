import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/CustomButton.dart';
import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/AttendanceDetail.dart';
import 'package:attendance_system_nodejs/models/AttendanceForm.dart';
import 'package:attendance_system_nodejs/models/Class.dart';
import 'package:attendance_system_nodejs/models/ClassesStudent.dart';
import 'package:attendance_system_nodejs/models/DataOffline.dart';
import 'package:attendance_system_nodejs/models/StudentClasses.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Home/AfterAttendance.dart';
import 'package:attendance_system_nodejs/screens/Home/HomePage.dart';
import 'package:attendance_system_nodejs/services/API.dart';
import 'package:attendance_system_nodejs/services/SmartCamera.dart';
import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class AttendanceFormPageQR extends StatefulWidget {
  const AttendanceFormPageQR({super.key, required this.attendanceForm});
  final AttendanceForm attendanceForm;

  @override
  State<AttendanceFormPageQR> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendanceFormPageQR> {
  XFile? file;
  late AttendanceForm attendanceForm;
  final ImagePicker _picker = ImagePicker();
  // late Box<StudentClasses> studentClassesBox;
  late Box<AttendanceForm> attendanceFormBox;
  late Box<ClassesStudent> classesStudentBox;
  late ClassesStudent classesStudent;

  // late Classes classes;
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    attendanceForm = widget.attendanceForm;
    // studentClassesBox = Hive.box<StudentClasses>('student_classes');
    attendanceFormBox = Hive.box<AttendanceForm>('AttendanceFormBoxes');
    saveValue(widget.attendanceForm);
    openBox();
    getImage(); //avoid rebuild
    _progressDialog = ProgressDialog(context,
        customBody: Container(
          width: 200,
          height: 150,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.white),
          child: const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Loading',
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
        ));
  }

  Future<void> getImage() async {
    var value = await SecureStorage().readSecureData('image');
    if (value.isNotEmpty && value != 'No Data Found') {
      print(value);
      setState(() {
        file = XFile(value);
      });
    } else {
      setState(() {
        file = null;
      });
    }
  }

  Future<void> saveValue(AttendanceForm attendanceForm) async {
    await attendanceFormBox.put('AttendanceQR', attendanceForm);
  }

  Future<void> openBox() async {
    classesStudentBox = Hive.box<ClassesStudent>('classes_student_box');
    classesStudent = classesStudentBox.get(attendanceForm.classes)!;
  }

  // Future<void> openBox() async {
  //   studentClassesBox = Hive.box<StudentClasses>('student_classes');
  //   for (var temp in studentClassesBox.values.toList()) {
  //     if (temp.classes.classID == attendanceForm.classes ||
  //         temp.classes.classID.contains(attendanceForm.classes)) {
  //       setState(() {
  //         classes = temp.classes;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print('-------------------');
    print('Rebuild-------');
    final studentDataProvider =
        Provider.of<StudentDataProvider>(context, listen: true);
    final socketDataProvider =
        Provider.of<SocketServerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (builder) => const HomePage()),
                (route) => false);
            SecureStorage().deleteSecureData('image');
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back,
                color: Colors.white), // Thay đổi icon và màu sắc tùy ý
          ),
        ),
        title: const Text(
          'Attendance Form QR',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryButton,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          // Column Tổng
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 405,
                height: 220,
                decoration: const BoxDecoration(
                    color: AppColors.cardAttendance,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.secondaryText,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.0))
                    ]),
                child: Column(
                  children: [
                    CustomText(
                        message: attendanceForm.dateOpen != ''
                            ? formatDate(attendanceForm.dateOpen)
                            : 'null',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      height: 1,
                      width: 405,
                      color: const Color.fromARGB(105, 190, 188, 188),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 15, top: 10),
                          child: Container(
                            width: 190,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customRichText(
                                    'Class: ',
                                    classesStudent.courseName,
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.primaryText),
                                const SizedBox(
                                  height: 10,
                                ),
                                customRichText(
                                    'Status: ',
                                    getResult(0),
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.importantText),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    customRichText(
                                        'Shift: ',
                                        '${classesStudent.shiftNumber}',
                                        FontWeight.bold,
                                        FontWeight.w500,
                                        AppColors.primaryText,
                                        AppColors.primaryText),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    customRichText(
                                        'Room: ',
                                        classesStudent.roomNumber,
                                        FontWeight.bold,
                                        FontWeight.w500,
                                        AppColors.primaryText,
                                        AppColors.primaryText),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                customRichText(
                                    'Start Time: ',
                                    formatTime(attendanceForm.startTime),
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.primaryText),
                                const SizedBox(
                                  height: 10,
                                ),
                                customRichText(
                                    'End Time: ',
                                    formatTime(attendanceForm.endTime),
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.primaryText),
                                const SizedBox(
                                  height: 10,
                                ),
                                customRichText(
                                    'Duration: ',
                                    '',
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.primaryText),
                              ],
                            ),
                          ),
                        ),
                        attendanceForm.typeAttendance == 0
                            ? Container(
                                margin:
                                    const EdgeInsets.only(right: 10, top: 10),
                                height: 140,
                                width: 140,
                                color: Colors.transparent,
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/face_camera.png',
                                    width: 75,
                                    height: 75,
                                  ),
                                ),
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.only(right: 10, top: 10),
                                height: 140,
                                width: 140,
                                color: Colors.transparent,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/checkinClass.png',
                                    width: 75,
                                    height: 75,
                                  ),
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: 405,
                height: 70,
                decoration: const BoxDecoration(
                    color: AppColors.cardAttendance,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: AppColors.secondaryText,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.0))
                    ]),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, top: 15, bottom: 15),
                  child: customRichText(
                      'Location: ',
                      studentDataProvider.userData.location,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (builder) =>
                          bottomSheet(attendanceForm, classesStudent));
                },
                child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      color: AppColors.cardAttendance,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      border: Border.all(width: 1, color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.colorShadow.withOpacity(0.2),
                            blurRadius: 1,
                            offset: const Offset(0, 2))
                      ]),
                  child: Center(
                    child: Text(
                      'Scan your face',
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryButton),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: file != null
                    ? Container(
                        width: 350,
                        height: 320,
                        child: Center(
                          child: file != null
                              ? Image.file(File(file!.path))
                              : Container(),
                        ),
                      )
                    : Container(),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: file != null
                    ? CustomButton(
                        buttonName: 'Attendance',
                        colorShadow: AppColors.colorShadow,
                        backgroundColorButton: AppColors.primaryButton,
                        borderColor: Colors.transparent,
                        textColor: Colors.white,
                        function: () async {
                          _progressDialog.show();
                          AttendanceDetail? data = await API(context)
                              .takeAttendance(
                                  studentDataProvider.userData.studentID,
                                  attendanceForm.classes,
                                  attendanceForm.formID,
                                  DateTime.now().toString(),
                                  studentDataProvider.userData.location,
                                  studentDataProvider.userData.latitude,
                                  studentDataProvider.userData.longtitude,
                                  file!);
                          if (data != null) {
                            print('Take Attendance Successfully');
                            socketDataProvider.takeAttendance(
                                data.studentDetail,
                                data.classDetail,
                                data.attendanceForm.formID,
                                data.dateAttendanced,
                                data.location,
                                data.latitude,
                                data.longitude,
                                data.result,
                                data.url);
                            if (mounted) {
                              await Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      AfterAttendance(
                                    attendanceDetail: data,
                                    classesStudent: classesStudent,
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              );
                              await _progressDialog.hide();
                            }
                          } else {
                            await _progressDialog.hide();
                            await Flushbar(
                              title: "Failed",
                              message:
                                  "Please check and take attendance again!",
                              duration: const Duration(seconds: 10),
                            ).show(context);
                          }
                          await SecureStorage().deleteSecureData('image');
                          await SecureStorage()
                              .deleteSecureData('imageOffline');
                          await _progressDialog.hide();
                        },
                        height: 55,
                        width: 400,
                        fontSize: 20)
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container infoLocation(String location) {
    return Container(
      width: 405,
      height: 70,
      decoration: const BoxDecoration(
          color: AppColors.cardAttendance,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: AppColors.secondaryText,
                blurRadius: 5.0,
                offset: Offset(0.0, 0.0))
          ]),
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 15, bottom: 15),
        child: customRichText('Location: ', location, FontWeight.bold,
            FontWeight.w500, AppColors.primaryText, AppColors.primaryText),
      ),
    );
  }

  RichText customRichText(
      String title,
      String message,
      FontWeight fontWeightTitle,
      FontWeight fontWeightMessage,
      Color colorTextTitle,
      Color colorTextMessage) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
        text: title,
        style: TextStyle(
          fontWeight: fontWeightTitle,
          fontSize: 15,
          color: colorTextTitle,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: 15,
          color: colorTextMessage,
        ),
      ),
    ]));
  }

  Widget bottomSheet(
      AttendanceForm attendanceForm, ClassesStudent classesStudent) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text(
            'Choose Your Photo',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              attendanceForm.typeAttendance == 0
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SmartCamera(
                              page: 'AttendanceQR',
                              classesStudent: classesStudent,
                            ),
                            transitionDuration:
                                const Duration(milliseconds: 300),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text('Camera'),
                    )
                  : ElevatedButton.icon(
                      onPressed: () {
                        takePhoto(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text('Gallery'),
                    ),
              // const SizedBox(
              //   width: 10,
              // ),
              // ElevatedButton.icon(
              //   onPressed: () {
              //     takePhoto(ImageSource.gallery);
              //   },
              //   icon: const Icon(Icons.camera),
              //   label: const Text('Gallery'),
              // ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        file = pickedFile;
      });
    }
  }

  Color getColorBasedOnStatus(String status) {
    if (status.contains('Present')) {
      return AppColors.textApproved;
    } else if (status.contains('Late')) {
      return const Color.fromARGB(231, 196, 123, 34);
    } else if (status.contains('Absence')) {
      return AppColors.importantText;
    } else {
      return AppColors.primaryText;
    }
  }

  String getResult(double result) {
    if (result.ceil() == 1) {
      return 'Present';
    } else if (result == 0.5) {
      return 'Late';
    } else if (result.ceil() == 0) {
      return 'Absence';
    } else {
      return 'Absence';
    }
  }

  String formatDate(String date) {
    DateTime serverDateTime = DateTime.parse(date).toLocal();
    String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
    return formattedDate;
  }

  String formatTime(String time) {
    DateTime serverDateTime = DateTime.parse(time).toLocal();
    String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
    return formattedTime;
  }
}
