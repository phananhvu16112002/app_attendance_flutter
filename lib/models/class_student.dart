import 'package:hive/hive.dart';

@HiveType(typeId: 7)
class ClassesStudent {
  @HiveField(0)
  final String studentID;

  @HiveField(1)
  final String classID;

  @HiveField(2)
  final int total;

  @HiveField(3)
  final int totalPresence;

  @HiveField(4)
  final int totalAbsence;

  @HiveField(5)
  final int totalLate;

  @HiveField(6)
  final String roomNumber;

  @HiveField(7)
  final int shiftNumber;

  @HiveField(8)
  final String startTime;

  @HiveField(9)
  final String endTime;

  @HiveField(10)
  final String classType;

  @HiveField(11)
  final String group;

  @HiveField(12)
  final String subGroup;

  @HiveField(13)
  final String courseID;

  @HiveField(14)
  final String teacherID;

  @HiveField(15)
  final String courseName;

  @HiveField(16)
  final int totalWeeks;

  @HiveField(17)
  final int requiredWeeks;

  @HiveField(18)
  final int credit;

  @HiveField(19)
  final String teacherEmail;

  @HiveField(20)
  final String teacherName;

  @HiveField(21)
  final double progress;

  ClassesStudent({
    required this.studentID,
    required this.classID,
    required this.total,
    required this.totalPresence,
    required this.totalAbsence,
    required this.totalLate,
    required this.roomNumber,
    required this.shiftNumber,
    required this.startTime,
    required this.endTime,
    required this.classType,
    required this.group,
    required this.subGroup,
    required this.courseID,
    required this.teacherID,
    required this.courseName,
    required this.totalWeeks,
    required this.requiredWeeks,
    required this.credit,
    required this.teacherEmail,
    required this.teacherName,
    required this.progress,
  });

  factory ClassesStudent.fromJson(Map<String, dynamic> json) {
    return ClassesStudent(
      studentID: json['studentID'],
      classID: json['classID'],
      total: json['total'],
      totalPresence: json['totalPresence'],
      totalAbsence: json['totalAbsence'],
      totalLate: json['totalLate'],
      roomNumber: json['roomNumber'],
      shiftNumber: json['shiftNumber'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      classType: json['classType'],
      group: json['group'],
      subGroup: json['subGroup'],
      courseID: json['courseID'],
      teacherID: json['teacherID'],
      courseName: json['courseName'],
      totalWeeks: json['totalWeeks'],
      requiredWeeks: json['requiredWeeks'],
      credit: json['credit'],
      teacherEmail: json['teacherEmail'],
      teacherName: json['teacherName'],
      progress: double.parse(json['progress'].toString()),
    );
  }
}
