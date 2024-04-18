import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/attendance_detail.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Home/after_attendance_form/after_attendance_form.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/home_page.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:attendance_system_nodejs/services/smart_camera/smart_camera.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';

class AttendanceFormPageQR extends StatefulWidget {
  AttendanceFormPageQR({super.key, required this.attendanceForm});
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
    // openBox();
    getImage(); //avoid rebuild
    _progressDialog = ProgressDialog(context,
        isDismissible: false,
        customBody: Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: Colors.white),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
              5.verticalSpace,
              Text(
                'Loading',
                style: TextStyle(
                    fontSize: 16.sp,
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
                MaterialPageRoute(builder: (builder) => HomePage()),
                (route) => false);
            SecureStorage().deleteSecureData('image');
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back,
                color: Colors.white), // Thay đổi icon và màu sắc tùy ý
          ),
        ),
        title: Text(
          'Attendance Form QR',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryButton,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15.w, right: 15.w),
          // Column Tổng
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.verticalSpace,
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 18.h),
                // height: 220,
                decoration: BoxDecoration(
                    color: AppColors.cardAttendance,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    boxShadow: const [
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
                            // ? ""
                            : 'null',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryText),
                    5.verticalSpace,
                    Container(
                      height: 1.h,
                      width: double.infinity,
                      color: Color.fromARGB(105, 190, 188, 188),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 15.w, top: 10.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customRichText(
                                    'Class: ',
                                    classesStudent.courseName,
                                    // "",
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.primaryText),
                                10.verticalSpace,
                                customRichText(
                                    'Status: ',
                                    getResult(0),
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.importantText),
                                10.verticalSpace,
                                Row(
                                  children: [
                                    customRichText(
                                        'Shift: ',
                                        '${classesStudent.shiftNumber}',
                                        // "",
                                        FontWeight.bold,
                                        FontWeight.w500,
                                        AppColors.primaryText,
                                        AppColors.primaryText),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    customRichText(
                                        'Room: ',
                                        classesStudent.roomNumber,
                                        // "",
                                        FontWeight.bold,
                                        FontWeight.w500,
                                        AppColors.primaryText,
                                        AppColors.primaryText),
                                  ],
                                ),
                                10.verticalSpace,
                                customRichText(
                                    'Start Time: ',
                                    formatTime(attendanceForm.startTime),
                                    // "",
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.primaryText),
                                10.verticalSpace,
                                customRichText(
                                    'End Time: ',
                                    formatTime(attendanceForm.endTime),
                                    // "",
                                    FontWeight.bold,
                                    FontWeight.w500,
                                    AppColors.primaryText,
                                    AppColors.primaryText),
                                //  10.verticalSpace,
                                // customRichText(
                                //     'Duration: ',
                                //     '',
                                //     FontWeight.bold,
                                //     FontWeight.w500,
                                //     AppColors.primaryText,
                                //     AppColors.primaryText),
                              ],
                            ),
                          ),
                        ),
                        attendanceForm.typeAttendance == 0
                            ? Container(
                                // margin:
                                //      EdgeInsets.only(right: 10.w, top: 10),
                                height: 140.h,
                                width: 140.w,
                                color: Colors.transparent,
                                child: Center(
                                  child: Image.asset(
                                    'assets/icons/face_camera.png',
                                    width: 75.w,
                                    height: 75.h,
                                  ),
                                ),
                              )
                            : Container(
                                // margin:
                                //      EdgeInsets.only(right: 10.w, top: 10),
                                height: 140.h,
                                width: 140.w,
                                color: Colors.transparent,
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/checkinClass.png',
                                    width: 75.w,
                                    height: 75.h,
                                  ),
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
              15.verticalSpace,
              Container(
                width: double.infinity,
                // height: 70,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: BoxDecoration(
                    color: AppColors.cardAttendance,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.secondaryText,
                          blurRadius: 5.0,
                          offset: Offset(0.0, 0.0))
                    ]),
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w, top: 15.h, bottom: 15.h),
                  child: customRichText(
                      'Location: ',
                      studentDataProvider.userData.location,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                ),
              ),
              15.verticalSpace,
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (builder) =>
                          bottomSheet(attendanceForm, classesStudent));
                },
                child: Container(
                  width: 130.w,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                      color: AppColors.cardAttendance,
                      borderRadius: BorderRadius.all(Radius.circular(5.r)),
                      border: Border.all(width: 1, color: Colors.transparent),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.colorShadow.withOpacity(0.2),
                            blurRadius: 1,
                            offset: Offset(0, 2))
                      ]),
                  child: Center(
                    child: Text(
                      'Scan your face',
                      style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryButton),
                    ),
                  ),
                ),
              ),
              15.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: file != null
                    ? Container(
                        width: 350.w,
                        height: 320.h,
                        child: Center(
                          child: file != null
                              ? Image.file(File(file!.path))
                              : Container(),
                        ),
                      )
                    : Container(),
              ),
              10.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 0),
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
                                  file!,
                                  attendanceForm.typeAttendance);
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
                                      Duration(milliseconds: 200),
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
                              duration: Duration(seconds: 10),
                            ).show(context);
                          }
                          await SecureStorage().deleteSecureData('image');
                          await SecureStorage()
                              .deleteSecureData('imageOffline');
                          await _progressDialog.hide();
                        },
                        fontSize: 18.sp)
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
      width: double.infinity,
      // height: 70,
      padding: EdgeInsets.symmetric(vertical: 5.h),

      decoration: BoxDecoration(
          color: AppColors.cardAttendance,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          boxShadow: [
            BoxShadow(
                color: AppColors.secondaryText,
                blurRadius: 5.0,
                offset: Offset(0.0, 0.0))
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 15.h, bottom: 15.h),
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
          fontSize: 13.sp,
          color: colorTextTitle,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: 13.sp,
          color: colorTextMessage,
        ),
      ),
    ]));
  }

  Widget bottomSheet(
      AttendanceForm attendanceForm, ClassesStudent classesStudent) {
    return Container(
      height: 80.h,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Your Photo',
            style: TextStyle(fontSize: 18.sp),
          ),
          10.verticalSpace,
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
                            transitionDuration: Duration(milliseconds: 300),
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
                      icon: Icon(Icons.camera),
                      label: Text('Camera'),
                    )
                  : Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            takePhoto(ImageSource.camera);
                          },
                          icon: const Icon(Icons.camera),
                          label: const Text('Camera'),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            takePhoto(ImageSource.gallery);
                          },
                          icon: const Icon(
                              Icons.photo_size_select_actual_rounded),
                          label: const Text('Gallery'),
                        ),
                      ],
                    ),
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
      return Color.fromARGB(231, 196, 123, 34);
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

  String formatDate(String? date) {
    if (date != null || date != '') {
      DateTime serverDateTime = DateTime.parse(date!).toLocal();
      String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
      return formattedDate;
    }
    return '';
  }

  String formatTime(String? time) {
    if (time != '' || time != null) {
      DateTime serverDateTime = DateTime.parse(time!).toLocal();
      String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
      return formattedTime;
    }
    return '';
  }
}
