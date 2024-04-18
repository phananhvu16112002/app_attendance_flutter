import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_form_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/report_data_for_detail_page.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/edit_report_page/edit_report_page.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/report_attendance/report_attendance.dart';
import 'package:attendance_system_nodejs/screens/Home/attendanceform_page/attendance_form_page.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailPageBody extends StatefulWidget {
  DetailPageBody({super.key, required this.classesStudent});
  // final StudentClasses studentClasses;
  final ClassesStudent classesStudent;

  @override
  State<DetailPageBody> createState() => _DetailPageBodyState();
}

class _DetailPageBodyState extends State<DetailPageBody> {
  bool activeTotal = true;
  bool activePresent = false;
  bool activeAbsent = false;
  bool activeLate = false;
  // late StudentClasses studentClasses;
  late ClassesStudent classesStudent;
  int totalPresence = 0;
  int totalAbsence = 0;
  int totalLate = 0;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    classesStudent = widget.classesStudent;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceFormDataForDetailPageProvider =
        Provider.of<AttendanceFormDataForDetailPageProvider>(context,
            listen: false);
    final socketServerDataProvider =
        Provider.of<SocketServerProvider>(context, listen: false);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(Duration.zero, () {});
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                customAppBar(socketServerDataProvider),
                FutureBuilder(
                  future: API(context)
                      .getAttendanceDetailForDetailPage(classesStudent.classID),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Column(
                        children: [
                          customLoading(),
                          10.verticalSpace,
                          customLoading(),
                          10.verticalSpace,
                          customLoading()
                        ],
                      ));
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height,
                          color: AppColors.cardAttendance,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                10.verticalSpace,
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.r)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: AppColors.secondaryText,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 0.0))
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              activeAbsent = false;
                                              activeLate = false;
                                              activePresent = false;
                                              activeTotal = true;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: activeTotal
                                                  ? AppColors.cardAttendance
                                                  : Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r)),
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                message:
                                                    'Total: ${classesStudent.total.ceil()}',
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
                                              activeAbsent = false;
                                              activeLate = false;
                                              activePresent = true;
                                              activeTotal = false;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: activePresent
                                                  ? const Color.fromARGB(
                                                      94, 137, 210, 64)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r)),
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                message:
                                                    'Present: ${classesStudent.totalPresence.ceil()}',
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
                                              activeAbsent = true;
                                              activeLate = false;
                                              activePresent = false;
                                              activeTotal = false;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: activeAbsent
                                                  ? const Color.fromARGB(
                                                      216, 219, 87, 87)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r)),
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                message:
                                                    'Absent: ${classesStudent.totalAbsence.ceil()}',
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
                                              activeAbsent = false;
                                              activeLate = true;
                                              activePresent = false;
                                              activeTotal = false;
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 10.w),
                                            decoration: BoxDecoration(
                                              color: activeLate
                                                  ? const Color.fromARGB(
                                                      231, 232, 156, 63)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.r)),
                                            ),
                                            child: Center(
                                              child: CustomText(
                                                message:
                                                    'Late: ${classesStudent.totalLate.ceil()}',
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
                                ),
                                10.verticalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    StreamBuilder(
                                        stream: socketServerDataProvider
                                            .attendanceFormStream,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data != null) {
                                              AttendanceFormDataForDetailPage?
                                                  data = snapshot.data;
                                              Future.delayed(Duration.zero, () {
                                                attendanceFormDataForDetailPageProvider
                                                    .setAttendanceFormData(
                                                        data!);
                                              });
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.w, right: 10.w),
                                                child: customCardStream(
                                                    formatTime(data!.startTime),
                                                    formatTime(data.endTime),
                                                    formatDate(data.dateOpen),
                                                    '',
                                                    getResult(0),
                                                    '',
                                                    '',
                                                    data.status,
                                                    data,
                                                    attendanceFormDataForDetailPageProvider,
                                                    null),
                                              );
                                            } else {
                                              return const Text('Data is null');
                                            }
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error:${snapshot.error}');
                                          } else {
                                            return Container();
                                          }
                                        }),
                                    10.verticalSpace,
                                    ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      itemCount: snapshot.data!.length,
                                      shrinkWrap: true,
                                      controller: _controller,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var data = snapshot.data![index];
                                        if ((activePresent &&
                                                data.result ==
                                                    1) || // Lọc theo trạng thái Present
                                            (activeAbsent &&
                                                data.result ==
                                                    0) || // Lọc theo trạng thái Absent
                                            (activeLate &&
                                                data.result ==
                                                    0.5) || // Lọc theo trạng thái Late
                                            activeTotal) {
                                          // Hiển thị tất cả dữ liệu khi trạng thái là All
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 15.h,
                                                left: 10.w,
                                                right: 10.w),
                                            child: customCard(
                                              formatTime(data
                                                  .attendanceForm.startTime),
                                              formatTime(
                                                  data.attendanceForm.endTime),
                                              formatDate(
                                                  data.attendanceForm.dateOpen),
                                              data.dateAttendanced != ''
                                                  ? formatTime(
                                                      data.dateAttendanced)
                                                  : 'null',
                                              getResult(data.result),
                                              data.dateAttendanced != ''
                                                  ? data.location
                                                  : 'null',
                                              data.url ?? '',
                                              data.attendanceForm.status,
                                              data.attendanceForm,
                                              attendanceFormDataForDetailPageProvider,
                                              data.report,
                                            ),
                                          );
                                        } else {
                                          return SizedBox
                                              .shrink(); // Ẩn các mục không phù hợp với trạng thái được chọn
                                        }
                                      },
                                    ),
                                    25.verticalSpace
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }
                    return const Text('Data Not Avalible');
                  },
                ),
                //  SizedBox(
                //   height: 50,
                // ),
              ],
            ),
          ),
        ),
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

  Container customCard(
    String startTime,
    String endTime,
    String date,
    String timeAttendance,
    String status,
    String location,
    String? url,
    bool statusForm,
    AttendanceFormDataForDetailPage attendanceFormForDetailPage,
    AttendanceFormDataForDetailPageProvider
        attendanceFormDataForDetailPageProvider,
    ReportData? reportData,
  ) {
    DateTime endTimeParse =
        DateTime.parse(attendanceFormForDetailPage.endTime).toLocal();
    DateTime dateParse =
        DateTime.parse(attendanceFormForDetailPage.dateOpen).toLocal();
    var now = DateTime.now();
    var tempDateParse =
        DateTime(dateParse.year, dateParse.month, dateParse.day);
    var tempNowParse = DateTime(now.year, now.month, now.day);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.r)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(195, 190, 188, 188),
            blurRadius: 5.0,
            offset: Offset(2.0, 1.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CustomText(
              message: date.toString(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          5.verticalSpace,
          Container(
            height: 1.h,
            width: double.infinity,
            color: Color.fromARGB(105, 190, 188, 188),
          ),
          5.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(width: 10.w),
                Container(
                  // margin: EdgeInsets.only(right: 10.w, top: 10.h),
                  height: 120.h,
                  width: 120.w,
                  child: url == null || url.isEmpty || url == ''
                      ? Image.asset('assets/images/logo.png')
                      : Image.network(url),
                ),
              ],
            ),
          ),
          5.verticalSpace,
          Container(
            height: 1.h,
            width: double.infinity,
            color: Color.fromARGB(105, 190, 188, 188),
          ),
          15.verticalSpace,
          if (statusForm &&
              now.isBefore(endTimeParse) &&
              tempDateParse.isAtSameMomentAs(tempNowParse) &&
              timeAttendance == "null")
            InkWell(
              onTap: () {
                attendanceFormDataForDetailPageProvider
                    .setAttendanceFormData(attendanceFormForDetailPage);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AttendanceFormPage(
                      classesStudent: classesStudent,
                    ),
                    transitionDuration: const Duration(milliseconds: 1000),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var curve = Curves.easeInOutCubic;
                      var tween =
                          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                              .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Center(
                child: CustomText(
                  message: 'Take Attendance',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryButton,
                ),
              ),
            )
          else if (reportData == null || !reportData.checkNew)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ReportAttendance(
                      classesStudent: classesStudent,
                      attendanceFormDataForDetailPage:
                          attendanceFormForDetailPage,
                    ),
                    transitionDuration: const Duration(milliseconds: 1000),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var curve = Curves.easeInOutCubic;
                      var tween =
                          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                              .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Center(
                child: CustomText(
                  message: 'Report',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.importantText,
                ),
              ),
            )
          else
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        EditReportPage(
                      classesStudent: classesStudent,
                      reportData: reportData,
                    ),
                    transitionDuration: const Duration(milliseconds: 1000),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var curve = Curves.easeInOutCubic;
                      var tween =
                          Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                              .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Center(
                child: CustomText(
                  message: 'Edit',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.importantText,
                ),
              ),
            )
        ],
      ),
    );
  }

  Container customCardStream(
    String startTime,
    String endTime,
    String date,
    String timeAttendance,
    String status,
    String location,
    String url,
    bool statusForm,
    AttendanceFormDataForDetailPage? attendanceFormForDetailPage,
    AttendanceFormDataForDetailPageProvider
        attendanceFormDataForDetailPageProvider,
    ReportData? reportData,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(195, 190, 188, 188),
            blurRadius: 5.0,
            offset: Offset(2.0, 1.0),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomText(
            message: date.toString(),
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
          5.verticalSpace,
          Container(
            height: 1.h,
            width: double.infinity,
            color: Color.fromARGB(105, 190, 188, 188),
          ),
          5.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(width: 10.w),
                Container(
                  margin: EdgeInsets.only(right: 10.w, top: 10.h),
                  height: 100.h,
                  width: 100.w,
                  child: url.isEmpty || url == ''
                      ? Image.asset('assets/images/logo.png')
                      : Image.network(url),
                ),
              ],
            ),
          ),
          5.verticalSpace,
          Container(
            height: 1.h,
            width: double.infinity,
            color: Color.fromARGB(105, 190, 188, 188),
          ),
          15.verticalSpace,
          InkWell(
            onTap: () {
              attendanceFormDataForDetailPageProvider
                  .setAttendanceFormData(attendanceFormForDetailPage!);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AttendanceFormPage(
                    classesStudent: classesStudent,
                  ),
                  transitionDuration: Duration(milliseconds: 1000),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var curve = Curves.easeInOutCubic;
                    var tween = Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                        .chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            child: CustomText(
              message: 'Take Attendance',
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryButton,
            ),
          ),
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
    } else if (status.contains('Late')) {
      return const Color.fromARGB(231, 196, 123, 34);
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

  Widget customLoading() {
    return Container(
      width: double.infinity,
      // height: 220,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(195, 190, 188, 188),
                blurRadius: 5.0,
                offset: Offset(2.0, 1.0))
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        child: Column(
          children: [
            // SizedBox(
            //   height: 2.h,
            // ),
            Shimmer.fromColors(
                baseColor: const Color.fromARGB(78, 158, 158, 158),
                highlightColor: const Color.fromARGB(146, 255, 255, 255),
                child:
                    Container(width: 300.w, height: 10.h, color: Colors.white)),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: Container(
                    width: 220.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 30.w,
                                    height: 10.h,
                                    color: Colors.white)),
                            SizedBox(
                              width: 2.w,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 110.w,
                                    height: 10.h,
                                    color: Colors.white)),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 30.w,
                                    height: 10.h,
                                    color: Colors.white)),
                            const SizedBox(
                              width: 2,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 100.w,
                                    height: 10.h,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 50.w,
                                    height: 10.h,
                                    color: Colors.white)),
                            SizedBox(
                              width: 2.w,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 140.w,
                                    height: 10.h,
                                    color: Colors.white)),
                          ],
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 40.w,
                                    height: 10.h,
                                    color: Colors.white)),
                            SizedBox(
                              width: 2.w,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 150.w,
                                    height: 10.h,
                                    color: Colors.white)),
                          ],
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 50.w,
                                    height: 10.h,
                                    color: Colors.white)),
                            SizedBox(
                              width: 2.w,
                            ),
                            Shimmer.fromColors(
                                baseColor:
                                    const Color.fromARGB(78, 158, 158, 158),
                                highlightColor:
                                    const Color.fromARGB(146, 255, 255, 255),
                                child: Container(
                                    width: 150.w,
                                    height: 10.h,
                                    color: Colors.white)),
                          ],
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                      ],
                    ),
                  ),
                ),
                Shimmer.fromColors(
                    baseColor: const Color.fromARGB(78, 158, 158, 158),
                    highlightColor: const Color.fromARGB(146, 255, 255, 255),
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5.r))),
                    )),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Container(
              height: 1.h,
              width: 405.w,
              color: const Color.fromARGB(105, 190, 188, 188),
            ),
            SizedBox(
              height: 20.h,
            ),
            Shimmer.fromColors(
                baseColor: const Color.fromARGB(78, 158, 158, 158),
                highlightColor: const Color.fromARGB(146, 255, 255, 255),
                child:
                    Container(width: 100.w, height: 10.h, color: Colors.white))
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
}
