import 'dart:async';
import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/data_offline.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/models/teacher.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/home_page.dart';
import 'package:attendance_system_nodejs/services/smart_camera/smart_camera.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

class AttendanceFormPageOffline extends StatefulWidget {
  const AttendanceFormPageOffline({super.key, required this.attendanceForm});
  final AttendanceForm attendanceForm;

  @override
  State<AttendanceFormPageOffline> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendanceFormPageOffline> {
  XFile? file;
  late AttendanceForm attendanceForm;
  final ImagePicker _picker = ImagePicker();
  late Box<DataOffline> boxDataOffline;
  // late Box<StudentClasses> studentClassesBox;
  late Box<ClassesStudent> classesStudentBox;
  late Box<AttendanceForm> attendanceFormBox;
  SecureStorage secureStorage = SecureStorage();
  late ClassesStudent classesStudent;
  // late Classes classes;

  late ProgressDialog _progressDialog;

  @override
  void initState() {
    super.initState();
    attendanceForm = widget.attendanceForm;
    boxDataOffline = Hive.box<DataOffline>('DataOfflineBoxes');
    attendanceFormBox = Hive.box<AttendanceForm>('AttendanceFormBoxes');
    saveValue(widget.attendanceForm);
    openBox();
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
              const CircularProgressIndicator(
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
    var value = await SecureStorage().readSecureData('imageOffline');
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
    await attendanceFormBox.put('AttendanceOffline', attendanceForm);
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
          'Attendance Form Offline',
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
                      '',
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
                    ? SizedBox(
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
                          String dateTime = DateTime.now().toString();
                          // String studentID =
                          //     await SecureStorage().readSecureData('studentID');
                          // String latitude =
                          //     await SecureStorage().readSecureData('latitude');
                          // String longitude =
                          //     await SecureStorage().readSecureData('longitude');
                          await SecureStorage().writeSecureData(
                              'classes', attendanceForm.classes);
                          await SecureStorage()
                              .writeSecureData('formID', attendanceForm.formID);
                          await SecureStorage()
                              .writeSecureData('time', dateTime);

                          // boxDataOffline
                          //     .add(
                          //   DataOffline(
                          //     studentID: studentID,
                          //     classID: attendanceForm.classes,
                          //     formID: attendanceForm.formID,
                          //     dateAttendanced: dateTime,
                          //     location: '',
                          //     latitude: double.parse(latitude.toString()),
                          //     longitude: double.parse(longitude.toString()),
                          //   ),
                          // )
                          // .then((_) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: const Text('Attendance Pending'),
                                  content: const Text(
                                    'The system has recorded attendance data. When there is a network, data will be sent.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                        );
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          // });

                          await SecureStorage().deleteSecureData('image');
                        },
                        height: 55,
                        width: 400,
                        fontSize: 20,
                      )
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
                              page: 'AttendanceOffline',
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
