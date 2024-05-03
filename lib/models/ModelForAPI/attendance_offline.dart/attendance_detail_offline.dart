import 'package:attendance_system_nodejs/models/ModelForAPI/attendance_offline.dart/attendanceForm_offline.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/attendance_offline.dart/feedback_offline.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/attendance_offline.dart/report_offline.dart';

class AttendanceDetailOffline {
  String? studentDetail;
  String? classDetail;
  AttendanceFormOffline? attendanceForm;
  double? result;
  String? dateAttendanced;
  String? location;
  String? note;
  double? latitude;
  double? longitude;
  String? url;
  String? createdAt;
  bool? seen;
  bool? offline;
  ReportOffline? report;
  FeedbackOffline? feedback;

  AttendanceDetailOffline({
    this.studentDetail,
    this.classDetail,
    this.attendanceForm,
    this.result,
    this.dateAttendanced,
    this.location,
    this.note,
    this.latitude,
    this.longitude,
    this.url,
    this.createdAt,
    this.seen,
    this.offline,
    this.report,
    this.feedback,
  });

  factory AttendanceDetailOffline.fromJson(Map<String, dynamic> json) {
    return AttendanceDetailOffline(
      studentDetail: json['studentDetail'],
      classDetail: json['classDetail'],
      attendanceForm: AttendanceFormOffline.fromJson(json['attendanceForm']) ,
      result: double.parse(json['result'].toString()),
      dateAttendanced: (json['dateAttendanced']),
      location: json['location'],
      note: json['note'],
      latitude: double.parse(json['latitude'].toString()) ,
      longitude: double.parse(json['longitude'].toString()) ,
      url: json['url'],
      createdAt: (json['createdAt']),
      seen: json['seen'],
      offline: json['offline'],
      report: json['report'] != null ? ReportOffline.fromJson(json['report']) : null,
      feedback: json['feedback'] != null ? FeedbackOffline.fromJson(json['feedback']) : null,
    );
  }
}
