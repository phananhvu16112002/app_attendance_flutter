import 'dart:io';

import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ClassesStudent.dart';
import 'package:attendance_system_nodejs/models/DataOffline.dart';
import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
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
        appBar: customAppbar(),
        body: _builBody());
  }

  Widget _builBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: dataOfflineBox.length != 0
          ? ListView.builder(
              itemCount: dataOfflineBox.length,
              shrinkWrap: true,
              controller: _controller,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding:
                        const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                    child: customCard(
                      'startTime',
                      'endTime',
                      'date',
                      dataOffline!.dateAttendanced,
                      'Pending',
                      dataOffline!.location,
                    ));
              })
          : Center(
              child: Container(
                width: 220,
                height: 350,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset('assets/images/nodata.png'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomText(
                          message: "No take attendance detail pending",
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText.withOpacity(0.5))
                    ],
                  ),
                ),
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
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: location.isNotEmpty
          ? MediaQuery.of(context).size.width * 0.65
          : MediaQuery.of(context).size.width * 0.50,
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
        mainAxisAlignment: MainAxisAlignment.center,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: Container(
                  width: 220,
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
                height: 130,
                width: 130,
                child: file != null
                    ? Image.file(
                        File(file!.path),
                      )
                    : Container(),
              ),
            ],
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
          fontSize: 15,
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

  PreferredSize customAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(120),
      child: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back,
                color: Colors.white), // Thay đổi icon và màu sắc tùy ý
          ),
        ),
        backgroundColor: AppColors.colorAppbar,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 35, bottom: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: CustomText(
                    message: classes.courseName,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Row(
                children: [
                  CustomText(
                      message: 'CourseID: ${classes.courseID}',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(height: 10, width: 1, color: Colors.white),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(
                      message: 'Room: ${classes.roomNumber}',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(height: 10, width: 1, color: Colors.white),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(
                      message: 'Shift: ${classes.shiftNumber}',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              CustomText(
                  message: 'Lectuer: ${classes.teacherName}',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ],
          ),
        ),
      ),
    );
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
}
