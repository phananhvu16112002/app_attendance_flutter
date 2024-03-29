import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';

class AttendanceDetail {
  final String studentDetail;
  final String classDetail;
  final AttendanceForm attendanceForm;
  final double result;
  final String dateAttendanced;
  final String location;
  final String note;
  final double latitude;
  final double longitude;
  final String url;
  
  
  AttendanceDetail(
      {required this.studentDetail,
      required this.classDetail,
      required this.attendanceForm,
      required this.result,
      required this.dateAttendanced,
      required this.location,
      required this.note,
      required this.latitude,
      required this.longitude,
      required this.url});

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    // print('AttendanceDetail.fromJson: $json');
    final dynamic attendanceFormJson = json['attendanceForm'];
    final AttendanceForm tempAttendanceForm = attendanceFormJson is String
        ? AttendanceForm(
            formID: attendanceFormJson,
            classes: '',
            startTime: '',
            endTime: '',
            dateOpen: '',
            status: false,
            typeAttendance: 0,
            location: '',
            latitude: 0.0,
            longtitude: 0.0,
            radius: 0.0)
        : AttendanceForm.fromJson(attendanceFormJson ?? {});
    return AttendanceDetail(
        studentDetail: json['studentDetail'] ?? '',
        classDetail: json['classDetail'] ?? '',
        attendanceForm: tempAttendanceForm,
        result: double.tryParse(json['result'].toString()) ?? 0.0,
        dateAttendanced: json['dateAttendanced'] ?? '',
        location: json['location'] ?? '',
        note: json['note'] ?? '',
        latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
        longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
        url: json['url'] ?? '');
  }
}
