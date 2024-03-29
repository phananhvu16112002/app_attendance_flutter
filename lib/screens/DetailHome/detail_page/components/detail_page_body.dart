import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/attendance_detail.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/attendance_form_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_detail_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_form_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/report_data_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/providers/attendanceDetail_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceForm_data_provider.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/edit_report_page/edit_report_page.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/report_attendance/report_attendance.dart';
import 'package:attendance_system_nodejs/screens/Home/attendanceform_page/attendance_form_page.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class DetailPageBody extends StatefulWidget {
  const DetailPageBody({super.key, required this.classesStudent});
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

  void _scrollDown() {
    _controller.animateTo(_controller.position.maxScrollExtent,
        duration: Duration(seconds: 2), curve: Curves.fastOutSlowIn);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    classesStudent = widget.classesStudent;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final studentClassesDataProvider =
    //     Provider.of<StudentClassesDataProvider>(context, listen: false);
    // StudentClasses? dataStudentClasses = studentClassesDataProvider
    //     .getDataForClass(widget.classesStudent.classID);
    final attendanceFormDataProvider =
        Provider.of<AttendanceFormDataProvider>(context, listen: false);
    final attendanceFormDataForDetailPageProvider =
        Provider.of<AttendanceFormDataForDetailPageProvider>(context,
            listen: false);
    final socketServerDataProvider =
        Provider.of<SocketServerProvider>(context, listen: false);
    // final studentDataProvider =
    //     Provider.of<StudentDataProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              customAppBar(socketServerDataProvider),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                future: API(context)
                    .getAttendanceDetailForDetailPage(classesStudent.classID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
                          customLoading(),
                          const SizedBox(
                            height: 10,
                          ),
                          customLoading(),
                          const SizedBox(
                            height: 10,
                          ),
                          customLoading()
                        ],
                      ),
                    ));
                  } else if (snapshot.hasError) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: AppColors.cardAttendance,
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      // List<AttendanceDetail> attendanceDetail = snapshot.data!;
                      // Future.delayed(Duration.zero, () {
                      //   attendanceDetailDataProvider
                      //       .setAttendanceDetailList(attendanceDetail);
                      // }); // khong can thiet
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: AppColors.cardAttendance,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.secondaryText,
                                          blurRadius: 5.0,
                                          offset: Offset(0.0, 0.0))
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          activeAbsent = false;
                                          activeLate = false;
                                          activePresent = false;
                                          activeTotal = true;
                                        });
                                      },
                                      child: Container(
                                        width: 95,
                                        decoration: BoxDecoration(
                                            color: activeTotal
                                                ? AppColors.cardAttendance
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: CustomText(
                                              message:
                                                  'Total: ${classesStudent.total.ceil()}',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryText),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          activeAbsent = false;
                                          activeLate = false;
                                          activePresent = true;
                                          activeTotal = false;
                                        });
                                      },
                                      child: Container(
                                        width: 95,
                                        decoration: BoxDecoration(
                                            color: activePresent
                                                ? const Color.fromARGB(
                                                    94, 137, 210, 64)
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: CustomText(
                                              message:
                                                  'Present: ${classesStudent.totalPresence.ceil()}',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryText),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          activeAbsent = true;
                                          activeLate = false;
                                          activePresent = false;
                                          activeTotal = false;
                                        });
                                      },
                                      child: Container(
                                        width: 95,
                                        decoration: BoxDecoration(
                                            color: activeAbsent
                                                ? const Color.fromARGB(
                                                    216, 219, 87, 87)
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: CustomText(
                                              message:
                                                  'Absent: ${classesStudent.totalAbsence.ceil()}',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryText),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          activeAbsent = false;
                                          activeLate = true;
                                          activePresent = false;
                                          activeTotal = false;
                                        });
                                      },
                                      child: Container(
                                        width: 95,
                                        decoration: BoxDecoration(
                                            color: activeLate
                                                ? const Color.fromARGB(
                                                    231, 232, 156, 63)
                                                : Colors.white,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Center(
                                          child: CustomText(
                                              message:
                                                  'Late: ${classesStudent.totalLate.ceil()}',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryText),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
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
                                                  .setAttendanceFormData(data!);
                                            });
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      shrinkWrap: true,
                                      controller: _controller,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var data = snapshot.data![index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 15, left: 10, right: 10),
                                          child: customCard(
                                              formatTime(data.attendanceForm
                                                  .startTime), //startTime
                                              formatTime(data.attendanceForm
                                                  .endTime), //Endtime
                                              formatDate(data.attendanceForm
                                                  .dateOpen), //dateOpen
                                              data.dateAttendanced != ''
                                                  ? formatTime(data
                                                      .dateAttendanced) //timeAttendance
                                                  : 'null',
                                              getResult(data
                                                  .result), //Status attendance
                                              data.dateAttendanced != ''
                                                  ? data.location
                                                  : 'null',
                                              data.url, //image
                                              data.attendanceForm
                                                  .status, //status form
                                              data.attendanceForm, //attendanceForm
                                              attendanceFormDataForDetailPageProvider,
                                              data.report), //provider form
                                        );
                                      }),
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
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }

  Container customAppBar(SocketServerProvider socketServerProvider) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: const BoxDecoration(
          color: AppColors.primaryButton,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 300,
                        child: customText(
                            'Phát triển hệ thống thông tin doanh ngiệp',
                            18,
                            FontWeight.w600,
                            Colors.white)),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        CustomText(
                            message: 'CourseID: 520H0303 ',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        const SizedBox(
                          width: 2,
                        ),
                        Container(width: 1, height: 14, color: Colors.white),
                        CustomText(
                            message: ' Room: A0505 ',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        const SizedBox(
                          width: 2,
                        ),
                        Container(width: 1, height: 14, color: Colors.white),
                        CustomText(
                            message: ' Shift: 5 ',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    CustomText(
                        message: 'Lectuer: Mai Van Manh',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white)
                  ],
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
      String url,
      bool statusForm,
      AttendanceFormDataForDetailPage attendanceFormForDetailPage,
      AttendanceFormDataForDetailPageProvider
          attendanceFormDataForDetailPageProvider,
      ReportData? reportData) {
    DateTime endTimeParse = DateTime.parse(attendanceFormForDetailPage.endTime);
    var now = DateTime.now();
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: location.isNotEmpty && location.length >= 50
          ? MediaQuery.of(context).size.height * 0.30
          : MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(195, 190, 188, 188),
                blurRadius: 5.0,
                offset: Offset(2.0, 1.0))
          ]),
      child: Column(
        children: [
          CustomText(
              message: date.toString(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText),
          const SizedBox(
            height: 2,
          ),
          Container(
            height: 1,
            width: 405,
            color: const Color.fromARGB(105, 190, 188, 188),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customRichText(
                          'Start Time: ',
                          startTime,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'End Time: ',
                          endTime,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'Location: ',
                          location,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'Time Attendance: ',
                          timeAttendance.toString(),
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'Status: ',
                          status,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          getColorBasedOnStatus(status)),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, top: 10),
                height: 120,
                width: 120,
                child: url.isEmpty || url == ''
                    ? Image.asset('assets/images/logo.png')
                    : Image.network(url),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 1,
            width: 405,
            color: const Color.fromARGB(105, 190, 188, 188),
          ),
          const SizedBox(
            height: 15,
          ),
          if (statusForm == true &&
              endTimeParse.isBefore(now) &&
              timeAttendance == "")
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
              child: const CustomText(
                  message: 'Take Attendance',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryButton),
            )
          else if (reportData == null)
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
              child: const CustomText(
                  message: 'Report',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.importantText),
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
              child: const CustomText(
                  message: 'Edit',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.importantText),
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
      AttendanceFormDataForDetailPage attendanceFormForDetailPage,
      AttendanceFormDataForDetailPageProvider
          attendanceFormDataForDetailPageProvider,
      ReportData? reportData) {
    DateTime endTimeParse = DateTime.parse(attendanceFormForDetailPage.endTime);
    var now = DateTime.now();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(195, 190, 188, 188),
                blurRadius: 5.0,
                offset: Offset(2.0, 1.0))
          ]),
      child: Column(
        children: [
          CustomText(
              message: date.toString(),
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText),
          const SizedBox(
            height: 2,
          ),
          Container(
            height: 1,
            width: 405,
            color: const Color.fromARGB(105, 190, 188, 188),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customRichText(
                          'Start Time: ',
                          startTime,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'End Time: ',
                          endTime,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'Location: ',
                          location,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'Time Attendance: ',
                          timeAttendance.toString(),
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          AppColors.primaryText),
                      const SizedBox(
                        height: 10,
                      ),
                      customRichText(
                          'Status: ',
                          status,
                          FontWeight.w600,
                          FontWeight.w500,
                          AppColors.primaryText,
                          getColorBasedOnStatus(status)),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, top: 10),
                height: 120,
                width: 120,
                child: url.isEmpty || url == ''
                    ? Image.asset('assets/images/logo.png')
                    : Image.network(url),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 1,
            width: 405,
            color: const Color.fromARGB(105, 190, 188, 188),
          ),
          const SizedBox(
            height: 15,
          ),
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
            child: const CustomText(
                message: 'Take Attendance',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryButton),
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
          fontSize: 14,
          color: colorTextTitle,
        ),
      ),
      TextSpan(
        text: message,
        style: TextStyle(
          fontWeight: fontWeightMessage,
          fontSize: 15,
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

  String formatDate(String date) {
    DateTime serverDateTime = DateTime.parse(date).toLocal();
    String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
    return formattedDate;
  }

  String formatTime(String time) {
    DateTime serverDateTime = DateTime.parse(time).toLocal();
    String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
    return formattedTime;
  }

  Widget customLoading() {
    return Container(
      width: 405,
      height: 220,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(195, 190, 188, 188),
                blurRadius: 5.0,
                offset: Offset(2.0, 1.0))
          ]),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const SizedBox(
              height: 2,
            ),
            Shimmer.fromColors(
                baseColor: const Color.fromARGB(78, 158, 158, 158),
                highlightColor: const Color.fromARGB(146, 255, 255, 255),
                child: Container(width: 300, height: 10, color: Colors.white)),
            const SizedBox(
              height: 2,
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: 220,
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
                                    width: 30,
                                    height: 10,
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
                                    width: 110,
                                    height: 10,
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
                                    width: 30,
                                    height: 10,
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
                                    width: 100,
                                    height: 10,
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
                                    width: 50,
                                    height: 10,
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
                                    width: 140,
                                    height: 10,
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
                                    width: 40,
                                    height: 10,
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
                                    width: 175,
                                    height: 10,
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
                                    width: 50,
                                    height: 10,
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
                                    width: 165,
                                    height: 10,
                                    color: Colors.white)),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Shimmer.fromColors(
                    baseColor: const Color.fromARGB(78, 158, 158, 158),
                    highlightColor: const Color.fromARGB(146, 255, 255, 255),
                    child: Container(
                      width: 125,
                      height: 130,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    )),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              width: 405,
              color: const Color.fromARGB(105, 190, 188, 188),
            ),
            const SizedBox(
              height: 20,
            ),
            Shimmer.fromColors(
                baseColor: const Color.fromARGB(78, 158, 158, 158),
                highlightColor: const Color.fromARGB(146, 255, 255, 255),
                child: Container(width: 100, height: 10, color: Colors.white))
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








// return StreamBuilder(
//                 stream: socketServerDataProvider.attendanceFormStream,
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     if (snapshot.data != null) {
//                       return Text('Data: ${snapshot.data!.dateOpen}');
//                     } else {
//                       return Text('Error:${snapshot.error}');
//                     }
//                   } else {
//                     return Text('---Error');
//                   }
//                 });

