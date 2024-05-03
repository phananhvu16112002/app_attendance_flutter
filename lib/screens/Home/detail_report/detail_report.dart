import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/report_data_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelForAPI_ReportPage_Version1/report_model.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailReport extends StatefulWidget {
  DetailReport({super.key, required this.reportModel});
  final ReportModel reportModel;

  @override
  State<DetailReport> createState() => _DetailReportState();
}

class _DetailReportState extends State<DetailReport> {
  @override
  Widget build(BuildContext context) {
    print(widget.reportModel.reportID);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, size: 23.sp, color: Colors.white)),
          backgroundColor: AppColors.primaryButton,
          title: Text(
            'Detail Report',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23.sp),
          ),
          actions: [
            Image.asset(
              'assets/icons/garbage.png',
              width: 30.w,
              height: 30.h,
            ),
          ],
        ),
        body: FutureBuilder(
            future: API(context).viewReport(widget.reportModel.reportID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  ReportData? reportData = snapshot.data;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.verticalSpace,
                          CustomText(
                              message:
                                  AppLocalizations.of(context)?.field_course ??
                                      'Class',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          5.verticalSpace,
                          customCard(widget.reportModel.courseCourseName, 410,
                              50, 2, 20.h),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomText(
                              message: AppLocalizations.of(context)
                                      ?.field_lecturer ??
                                  'Lecturer',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          5.verticalSpace,
                          customCard(
                              widget.reportModel.teacherName, 410, 50, 2, 20.h),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.field_course_room ??
                                          'Room',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  5.verticalSpace,
                                  Container(
                                    width: 140.w,
                                    height: 50.h,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(139, 238, 246, 254),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border(
                                            top: BorderSide(
                                                color: AppColors.secondaryText),
                                            left: BorderSide(
                                                color: AppColors.secondaryText),
                                            right: BorderSide(
                                                color: AppColors.secondaryText),
                                            bottom: BorderSide(
                                                color:
                                                    AppColors.secondaryText))),
                                    child: Center(
                                      child: Text(
                                          widget.reportModel.classesRoomNumber,
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(108, 0, 0, 0),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.field_course_shift ??
                                          'Shift',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  Container(
                                    width: 140.w,
                                    height: 50.h,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(139, 238, 246, 254),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border(
                                            top: BorderSide(
                                                color: AppColors.secondaryText),
                                            left: BorderSide(
                                                color: AppColors.secondaryText),
                                            right: BorderSide(
                                                color: AppColors.secondaryText),
                                            bottom: BorderSide(
                                                color:
                                                    AppColors.secondaryText))),
                                    child: Center(
                                      child: Text(
                                          '${widget.reportModel.classesShiftNumber}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(108, 0, 0, 0),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.created_date ??
                                          'Date Report',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  5.verticalSpace,
                                  Container(
                                    width: 140.w,
                                    height: 50.h,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(139, 238, 246, 254),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border(
                                            top: BorderSide(
                                                color: AppColors.secondaryText),
                                            left: BorderSide(
                                                color: AppColors.secondaryText),
                                            right: BorderSide(
                                                color: AppColors.secondaryText),
                                            bottom: BorderSide(
                                                color:
                                                    AppColors.secondaryText))),
                                    child: Center(
                                      child: Text(
                                          '${formatDate(widget.reportModel.createdAt)}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(108, 0, 0, 0),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.return_date ??
                                          'Date Response',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  5.verticalSpace,
                                  Container(
                                    width: 140.w,
                                    height: 50.h,
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(139, 238, 246, 254),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border(
                                            top: BorderSide(
                                                color: AppColors.secondaryText),
                                            left: BorderSide(
                                                color: AppColors.secondaryText),
                                            right: BorderSide(
                                                color: AppColors.secondaryText),
                                            bottom: BorderSide(
                                                color:
                                                    AppColors.secondaryText))),
                                    child: Center(
                                      child: reportData!.feedBack != null
                                          ? Text(
                                              '${formatDate(reportData!.feedBack!.createdAtFeedBack)}',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    108, 0, 0, 0),
                                              ))
                                          : const Text(''),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.status ??
                                          'Status',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  5.verticalSpace,
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 15.h),
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(139, 238, 246, 254),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border(
                                            top: BorderSide(
                                                color: AppColors.secondaryText),
                                            left: BorderSide(
                                                color: AppColors.secondaryText),
                                            right: BorderSide(
                                                color: AppColors.secondaryText),
                                            bottom: BorderSide(
                                                color:
                                                    AppColors.secondaryText))),
                                    child: Center(
                                      child: Text('${reportData.status}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: getColor(
                                                widget.reportModel.status),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.time_response ??
                                          'Time Response',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  5.verticalSpace,
                                  Container(
                                    width: 160.w,
                                    height: 50.h,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.w, vertical: 10.h),
                                    decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(139, 238, 246, 254),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border(
                                            top: BorderSide(
                                                color: AppColors.secondaryText),
                                            left: BorderSide(
                                                color: AppColors.secondaryText),
                                            right: BorderSide(
                                                color: AppColors.secondaryText),
                                            bottom: BorderSide(
                                                color:
                                                    AppColors.secondaryText))),
                                    child: Center(
                                      child: reportData.feedBack != null
                                          ? Text(
                                              '${formatTime(reportData.feedBack!.createdAtFeedBack)}',
                                              style: TextStyle(
                                                fontSize: 13.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    108, 0, 0, 0),
                                              ))
                                          : const Text(''),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomText(
                              message:
                                  AppLocalizations.of(context)?.problem_type ??
                                      'Type of problem',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          SizedBox(
                            height: 5.h,
                          ),
                          customCard('${reportData.problem}', 410, 50, 2, 20.h),
                          SizedBox(
                            height: 10.h,
                          ),
                          CustomText(
                              message: AppLocalizations.of(context)?.message ??
                                  'Message',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          SizedBox(
                            height: 5.h,
                          ),
                          customCard(
                              reportData.message ?? '', 410, 150, 10, 20.h),
                          10.verticalSpace,
                          CustomText(
                              message: AppLocalizations.of(context)
                                      ?.problem_evidence ??
                                  'Evidence of problem',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          5.verticalSpace,
                          reportData.reportImage != null
                              ? reportData.reportImage!.length >= 2
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: reportData.reportImage
                                                ?.map((e) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.network(
                                                  e!.imageURL,
                                                  width: 200.w,
                                                  height: 200.h,
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }).toList() ??
                                            [],
                                      ),
                                    )
                                  : Center(
                                      child: Image.network(
                                        reportData
                                                .reportImage?.first?.imageURL ??
                                            '',
                                        width: 150.w,
                                        height: 150.h,
                                      ),
                                    )
                              : Center(
                                  child: CustomText(
                                      message: 'Error',
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryText),
                                ),
                          10.verticalSpace,
                        ],
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.hasError}'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return const Text('alo alo');
            }));
  }

  Container customCard(String message, double width, double height,
      int maxLines, double vertical) {
    return Container(
      width: double.infinity,
      // height: height,
      padding: EdgeInsets.symmetric(vertical: vertical),
      decoration: const BoxDecoration(
          color: Color.fromARGB(139, 238, 246, 254),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(
              top: BorderSide(color: AppColors.secondaryText),
              left: BorderSide(color: AppColors.secondaryText),
              right: BorderSide(color: AppColors.secondaryText),
              bottom: BorderSide(color: AppColors.secondaryText))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Text(
          message,
          style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color.fromARGB(108, 0, 0, 0)),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Color getColor(String status) {
    if (status == 'Approved') {
      return AppColors.textApproved;
    } else if (status == 'Denied') {
      return AppColors.importantText;
    } else if (status == 'Pending') {
      return AppColors.textPending;
    } else {
      return AppColors.importantText;
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
      DateTime serverDateTime = DateTime.parse(time).toLocal();
      String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
      return formattedTime;
    }
    return '';
  }
}
