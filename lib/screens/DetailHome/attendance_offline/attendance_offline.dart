import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/attendance_offline.dart/attendance_detail_offline.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/data_offline.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Home/after_attendance_form/after_attendance_form.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:attendance_system_nodejs/services/get_location/get_location_services.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AttendanceOffline extends StatefulWidget {
  const AttendanceOffline({super.key, required this.classesStudent});
  final ClassesStudent classesStudent;

  @override
  State<AttendanceOffline> createState() => _AttendanceOfflineState();
}

class _AttendanceOfflineState extends State<AttendanceOffline> {
  late ClassesStudent classesStudent;
  bool activeTotal = true;
  bool activeSuccess = false;
  bool activeFailed = false;
  bool activePending = false;
  late Box<DataOffline> dataOfflineBox;
  late DataOffline? dataOffline;
  XFile? file;
  late ProgressDialog _progressDialog;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classesStudent = widget.classesStudent;
    openBox();
    getImage();
    _progressDialog = _customLoading();
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

  Future<void> openBox() async {
    dataOfflineBox = Hive.box<DataOffline>('DataOfflineBoxes');
    dataOffline = dataOfflineBox.get('dataOffline');
  }

  ProgressDialog _customLoading() {
    return ProgressDialog(context,
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

  void sendDataToServer() async {
    DataOffline? dataOffline = dataOfflineBox.get('dataOffline');
    String xFile = await SecureStorage().readSecureData('imageOffline');
    if (xFile.isNotEmpty && xFile != 'No Data Found' && dataOffline != null) {
      _progressDialog.show();
      String? location = await GetLocation()
          .getAddressFromLatLongWithoutInternet(
              dataOffline.latitude ?? 0.0, dataOffline.longitude ?? 0.0);
      // print('location: $location');
      bool check = await API(context).takeAttendanceOffline(
          dataOffline.studentID ?? '',
          dataOffline.classID ?? '',
          dataOffline.formID ?? '',
          dataOffline.dateAttendanced ?? '',
          location ?? '',
          dataOffline.latitude ?? 0.0,
          dataOffline.longitude ?? 0.0,
          XFile(xFile));
      if (check) {
        print('Successfully take attendance offline');
        await dataOfflineBox.delete('dataOffline');
        await _progressDialog.hide();
        customDialog('Successfully', 'Take attendance offline successfully!');
        if (dataOfflineBox.isEmpty) {
          print('Delete ok');
        } else {
          print('No delele local storage');
        }
      } else {
        await _progressDialog.hide();

        customDialog('Failed', 'Take attendance offline failed!');
        print('Failed take attendance offline');
      }
    } else {
      print('Data is not available');
    }
  }

  Future<dynamic> customDialog(String title, String content) {
    return showDialog(
        context: context,
        builder: (builder) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    SocketServerProvider socketServerProvider =
        Provider.of<SocketServerProvider>(context);
    // DataOffline? data = dataOfflineBox.getAt(0);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customAppBar(socketServerProvider),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  10.verticalSpace,
                  if (dataOffline != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: customCard(
                        formatTime(dataOffline?.startTime) ?? '',
                        formatTime(dataOffline?.endTime) ?? '',
                        formatDate(dataOffline?.dateAttendanced ?? ''),
                        formatTime(dataOffline?.dateAttendanced) ?? '',
                        'Pending',
                        dataOffline?.location ?? '',
                      ),
                    ),
                  FutureBuilder(
                      future: API(context)
                          .getAttendanceDetailOffline(classesStudent.classID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            List<AttendanceDetailOffline>? data = snapshot.data;
                            if (data != null && data.isNotEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: data.length,
                                  itemBuilder: ((context, index) {
                                    AttendanceDetailOffline
                                        attendanceDetailOffline = data[index];

                                    return customBox(
                                        formatTime(classesStudent.startTime),
                                        formatTime(classesStudent.endTime),
                                        formatDate(
                                            attendanceDetailOffline.dateAttendanced),
                                        formatTime(
                                            attendanceDetailOffline.dateAttendanced),
                                        getResult(attendanceDetailOffline.result
                                                ?.toDouble() ??
                                            0),
                                        attendanceDetailOffline.location ?? '');
                                  }),
                                  separatorBuilder: ((context, index) {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 15.h,
                                    );
                                  }),
                                ),
                              );
                            } else {}
                          }
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Container();
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _header(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          boxShadow: const [
            BoxShadow(
                color: AppColors.secondaryText,
                blurRadius: 5.0,
                offset: Offset(0.0, 0.0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeSuccess = false;
                  activeFailed = false;
                  activeTotal = true;
                  activePending = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: activeTotal ? AppColors.cardAttendance : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: Center(
                  child: CustomText(
                    message: 'Total',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeFailed = false;
                  activeSuccess = true;
                  activeTotal = false;
                  activePending = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: activeSuccess
                      ? const Color.fromARGB(94, 137, 210, 64)
                      : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: Center(
                  child: CustomText(
                    message: 'Success',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeFailed = true;
                  activeSuccess = false;
                  activeTotal = false;
                  activePending = false;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: activeFailed
                      ? const Color.fromARGB(216, 219, 87, 87)
                      : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: Center(
                  child: CustomText(
                    message: 'Failed',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  activeFailed = false;
                  activeSuccess = false;
                  activeTotal = false;
                  activePending = true;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                decoration: BoxDecoration(
                  color: activePending
                      ? const Color.fromARGB(231, 232, 156, 63)
                      : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.r)),
                ),
                child: Center(
                  child: CustomText(
                    message: 'Pending',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container customAppBar(SocketServerProvider socketServerProvider) {
    return Container(
      width: double.infinity,
      // height: 130,
      padding: EdgeInsets.symmetric(vertical: 30.h),
      decoration: BoxDecoration(
        color: AppColors.primaryButton,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    socketServerProvider.disconnectSocketServer();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.r)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 14.w,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customText(
                        classesStudent.courseName,
                        18.sp,
                        FontWeight.w600,
                        Colors.white,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              CustomText(
                                message: 'CourseID: ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              CustomText(
                                message: '${classesStudent.courseID} ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Container(
                            width: 1.w,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Row(
                            children: [
                              CustomText(
                                message: ' Room: ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              CustomText(
                                message: '${classesStudent.roomNumber} ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                message: 'Shift: ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              CustomText(
                                message: '${classesStudent.shiftNumber} ',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            width: 1.w,
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          CustomText(
                            message: ' Lecturer: ',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          CustomText(
                            message: '${classesStudent.teacherName} ',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget customText(
      String title, double fontSize, FontWeight fontWeight, Color color) {
    return Text(
      title,
      style:
          TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color),
      overflow: TextOverflow.ellipsis,
    );
  }

  Container customCard(
    String startTime,
    String endTime,
    String date,
    String timeAttendance,
    String status,
    String location,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(195, 190, 188, 188),
            blurRadius: 5.0,
            offset: Offset(2.0, 1.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                CustomText(
                  message: date.toString(),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
                2.verticalSpace,
                Container(
                  height: 1.h,
                  width: double.infinity,
                  color: const Color.fromARGB(105, 190, 188, 188),
                ),
                5.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customRichText(
                            'Start Time: ',
                            startTime,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'End Time: ',
                            endTime,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'Location: ',
                            location,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'Time Attendance: ',
                            timeAttendance.toString(),
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'Status: ',
                            status,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            getColorBasedOnStatus(status),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      height: 130.h,
                      width: 100.w,
                      child: file != null
                          ? Image.file(
                              fit: BoxFit.fill,
                              File(file!.path),
                            )
                          : Container(),
                      // child: Image.network('https://i.imgur.com/8JhlwPy_d.webp?maxwidth=520&shape=thumb&fidelity=high'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          10.verticalSpace,
          Container(
            height: 1.h,
            width: double.infinity,
            color: const Color.fromARGB(105, 190, 188, 188),
          ),
          5.verticalSpace,
          InkWell(
            onTap: () {
              //resend take attendance offline
              print('asdd');
              sendDataToServer();
            },
            child: CustomText(
                message: 'Resend',
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryButton),
          )
        ],
      ),
    );
  }

  Container customBox(
    String startTime,
    String endTime,
    String date,
    String timeAttendance,
    String status,
    String location,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: const[
           BoxShadow(
            color: Color.fromARGB(195, 190, 188, 188),
            blurRadius: 5.0,
            offset: Offset(2.0, 1.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              children: [
                CustomText(
                  message: date.toString(),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryText,
                ),
                2.verticalSpace,
                Container(
                  height: 1.h,
                  width: double.infinity,
                  color: const Color.fromARGB(105, 190, 188, 188),
                ),
                5.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          customRichText(
                            'Start Time: ',
                            startTime,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'End Time: ',
                            endTime,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'Location: ',
                            location,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'Time Attendance: ',
                            timeAttendance.toString(),
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            AppColors.primaryText,
                          ),
                          10.verticalSpace,
                          customRichText(
                            'Status Attendance: ',
                            status,
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            getColorBasedOnStatus(status),
                          ),
                          10.verticalSpace,
                          customRichText(
                            'Status Offline: ',
                            getStatusTakeAttendance(status),
                            FontWeight.w600,
                            FontWeight.w500,
                            AppColors.primaryText,
                            getColorBasedOnStatusOffline(status),
                          ),
                          
                        ],
                      ),
                    ),
                    SizedBox(
                            width: 10.w,
                          ),
                    Container(
                      height: 130.h,
                      width: 100.w,
                      child: file != null
                          ? Image.file(
                            fit: BoxFit.fill,
                              File(file!.path),
                            )
                          : Image.asset('assets/images/logo.png'),
                      // child: Image.network('https://i.imgur.com/8JhlwPy_d.webp?maxwidth=520&shape=thumb&fidelity=high'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          5.verticalSpace,
          Container(
            height: 1.h,
            width: double.infinity,
            color: const Color.fromARGB(105, 190, 188, 188),
          ),
          5.verticalSpace,
          InkWell(
            onTap: () {
              //resend take attendance offline
            },
            child: CustomText(
                message: 'Report',
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.importantText),
          )
        ],
      ),
    );
  }

  String getStatusTakeAttendance(String status) {
    if (status == 'Present' || status.contains('Present')) {
      return 'Successfully';
    } else if (status == 'Late' || status.contains('Late')) {
      return 'Successfully';
    } else {
      return 'Failed';
    }
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
          fontSize: 14.sp,
          color: colorTextTitle,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: 14.sp,
          color: colorTextMessage,
        ),
      ),
    ]));
  }

  Color getColorBasedOnStatus(String status) {
    if (status.contains('Present')) {
      return AppColors.textApproved;
    } else if (status.contains('Pending')) {
      return const Color.fromARGB(231, 196, 123, 34);
    } else if (status.contains('Absence')) {
      return AppColors.importantText;
    } else {
      return AppColors.primaryText;
    }
  }

  Color getColorBasedOnStatusOffline(String status) {
    if (status.contains('Present')) {
      return AppColors.textApproved;
    } else if (status.contains('Late')) {
      return const Color.fromARGB(231, 196, 123, 34);
    } else {
      return AppColors.importantText;
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
    if (time != null || time != '') {
      DateTime serverDateTime = DateTime.parse(time!).toLocal();
      String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
      return formattedTime;
    }
    return '';
  }
}
