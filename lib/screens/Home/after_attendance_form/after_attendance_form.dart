import 'package:attendance_system_nodejs/common/bases/custom_button.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/attendance_detail.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AfterAttendance extends StatefulWidget {
  const AfterAttendance(
      {super.key,
      required this.attendanceDetail,
      required this.classesStudent});
  final AttendanceDetail attendanceDetail;
  final ClassesStudent classesStudent;

  @override
  State<AfterAttendance> createState() => _AfterAttendanceState();
}

class _AfterAttendanceState extends State<AfterAttendance> {
  late AttendanceDetail data;
  late ClassesStudent classStudentData;
  @override
  void initState() {
    super.initState();
    data = widget.attendanceDetail;
    classStudentData = widget.classesStudent;
  }

  @override
  Widget build(BuildContext context) {
    final studentClasses =
        Provider.of<StudentClassesDataProvider>(context, listen: false);
    var temp = studentClasses.getDataForClass(data.classDetail);
    final socketProvider =
        Provider.of<SocketServerProvider>(context, listen: false);
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          _buildContent(socketProvider, context),
        ],
      ),
    ));
  }

  Widget _buildContent(
      SocketServerProvider socketProvider, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GifView.asset(
              'assets/images/success1.gif',
              color: AppColors.backgroundColor,
              colorBlendMode: BlendMode.overlay,
              width: 150.w,
              height: 150.h,
              fit: BoxFit.cover,
            ),
          ),
          10.verticalSpace,
          Center(
            child: CustomText(
                message: 'Attendance Successfully',
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryText),
          ),
          10.verticalSpace,
          Container(
              width: double.infinity,
              height: 1.h,
              color: Color.fromARGB(40, 0, 0, 0)),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  message: 'Class: ',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText),
              CustomText(
                  message: classStudentData.courseName,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText)
            ],
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  message: 'Status: ',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText),
              CustomText(
                  message: getResult(data.result),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: getColorBasedOnStatus(getResult(data.result)))
            ],
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  message: 'Time: ',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText),
              CustomText(
                  // message: 'July 28, 2024 - 19:40:55 PM',
                  message:
                      '${formatDate(data.dateAttendanced)} - ${formatTime(data.dateAttendanced)}',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryText)
            ],
          ),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                  message: 'Location: ',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: CustomText(
                    message: data.location,
                    // message:
                    //     'as;ldaksd;laskdl;askd;laskd;laksd;laskd;laskd;lakasdasdasdasdasdasdassda',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText),
              ),
            ],
          ),
          10.verticalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  message: 'Image Evidence: ',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondaryText),
              10.verticalSpace,
              Image.network(
                data.url,
                // 'https://i.imgur.com/8JhlwPy_d.webp?maxwidth=520&shape=thumb&fidelity=high',
                fit: BoxFit.fitHeight,
                width: 600.w,
                height: 400.h,
              ),
            ],
          ),
          20.verticalSpace,
          Container(
            width: double.infinity,
            // height: 165,
            // padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.r)),
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.secondaryText,
                      blurRadius: 20,
                      offset: Offset(0, -2))
                ]),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      buttonName: 'Back to home',
                      colorShadow: AppColors.colorShadow,
                      backgroundColorButton: AppColors.primaryButton,
                      borderColor: Colors.transparent,
                      textColor: Colors.white,
                      function: () {
                        socketProvider.disconnectSocketServer();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => HomePage()));
                      },
                      // height: 60,

                      // width: 350,
                      fontSize: 18.sp),
                  15.verticalSpace,
                  GestureDetector(
                    onTap: () {},
                    child: CustomText(
                        message: 'Take a screenshot',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryButton),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

String formatDate(String? date) {
  if (date != null && date != '') {
    DateTime serverDateTime = DateTime.parse(date!).toLocal();
    String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
    return formattedDate;
  }
  return '';
}

String formatTime(String? time) {
  if (time != '' && time != null) {
    DateTime serverDateTime = DateTime.parse(time!).toLocal();
    String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
    return formattedTime;
  }
  return '';
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
  if (result.toString() == "1.0") {
    return 'Present';
  } else if (result.toString() == "0.5") {
    return 'Late';
  } else if (result.toString() == "0.0") {
    return 'Absence';
  } else {
    return 'Absence';
  }
}
