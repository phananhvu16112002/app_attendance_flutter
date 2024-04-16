import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelForAPI_ReportPage_Version1/report_model.dart';
import 'package:attendance_system_nodejs/screens/Home/detail_report/detail_report.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String getPathStatus(String status) {
    if (status == 'Approved') {
      return 'assets/icons/successfully.png';
    } else if (status == 'Pending') {
      return 'assets/icons/pending.png';
    } else {
      return 'assets/icons/cancel.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(Duration(seconds: 3), () {
          setState(() {});
        });
      },
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 247, 245, 245),
          appBar: AppBar(
              backgroundColor: Colors.white,
              shadowColor: Colors.transparent,
              title: Text(
                'Reports',
                style: TextStyle(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              ),
              actions: [
                Image.asset(
                  'assets/icons/garbage.png',
                  width: 25.w,
                  height: 25.h,
                ),
              ]),
          body: FutureBuilder(
              future: API(context).getReportDataForStudent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    List<ReportModel>? data = snapshot.data;
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: data!.length,
                        itemBuilder: ((context, index) {
                          ReportModel reportModel = data[index];

                          print(
                              DateTime.parse(reportModel.createdAt).toLocal());
                          print(reportModel.feedbackCreatedAt);

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => DetailReport(
                                              reportModel: reportModel,
                                            )));
                              },
                              child: cardReport(
                                  getPathStatus(reportModel.status),
                                  reportModel.courseCourseName,
                                  reportModel.teacherName,
                                  reportModel.classesRoomNumber,
                                  reportModel.classesShiftNumber.toString(),
                                  reportModel.status,
                                  formatDate(reportModel.createdAt),
                                  reportModel.courseTotalWeeks.toString(),
                                  formatDate(reportModel.feedbackCreatedAt),
                                  formatTime(reportModel.feedbackCreatedAt)),
                            ),
                          );
                        }));
                  }
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
                return Text('Alo ALo');
              })),
    );
  }

  Widget cardReport(
      String pathStatus,
      String className,
      String lectuerName,
      String room,
      String shift,
      String status,
      String dateReport,
      String week,
      String returnDate,
      String timeReport) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
          color: AppColors.cardReport,
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          boxShadow: [
            BoxShadow(
                color: AppColors.secondaryText,
                blurRadius: 5.0,
                offset: Offset(0.0, 0.0))
          ]),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              pathStatus,
              width: 35.w,
              height: 35.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customRichText(
                      'Class: ',
                      className,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                  10.verticalSpace,
                  customRichText(
                      'Lectuer: ',
                      lectuerName,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                  10.verticalSpace,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customRichText(
                          'Room: ',
                          room,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      SizedBox(
                        width: 10.w,
                      ),
                      customRichText(
                          'Shift: ',
                          shift,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                    ],
                  ),
                  10.verticalSpace,
                  customRichText(
                      'Status: ',
                      status,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      getColorBasedOnStatus(status)),
                  10.verticalSpace,
                  Row(
                    children: [
                      customRichText(
                          'Date: ',
                          dateReport,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      SizedBox(
                        width: 10.w,
                      ),
                      customRichText(
                          'Week: ',
                          week,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                    ],
                  ),
                  10.verticalSpace,
                  customRichText(
                      'Return Date: ',
                      returnDate,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                  const SizedBox(
                    height: 10,
                  ),
                  customRichText(
                      'Time: ',
                      timeReport,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                ],
              ),
            ),
            Container(
              width: 1.5.w,
              padding: EdgeInsets.symmetric(vertical: 100.h),
              color: AppColors.primaryText,
            ),
            SizedBox(
              width: 10.w,
            ),
            CustomText(
                message: 'Detail',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryButton)
          ],
        ),
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
          fontSize: 15.sp,
          color: colorTextTitle,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: 15.sp,
          color: colorTextMessage,
        ),
      ),
    ]));
  }

  Color getColorBasedOnStatus(String status) {
    if (status.contains('Approved')) {
      return AppColors.textApproved;
    } else if (status.contains('Pending')) {
      return const Color.fromARGB(231, 196, 123, 34);
    } else if (status.contains('Denied')) {
      return AppColors.importantText;
    } else {
      // Mặc định hoặc trường hợp khác
      return AppColors.primaryText;
    }
  }

  String formatDate(String? date) {
    if (date != null && date != '') {
      DateTime serverDateTime = DateTime.parse(date).toLocal();
      String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
      return formattedDate;
    }
    return '';
  }

  String formatTime(String? time) {
    if (time != null && time != '') {
      DateTime serverDateTime = DateTime.parse(time!).toLocal();
      String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
      return formattedTime;
    }
    return '';
  }
}
// cardReport(
//                   'assets/icons/successfully.png',
//                   'Quản trị hệ thống thông tin doanh nghiệp',
//                   'Mai Van Manh',
//                   'A0503',
//                   '5',
//                   'Approved',
//                   '20/11/2023',
//                   '10',
//                   '21/11/2023',
//                   '11:43 AM'),
//               const SizedBox(
//                 height: 10,
//               ),
//               cardReport(
//                   'assets/icons/pending.png',
//                   'Quản trị hệ thống thông tin doanh nghiệp',
//                   'Mai Van Manh',
//                   'A0503',
//                   '5',
//                   'Pending',
//                   '20/11/2023',
//                   '10',
//                   '21/11/2023',
//                   '11:43 AM'),
//               const SizedBox(
//                 height: 10,
//               ),
//               cardReport(
//                   'assets/icons/cancel.png',
//                   'Quản trị hệ thống thông tin doanh nghiệp',
//                   'Mai Van Manh',
//                   'A0503',
//                   '5',
//                   'Denied',
//                   '20/11/2023',
//                   '10',
//                   '21/11/2023',
//                   '11:43 AM'),
//               const SizedBox(
//                 height: 10,
//               ),
//               cardReport(
//                   'assets/icons/cancel.png',
//                   'Quản trị hệ thống thông tin doanh nghiệp',
//                   'Mai Van Manh',
//                   'A0503',
//                   '5',
//                   'Denied',
//                   '20/11/2023',
//                   '10',
//                   '21/11/2023',
//                   '11:43 AM'),