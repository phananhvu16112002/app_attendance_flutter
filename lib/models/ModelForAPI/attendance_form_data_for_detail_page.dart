// import 'package:attendance_system_nodejs/models/ModelForAPI/AttendanceFormForDetailPage.dart';

// class AttendanceData {
//   AttendanceFormForDetailPage attendanceForm;
//   double result;
//   String? dateAttendanced;
//   String location;
//   String note;
//   double latitude;
//   double longitude;
//   String url;

//   AttendanceData({
//     required this.attendanceForm,
//     required this.result,
//     required this.dateAttendanced,
//     required this.location,
//     required this.note,
//     required this.latitude,
//     required this.longitude,
//     required this.url,
//   });

//   factory AttendanceData.fromJson(Map<String, dynamic> json) {
//     print(json['location'].runtimeType);

//     return AttendanceData(
//       attendanceForm:
//           AttendanceFormForDetailPage.fromJson(json['attendanceForm']),
//       result: double.parse(json['result'].toString()),
//       dateAttendanced: json['dateAttendanced'] == null ? '' : json['dateAttendanced'],
//       location: json['location'],
//       note: json['note'],
//       latitude: double.parse(json['latitude'].toString()),
//       longitude: double.parse(json['longitude'].toString()),
//       url: json['url'],
//     );
//   }
// }
