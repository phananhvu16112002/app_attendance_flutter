import 'package:attendance_system_nodejs/common/bases/CustomText.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/ReportDataForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelForAPI_ReportPage_Version1/ReportModel.dart';
import 'package:attendance_system_nodejs/services/API.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailReport extends StatefulWidget {
  const DetailReport({super.key, required this.reportModel});
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
              icon:
                  const Icon(Icons.arrow_back, size: 25, color: Colors.white)),
          backgroundColor: AppColors.primaryButton,
          title: const Text(
            'Detail Report',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
          actions: [
            Image.asset(
              'assets/icons/garbage.png',
              width: 30,
              height: 30,
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
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                              message: 'Class',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          const SizedBox(
                            height: 5,
                          ),
                          customCard(
                              widget.reportModel.courseCourseName, 410, 50, 2),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                              message: 'Lectuer',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          const SizedBox(
                            height: 5,
                          ),
                          customCard(
                              widget.reportModel.teacherName, 410, 50, 2),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                      message: 'Room',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  Container(
                                    width: 150,
                                    height: 50,
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
                                            fontSize: 15,
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
                                  const CustomText(
                                      message: 'Shift',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  Container(
                                    width: 150,
                                    height: 50,
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
                                            fontSize: 15,
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
                                  const CustomText(
                                      message: 'Date Report',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  Container(
                                    width: 150,
                                    height: 50,
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
                                            fontSize: 15,
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
                                  const CustomText(
                                      message: 'Date Response',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  Container(
                                    width: 150,
                                    height: 50,
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
                                      child: reportData!.feedBack != null ? Text(
                                          '${formatDate(reportData!.feedBack!.createdAtFeedBack)}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(108, 0, 0, 0),
                                          )) : Text(''),
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
                                  const CustomText(
                                      message: 'Status',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  Container(
                                    width: 150,
                                    height: 50,
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
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: getColor(
                                                widget.reportModel.status),
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
                                  const CustomText(
                                      message: 'Time Response',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText),
                                  Container(
                                    width: 150,
                                    height: 50,
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
                                      child: reportData.feedBack != null ? Text(
                                          '${formatTime(reportData.feedBack!.createdAtFeedBack)}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(108, 0, 0, 0),
                                          )) : Text(''),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                              message: 'Type of problem',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          const SizedBox(
                            height: 5,
                          ),
                          customCard('${reportData.problem}', 410, 50, 2),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                              message: 'Message',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          const SizedBox(
                            height: 5,
                          ),
                          customCard(reportData.message, 410, 150, 10),
                          const SizedBox(
                            height: 10,
                          ),
                          const CustomText(
                              message: 'Evidence of problem',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryText),
                          const SizedBox(
                            height: 5,
                          ),
                          reportData.reportImage.length >= 2
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: reportData.reportImage.map((e) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          e!.imageURL,
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )
                              : Center(
                                  child: Image.network(
                                    reportData.reportImage.first!.imageURL,
                                    width: 150,
                                    height: 150,
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.hasError}'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return Text('alo alo');
            }));
  }

  Container customCard(
    String message,
    double width,
    double height,
    int maxLines,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
          color: Color.fromARGB(139, 238, 246, 254),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border(
              top: BorderSide(color: AppColors.secondaryText),
              left: BorderSide(color: AppColors.secondaryText),
              right: BorderSide(color: AppColors.secondaryText),
              bottom: BorderSide(color: AppColors.secondaryText))),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15),
        child: Text(
          message,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(108, 0, 0, 0)),
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
    if(date != null && date != ''){
DateTime serverDateTime = DateTime.parse(date).toLocal();
    String formattedDate = DateFormat('MMMM d, y').format(serverDateTime);
    return formattedDate;
    }
    return '';
    
  }

  String formatTime(String? time) {
    if(time != null && time != '' ){
      DateTime serverDateTime = DateTime.parse(time).toLocal();
    String formattedTime = DateFormat("HH:mm:ss a").format(serverDateTime);
    return formattedTime;
    }
    return '';
  }
}
