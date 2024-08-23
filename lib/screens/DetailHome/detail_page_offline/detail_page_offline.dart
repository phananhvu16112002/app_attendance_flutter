import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/data_offline.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DetailPageOffline extends StatefulWidget {
  const DetailPageOffline({super.key, required this.classesStudent});
  final ClassesStudent classesStudent;

  @override
  State<DetailPageOffline> createState() => _DetailPageOfflineState();
}

class _DetailPageOfflineState extends State<DetailPageOffline> {
  late ClassesStudent classes;
  late Box<DataOffline> dataOfflineBox;
  late DataOffline? dataOffline;
  final ScrollController _controller = ScrollController();
  XFile? file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classes = widget.classesStudent;
    openBox();
    getImage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            customAppBar(),
            if (dataOfflineBox.length != 0)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: dataOfflineBox.length,
                          shrinkWrap: true,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 10, right: 10),
                                child: customCard(
                                  formatTime(dataOffline?.startTime) ?? '',
                                  formatTime(dataOffline?.endTime) ?? '',
                                  formatDate(
                                      dataOffline?.dateAttendanced ?? ''),
                                  // '',
                                  formatTime(dataOffline?.dateAttendanced) ??
                                      '',
                                  'Pending',
                                  dataOffline?.location ?? '',
                                ));
                          }),
                    ],
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  width: 250.w,
                  height: 350.h,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        Opacity(
                          opacity: 0.3,
                          child: Image.asset('assets/images/nodata.png'),
                        ),
                        5.verticalSpace,
                        CustomText(
                            message: "No take attendance detail pending",
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryText.withOpacity(0.5))
                      ],
                    ),
                  ),
                ),
              ),
            // customCard(classes.startTime, classes.endTime, classes.endTime,
            //     classes.endTime, 'Present', 'location')
          ],
        ));
  }

  // Container customCard(
  //   String startTime,
  //   String endTime,
  //   String date,
  //   String timeAttendance,
  //   String status,
  //   String location,
  // ) {
  //   return Container(
  //     width: double.infinity,
  //     // height: location.isNotEmpty
  //     //     ? MediaQuery.of(context).size.width * 0.65
  //     //     : MediaQuery.of(context).size.width * 0.50,
  //     padding: EdgeInsets.symmetric(vertical: 15.h),
  //     decoration:  BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(Radius.circular(10.r)),
  //         boxShadow: [
  //           BoxShadow(
  //               color: Color.fromARGB(195, 190, 188, 188),
  //               blurRadius: 5.0,
  //               offset: Offset(2.0, 1.0))
  //         ]),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         CustomText(
  //             message: date.toString(),
  //             fontSize: 16.sp,
  //             fontWeight: FontWeight.w600,
  //             color: AppColors.primaryText),
  //        2.verticalSpace,
  //         Container(
  //           height: 1.h,
  //           width: double.infinity,
  //           color: const Color.fromARGB(105, 190, 188, 188),
  //         ),
  //         5.verticalSpace,
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Container(
  //               // width: 220,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   customRichText(
  //                       'Start Time: ',
  //                       startTime,
  //                       FontWeight.w600,
  //                       FontWeight.w500,
  //                       AppColors.primaryText,
  //                       AppColors.primaryText),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   customRichText(
  //                       'End Time: ',
  //                       endTime,
  //                       FontWeight.w600,
  //                       FontWeight.w500,
  //                       AppColors.primaryText,
  //                       AppColors.primaryText),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   customRichText(
  //                       'Location: ',
  //                       location,
  //                       FontWeight.w600,
  //                       FontWeight.w500,
  //                       AppColors.primaryText,
  //                       AppColors.primaryText),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   customRichText(
  //                       'Time Attendance: ',
  //                       timeAttendance.toString(),
  //                       FontWeight.w600,
  //                       FontWeight.w500,
  //                       AppColors.primaryText,
  //                       AppColors.primaryText),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   customRichText(
  //                       'Status: ',
  //                       status,
  //                       FontWeight.w600,
  //                       FontWeight.w500,
  //                       AppColors.primaryText,
  //                       getColorBasedOnStatus(status)),
  //                   const SizedBox(
  //                     width: 10,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               margin: const EdgeInsets.only(right: 10, top: 10),
  //               height: 130,
  //               width: 130,
  //               child: file != null
  //                   ? Image.file(
  //                       File(file!.path),
  //                     )
  //                   : Container(),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                      5.verticalSpace,
                      customRichText(
                        'End Time: ',
                        endTime,
                        FontWeight.w600,
                        FontWeight.w500,
                        AppColors.primaryText,
                        AppColors.primaryText,
                      ),
                      5.verticalSpace,
                      customRichText(
                        'Location: ',
                        location,
                        FontWeight.w600,
                        FontWeight.w500,
                        AppColors.primaryText,
                        AppColors.primaryText,
                      ),
                      5.verticalSpace,
                      customRichText(
                        'Time Attendance: ',
                        timeAttendance.toString(),
                        FontWeight.w600,
                        FontWeight.w500,
                        AppColors.primaryText,
                        AppColors.primaryText,
                      ),
                      5.verticalSpace,
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
                Expanded(
                  child: Container(
                    // margin: EdgeInsets.only(right: 10.w, top: 10.h),
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
                ),
              ],
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
                        classes.courseName,
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
                                message: '${classes.courseID} ',
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
                                message: '${classes.roomNumber} ',
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
                                message: '${classes.shiftNumber} ',
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
                            message: '${classes.teacherName} ',
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

  String formatDate(String? date) {
    if (date != null || date != "") {
      DateTime serverDateTime = DateTime.parse(date!);
      String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
      return formattedDate;
    }
    return '';
  }

  String formatTime(String? time) {
    if (time != null || time != "") {
      DateTime serverDateTime = DateTime.parse(time!);
      String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
      return formattedTime;
    }
    return '';
  }
}
