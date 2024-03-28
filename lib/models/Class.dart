// import 'package:attendance_system_nodejs/models/Course.dart';
// import 'package:attendance_system_nodejs/models/Teacher.dart';

// class Class {
//   final String classID;
//   final String roomNumber;
//   final int shiftNumber;
//   final String? startTime;
//   final String? endTime;
//   final String classType;
//   final String group;
//   final String subGroup;
//   final Teacher teacher;
//   final Course course;

//   Class({
//     required this.classID,
//     required this.roomNumber,
//     required this.shiftNumber,
//     required this.startTime,
//     required this.endTime,
//     required this.classType,
//     required this.group,
//     required this.subGroup,
//     required this.teacher,
//     required this.course,
//   });

//   factory Class.fromJson(Map<String, dynamic> json) {
//     print('Class.fromJson: $json');
//     return Class(
//       classID: json['classID'],
//       roomNumber: json['roomNumber'] ?? "",
//       shiftNumber: int.tryParse(json['shiftNumber'].toString()) ?? 0,
//       startTime: json['startTime'] ?? "",
//       endTime: json['endTime'] ?? "",
//       classType: json['classType'] ?? "",
//       group: json['group'] ?? "",
//       subGroup: json['subGroup'] ?? "",
//       teacher: Teacher.fromJson(json['teacher'] ?? {}),
//       course: Course.fromJson(json['course'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'classID': classID,
//       'roomNumber': roomNumber,
//       'shiftNumber': shiftNumber,
//       'startTime': startTime,
//       'endTime': endTime,
//       'classType': classType,
//       'group': group,
//       'subGroup': subGroup,
//       'teacher':
//           teacher.toJson(),
//       'course': course.toJson(),
//     };
//   }

//
// }

import 'package:hive/hive.dart';
import 'package:attendance_system_nodejs/models/Teacher.dart';
import 'package:attendance_system_nodejs/models/Course.dart';

@HiveType(typeId: 0)
class Classes {
  @HiveField(0)
  final String classID;

  @HiveField(1)
  final String roomNumber;

  @HiveField(2)
  final int shiftNumber;

  @HiveField(3)
  final String startTime;

  @HiveField(4)
  final String endTime;

  @HiveField(5)
  final String classType;

  @HiveField(6)
  final String group;

  @HiveField(7)
  final String subGroup;

  @HiveField(8)
  final Teacher teacher;

  @HiveField(9)
  final Course course;

  Classes({
    required this.classID,
    required this.roomNumber,
    required this.shiftNumber,
    required this.startTime,
    required this.endTime,
    required this.classType,
    required this.group,
    required this.subGroup,
    required this.teacher,
    required this.course,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      classID: json['classID'],
      roomNumber: json['roomNumber'] ?? "",
      shiftNumber: int.tryParse(json['shiftNumber'].toString()) ?? 0,
      startTime: json['startTime'] ?? "",
      endTime: json['endTime'] ?? "",
      classType: json['classType'] ?? "",
      group: json['group'] ?? "",
      subGroup: json['subGroup'] ?? "",
      teacher: Teacher.fromJson(json['teacher'] ?? {}),
      course: Course.fromJson(json['course'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classID': classID,
      'roomNumber': roomNumber,
      'shiftNumber': shiftNumber,
      'startTime': startTime,
      'endTime': endTime,
      'classType': classType,
      'group': group,
      'subGroup': subGroup,
      'teacher': teacher.toJson(),
      'course': course.toJson(),
    };
  }

  static List<Classes> listTest() {
    List<Classes> listTemp = [];

    for (int i = 0; i < 5; i++) {
      listTemp.add(Classes(
          classID: 'classID$i',
          roomNumber: 'roomNumber$i',
          shiftNumber: i,
          startTime: 'startTime$i',
          endTime: 'endTime$i',
          classType: 'classType$i',
          group: 'group$i',
          subGroup: 'subGroup$i',
          teacher: Teacher(
              teacherID: 'teacherID$i',
              teacherName: 'teacherName$i',
              teacherHashedPassword: 'teacherHashedPassword',
              teacherEmail: 'teacherEmail',
              teacherHashedOTP: 'teacherHashedOTP',
              timeToLiveOTP: 'timeToLiveOTP',
              accessToken: 'accessToken',
              refreshToken: 'refreshToken',
              resetToken: 'resetToken',
              active: false),
          course: Course(
              courseID: 'courseID$i',
              courseName: 'courseName',
              totalWeeks: 10,
              requiredWeeks: 2,
              credit: 3)));
    }
    return listTemp;
  }
}
