import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/AttendanceFormDataForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/Feedback.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/ReportDataForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ReportImage.dart';

class AttendanceDetailDataForDetailPage {
  final String studentDetail;
  final String classDetail;
  final AttendanceFormDataForDetailPage attendanceForm;
  final double result;
  final String dateAttendanced;
  final String location;
  final String note;
  final double latitude;
  final double longitude;
  final String url;
  final String createdAt;
  final ReportData? report;

  AttendanceDetailDataForDetailPage({
    required this.studentDetail,
    required this.classDetail,
    required this.attendanceForm,
    required this.result,
    required this.dateAttendanced,
    required this.location,
    required this.note,
    required this.latitude,
    required this.longitude,
    required this.url,
    required this.createdAt,
    required this.report,
  });

  factory AttendanceDetailDataForDetailPage.fromJson(
      Map<String, dynamic> json) {
    print(json['report'].runtimeType);
    return AttendanceDetailDataForDetailPage(
      studentDetail: json['studentDetail'],
      classDetail: json['classDetail'],
      attendanceForm:
          AttendanceFormDataForDetailPage.fromJson(json['attendanceForm']),
      result: double.parse(json['result'].toString()),
      dateAttendanced: json['dateAttendanced'] ?? '',
      location: json['location'],
      note: json['note'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      url: json['url'],
      createdAt: json['createdAt'] ?? '',
      report: json['report'] != null ? ReportData.fromJson(json['report']) : null
    );
  }
}
