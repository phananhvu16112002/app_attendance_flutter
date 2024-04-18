import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/report_class/report_class.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/services/API.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReportClass extends StatefulWidget {
  const ReportClass({super.key, required this.classesStudent});
  final ClassesStudent classesStudent;

  @override
  State<ReportClass> createState() => _ReportClassState();
}

class _ReportClassState extends State<ReportClass> {
  late ClassesStudent classesStudent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classesStudent = widget.classesStudent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            customAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder(
                        future: API(context)
                            .getReportInClass(classesStudent.classID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              List<ReportModelClass>? data = snapshot.data;
                              return data != null && data.isNotEmpty
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: data.length,
                                      itemBuilder: ((context, index) {
                                        ReportModelClass reportModel =
                                            data[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: () {},
                                            child: cardReport(
                                                getPathStatus(
                                                    reportModel.status ?? ''),
                                                classesStudent.courseName,
                                                classesStudent.teacherName,
                                                classesStudent.roomNumber,
                                                classesStudent.shiftNumber
                                                    .toString(),
                                                reportModel.status ?? '',
                                                formatDate(
                                                    reportModel.createdAt),
                                                classesStudent.totalWeeks
                                                    .toString(),
                                                formatDate(reportModel
                                                        .feedback?.createdAt ??
                                                    ''),
                                                formatTime(reportModel
                                                        .feedback?.createdAt ??
                                                    '')),
                                          ),
                                        );
                                      }))
                                  : Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Opacity(
                                            opacity: 0.3,
                                            child: Image.asset(
                                              'assets/images/nodata.png',
                                              width: 200.w,
                                              height: 200.w,
                                            ),
                                          ),
                                          10.verticalSpace,
                                          CustomText(
                                              message: 'No Report',
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.primaryText
                                                  .withOpacity(0.3))
                                        ],
                                      ),
                                    );
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Text('Alo ALo');
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getPathStatus(String status) {
    if (status == 'Approved') {
      return 'assets/icons/successfully.png';
    } else if (status == 'Pending') {
      return 'assets/icons/pending.png';
    } else {
      return 'assets/icons/cancel.png';
    }
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
              width: 30.w,
              height: 30.h,
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
                      '${AppLocalizations.of(context)?.field_course ?? 'Course'}: ',
                      className,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                  10.verticalSpace,
                  customRichText(
                      '${AppLocalizations.of(context)?.field_lecturer ?? 'Lectuer'}: ',
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
                          '${AppLocalizations.of(context)?.field_course_room ?? 'Room'}: ',
                          room,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      SizedBox(
                        width: 10.w,
                      ),
                      customRichText(
                          '${AppLocalizations.of(context)?.field_course_shift ?? 'Shift'}: ',
                          shift,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                    ],
                  ),
                  10.verticalSpace,
                  customRichText(
                      '${AppLocalizations.of(context)?.status ?? 'Status'}: ',
                      status,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      getColorBasedOnStatus(status)),
                  10.verticalSpace,
                  Row(
                    children: [
                      customRichText(
                          '${AppLocalizations.of(context)?.created_date ?? 'Date'}: ',
                          dateReport,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      SizedBox(
                        width: 10.w,
                      ),
                      10.verticalSpace,
                      customRichText(
                          '${AppLocalizations.of(context)?.day ?? 'Week'}: ',
                          week,
                          FontWeight.bold,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                    ],
                  ),
                  10.verticalSpace,
                  customRichText(
                      '${AppLocalizations.of(context)?.return_date ?? 'Return Date'}: ',
                      returnDate,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                  const SizedBox(
                    height: 10,
                  ),
                  customRichText(
                      '${AppLocalizations.of(context)?.time ?? 'Time'}: ',
                      timeReport,
                      FontWeight.bold,
                      FontWeight.w500,
                      AppColors.primaryText,
                      AppColors.primaryText),
                ],
              ),
            ),
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

  Container customAppBar() {
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
}
