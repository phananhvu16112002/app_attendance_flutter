import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/attendance_detail.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_form_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/providers/attendanceDetail_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceForm_data_provider.dart';
import 'package:attendance_system_nodejs/providers/check_location_provider.dart';
import 'package:attendance_system_nodejs/providers/classesStudent_data_provider.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Home/after_attendance_form/after_attendance_form.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:attendance_system_nodejs/services/smart_camera/smart_camera.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:flutter/cupertino.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttendanceFormPage extends StatefulWidget {
  AttendanceFormPage({super.key, required this.classesStudent});
  // final AttendanceForm attendanceForm;
  final ClassesStudent classesStudent;

  @override
  State<AttendanceFormPage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendanceFormPage> {
  XFile? file;
  final ImagePicker _picker = ImagePicker();
  late ProgressDialog _progressDialog;
  late ClassesStudent classesStudent;
  late LocationCheckProvider locationCheckProvider;
  late StudentDataProvider studentDataProvider;
  late Timer timer;
  String countdown = '';
  late DateTime endTime;
  late AttendanceFormDataForDetailPageProvider
      attendanceFormDataForDetailPageProvider;

  @override
  void initState() {
    super.initState();
    // attendanceForm = widget.attendanceForm;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      checkLocationAndShowSnackbar();
    });
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
    classesStudent = widget.classesStudent;

    locationCheckProvider =
        Provider.of<LocationCheckProvider>(context, listen: false);
    studentDataProvider =
        Provider.of<StudentDataProvider>(context, listen: false);
    attendanceFormDataForDetailPageProvider =
        Provider.of<AttendanceFormDataForDetailPageProvider>(context,
            listen: false);
    endTime = DateTime.parse(
            attendanceFormDataForDetailPageProvider.attendanceFormData.endTime)
        .toLocal();
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => updateCountdown());
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

  void checkLocationAndShowSnackbar() {
    final studentDataProvider =
        Provider.of<StudentDataProvider>(context, listen: false);
    locationCheckProvider.updateIsInsideLocation(LatLng(
      studentDataProvider.userData.latitude,
      studentDataProvider.userData.longtitude,
    ));

    if (!locationCheckProvider.isInsideLocation &&
        !locationCheckProvider.showSnackBar) {
      locationCheckProvider.setShowSnackBar(true);
      _showContinuousSnackbar();
    }
  }

  void _showContinuousSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.no_inside_tdtu ??
            'You are not in TDTUs area'),
        duration: Duration(days: 365),
        action: SnackBarAction(
          label: AppLocalizations.of(context)?.btn_hide ?? 'Ẩn',
          onPressed: () {
            locationCheckProvider.setShowSnackBar(false);
          },
        ),
      ),
    );
  }

  void updateCountdown() {
    DateTime now = DateTime.now();
    Duration remainingTime = endTime.difference(now);

    if (remainingTime <= Duration(seconds: 0)) {
      setState(() {
        countdown = 'Time Out';
      });
    } else {
      String minutes =
          remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds =
          remainingTime.inSeconds.remainder(60).toString().padLeft(2, '0');

      setState(() {
        countdown = '$minutes:${seconds} seconds';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final studentDataProvider =
        Provider.of<StudentDataProvider>(context, listen: true);
    final attendanceFormDataForDetailPageProvider =
        Provider.of<AttendanceFormDataForDetailPageProvider>(context,
            listen: false);
    final attendanceDetailDataProvider =
        Provider.of<AttendanceDetailDataProvider>(context, listen: false);
    final socketServerDataProvider =
        Provider.of<SocketServerProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back,
                color: Colors.white), // Thay đổi icon và màu sắc tùy ý
          ),
        ),
        title: Text(
          'Attendance Form',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryButton,
      ),
      body: bodyAttendance(
          studentDataProvider,
          attendanceFormDataForDetailPageProvider,
          classesStudent,
          attendanceDetailDataProvider,
          socketServerDataProvider),
    );
  }

  SingleChildScrollView bodyAttendance(
      StudentDataProvider studentDataProvider,
      AttendanceFormDataForDetailPageProvider
          attendanceFormDataForDetailPageProvider,
      ClassesStudent classesStudent,
      AttendanceDetailDataProvider attendanceDetailDataProvider,
      SocketServerProvider socketServerProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.verticalSpace,
            infoClass(classesStudent, attendanceFormDataForDetailPageProvider,
                attendanceDetailDataProvider, studentDataProvider),
            15.verticalSpace,
            infoLocation(studentDataProvider.userData.location),
            15.verticalSpace,
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (builder) => bottomSheet(
                        attendanceFormDataForDetailPageProvider,
                        classesStudent));
              },
              child: Container(
                width: 130.w,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                    color: AppColors.cardAttendance,
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                    border: Border.all(width: 1.w, color: Colors.transparent),
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
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryButton),
                  ),
                ),
              ),
            ),
            15.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 15.w),
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
              padding: const EdgeInsets.only(left: 0),
              child: file != null
                  ? CustomButton(
                      buttonName: 'Attendance',
                      colorShadow: AppColors.colorShadow,
                      backgroundColorButton: AppColors.primaryButton,
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      function: () async {
                        //add 12/5
                        if (locationCheckProvider.isInsideLocation == false) { //edit lại thành true
                          var studentID =
                              await SecureStorage().readSecureData('studentID');
                          _progressDialog.show();
                          AttendanceDetail? data = await API(context)
                              .takeAttendance(
                                  studentID,
                                  classesStudent.classID,
                                  attendanceFormDataForDetailPageProvider
                                      .attendanceFormData.formID,
                                  DateTime.now().toString(),
                                  studentDataProvider.userData.location,
                                  studentDataProvider.userData.latitude,
                                  studentDataProvider.userData.longtitude,
                                  file!,
                                  attendanceFormDataForDetailPageProvider
                                      .attendanceFormData.type);
                          if (data != null) {
                            print('Take Attendance Successfully');
                            socketServerProvider.takeAttendance(
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
                              duration: const Duration(seconds: 3),
                            ).show(context);
                          }
                          await SecureStorage().deleteSecureData('image');
                          await SecureStorage()
                              .deleteSecureData('imageOffline');
                          await _progressDialog.hide();
                        } else {
                          //add 12/5
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)
                                        ?.no_inside_tdtu ??
                                    "Bạn không ở trong khuôn viên TDTU"),
                                content: Text(AppLocalizations.of(context)
                                        ?.content_no_inside ??
                                    "Come to TDTU campus!."),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)
                                            ?.btn_close ??
                                        "Đóng"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      fontSize: 18.sp)
                  : Container(),
            ),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget infoLocation(String location) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          // height: 70,
          padding: EdgeInsets.symmetric(vertical: 5.h),
          decoration: BoxDecoration(
              color: AppColors.cardAttendance,
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              boxShadow: [
                const BoxShadow(
                    color: AppColors.secondaryText,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 0.0))
              ]),
          child: Padding(
            padding: EdgeInsets.only(left: 12.w, top: 15.h, bottom: 15.h),
            child: customRichText('Location: ', location, FontWeight.bold,
                FontWeight.w500, AppColors.primaryText, AppColors.primaryText),
          ),
        ),
      ],
    );
  }

  Widget infoClass(
      ClassesStudent classesStudent,
      AttendanceFormDataForDetailPageProvider
          attendanceFormDataForDetailPageProvider,
      AttendanceDetailDataProvider attendanceDetailDataProvider,
      StudentDataProvider studentDataProvider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18.h),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
              message: attendanceFormDataForDetailPageProvider
                          .attendanceFormData.dateOpen !=
                      ''
                  ? formatDate(attendanceFormDataForDetailPageProvider
                      .attendanceFormData.dateOpen)
                  // ? ''
                  : 'null',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText),
          5.verticalSpace,
          Container(
            height: 1.h,
            width: double.infinity,
            color: const Color.fromARGB(105, 190, 188, 188),
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
                              FontWeight.bold,
                              FontWeight.w500,
                              AppColors.primaryText,
                              AppColors.primaryText),
                        ],
                      ),
                      10.verticalSpace,
                      customRichText(
                          'Start Time: ',
                          // '',
                          formatTime(attendanceFormDataForDetailPageProvider
                              .attendanceFormData.startTime),
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      10.verticalSpace,
                      customRichText(
                          'End Time: ',
                          // '',
                          formatTime(attendanceFormDataForDetailPageProvider
                              .attendanceFormData.endTime),
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      10.verticalSpace,
                      customRichText(
                          'Duration: ',
                          countdown,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                    ],
                  ),
                ),
              ),
              attendanceFormDataForDetailPageProvider.attendanceFormData.type ==
                      0
                  ? Container(
                      // margin: EdgeInsets.only(right: 10.w, top: 10.h),
                      height: 140.h,
                      width: 140.w,
                      // color: Colors.amber,
                      child: Center(
                        child: Image.asset(
                          'assets/icons/face_camera.png',
                          width: 100.w,
                          height: 100.h,
                        ),
                      ),
                    )
                  : Container(
                      height: 140.h,
                      width: 140.w,
                      child: Image.asset('assets/images/checkinClass.png',
                          width: 75.w, height: 75.h),
                    )
            ],
          )
        ],
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
      AttendanceFormDataForDetailPageProvider attendanceFormDataProvider,
      ClassesStudent classesStudent) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 80.h,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r))),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Choose Your Photo',
            style: TextStyle(fontSize: 18.0.sp),
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              attendanceFormDataProvider.attendanceFormData.type == 0
                  ? ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    SmartCamera(
                              page: 'AttendanceNormal',
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
