import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelForAPI_ReportPage_Version1/report_model.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/notification_model/notification_model.dart';
import 'package:attendance_system_nodejs/screens/Home/after_attendance_form/after_attendance_form.dart';
import 'package:attendance_system_nodejs/screens/Home/attendanceform_page/attendance_form_page.dart';
import 'package:attendance_system_nodejs/screens/Home/detail_report/detail_report.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: Text(
          AppLocalizations.of(context)?.notification ?? '',
          style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              'assets/icons/garbage.png',
              width: 25.w,
              height: 25.h,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            FutureBuilder(
                future: API(context).getNotification(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      List<NotificationModel>? data = snapshot.data;
                      return data != null && data.isNotEmpty
                          ? ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: data.length,
                              itemBuilder: ((context, index) {
                                NotificationModel notificationModel =
                                    data[index];

                                return InkWell(
                                    onTap: () {
                                      if (notificationModel.type == 'report') {
                                        print('report');
                                      }
                                      if (notificationModel.type ==
                                          'attendance') {
                                        print('attendance');
                                      }
                                    },
                                    child:
                                        _customNotification(notificationModel));
                              }),
                              separatorBuilder: ((context, index) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 10.h,
                                );
                              }),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                      message: AppLocalizations.of(context)
                                              ?.title_no_notification ??
                                          '',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primaryText
                                          .withOpacity(0.3))
                                ],
                              ),
                            );
                    }
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Text('Null');
                })
          ],
        ),
      ),
    );
  }

  Container _customNotification(NotificationModel notificationModel) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      color: notificationModel.seen ? Colors.white : AppColors.cardAttendance,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/bell.png',
              width: 45.w,
              height: 45.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Container(
                child: notificationModel.type == 'attendance'
                    ? customRichText(
                        '${AppLocalizations.of(context)?.title_class_notification ?? ''}: ${notificationModel.course} ',
                        '${AppLocalizations.of(context)?.title_attendance_form_notification ?? ''} ${formatDate(notificationModel.createdAt)} ${formatTime(notificationModel.createdAt)}. ${AppLocalizations.of(context)?.title_please_take_attendance ?? ''}.',
                        '${AppLocalizations.of(context)?.title_lecturer_notitication ?? ''}: ${notificationModel.lecturer}. ',
                        FontWeight.bold,
                        FontWeight.w500,
                        AppColors.primaryText,
                        AppColors.primaryText,
                      )
                    : customRichText(
                        '${AppLocalizations.of(context)?.title_class_notification ?? ''}: ${notificationModel.course} ',
                        '${AppLocalizations.of(context)?.title_report ?? ''} ${notificationModel.report?.reportID ?? 1} ${AppLocalizations.of(context)?.title_was_responsed ?? ''} ${formatDate(notificationModel.createdAt)} ${formatTime(notificationModel.createdAt)}',
                        '${AppLocalizations.of(context)?.title_lecturer_notitication ?? ''}: ${notificationModel.lecturer}. ',
                        FontWeight.bold,
                        FontWeight.w500,
                        AppColors.primaryText,
                        AppColors.primaryText,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  RichText customRichText(
    String titleClass,
    String message,
    String lectuerName,
    FontWeight fontWeightTitle,
    FontWeight fontWeightMessage,
    Color colorTextTitle,
    Color colorTextMessage,
  ) {
    return RichText(
      maxLines: 5,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: titleClass,
            style: TextStyle(
              fontWeight: fontWeightTitle,
              fontSize: 13.sp,
              color: colorTextTitle,
            ),
          ),
          TextSpan(
            text: lectuerName,
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
        ],
      ),
    );
  }
}
