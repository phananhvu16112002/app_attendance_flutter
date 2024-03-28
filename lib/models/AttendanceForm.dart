import 'package:attendance_system_nodejs/models/Class.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class AttendanceForm {
  @HiveField(0)
  String formID;

  @HiveField(1)
  String classes;

  @HiveField(2)
  String startTime;

  @HiveField(3)
  String endTime;

  @HiveField(4)
  String dateOpen;

  @HiveField(5)
  bool status;

  @HiveField(6)
  int typeAttendance;

  @HiveField(7)
  String location;

  @HiveField(8)
  double latitude;

  @HiveField(9)
  double longtitude;

  @HiveField(10)
  double radius;

  AttendanceForm({
    required this.formID,
    required this.classes,
    required this.startTime,
    required this.endTime,
    required this.dateOpen,
    required this.status,
    required this.typeAttendance,
    required this.location,
    required this.latitude,
    required this.longtitude,
    required this.radius,
  });

  factory AttendanceForm.fromJson(Map<String, dynamic> json) {
    print('AttendanceForm.fromJson: $json');
    return AttendanceForm(
        formID: json['formID'] ?? '',
        classes: json['classes'] ?? '',
        startTime: json['startTime'] ?? '',
        endTime: json['endTime'] ?? '',
        dateOpen: json['dateOpen'] ?? '',
        status: json['status'] ?? false,
        typeAttendance: json['type'] ?? 0,
        location: json['location'] ?? '',
        latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
        longtitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
        radius: double.tryParse(json['radius'].toString()) ?? 0.0);
  }
}
