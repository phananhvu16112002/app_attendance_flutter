import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/classroom/classroom.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/services/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class Classroom extends StatefulWidget {
  const Classroom({super.key, required this.classesStudent});
  final ClassesStudent classesStudent;

  @override
  State<Classroom> createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom> {
  late ClassesStudent classesStudent;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classesStudent = widget.classesStudent;
  }

  @override
  Widget build(BuildContext context) {
    SocketServerProvider socketServerProvider =
        Provider.of<SocketServerProvider>(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customAppBar(socketServerProvider),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                        message: 'Lecturer',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryButton),
                    5.verticalSpace,
                    Container(
                        width: double.infinity,
                        height: 1.h,
                        color: Colors.black.withOpacity(0.1)),
                    10.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.r),
                              child: Image.asset(
                                'assets/images/avatar.png',
                                width: 45.w,
                                height: 45.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomText(
                                message: classesStudent.teacherName,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryText)
                          ],
                        ),
                        InkWell(
                            onTap: () {}, child: Icon(Icons.message_outlined))
                      ],
                    ),
                    20.verticalSpace,
                    CustomText(
                        message: 'Students',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryButton),
                    5.verticalSpace,
                    Container(
                        width: double.infinity,
                        height: 1.h,
                        color: Colors.black.withOpacity(0.1)),
                    10.verticalSpace,
                    FutureBuilder(
                        future:
                            API(context).getRoommate(classesStudent.classID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            if (snapshot.data != null) {
                              List<ClassRoom>? data = snapshot.data;
                              return data != null && data.isNotEmpty
                                  ? ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: data.length,
                                      itemBuilder: ((context, index) {
                                        ClassRoom classRoom = data[index];

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.r),
                                                  child: Image.asset(
                                                    'assets/images/avatar.png',
                                                    width: 45.w,
                                                    height: 45.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                CustomText(
                                                    message:
                                                        classRoom.studentName ??
                                                            '',
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.primaryText)
                                              ],
                                            ),
                                            InkWell(
                                                onTap: () {},
                                                child: Icon(
                                                    Icons.message_outlined))
                                          ],
                                        );
                                      }),
                                      separatorBuilder: ((context, index) {
                                        return SizedBox(
                                          width: double.infinity,
                                          height: 15.h,
                                        );
                                      }),
                                    )
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
                          return Text('Null');
                        })
                  ],
                ),
              ),
            ),
          )
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
}
