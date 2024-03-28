import 'package:attendance_system_nodejs/models/Class.dart';
import 'package:attendance_system_nodejs/models/Course.dart';
import 'package:attendance_system_nodejs/models/Student.dart';
import 'package:attendance_system_nodejs/models/Teacher.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class StudentClasses {
  @HiveField(0)
  Student studentID;

  @HiveField(1)
  Classes classes;

  @HiveField(2)
  double progress;

  @HiveField(3)
  double total;

  @HiveField(4)
  int totalPresence;

  @HiveField(5)
  int totalAbsence;

  @HiveField(6)
  int totalLate;

  StudentClasses({
    required this.studentID,
    required this.classes,
    required this.progress,
    required this.total,
    required this.totalPresence,
    required this.totalAbsence,
    required this.totalLate,
  });
  factory StudentClasses.fromJson(Map<String, dynamic> json) {
    // print('StudentClasses.fromJson: $json');

    final dynamic studentJson = json['studentDetail'];
    final Student studentDetail = studentJson is String
        ? Student(
            studentID: studentJson,
            studentName: '',
            studentEmail: '',
            password: '',
            hashedOTP: '',
            accessToken: '',
            refreshToken: '',
            active: true,
            latitude: 0.0,
            longtitude: 0.0,
            location: '')
        : Student.fromJson(studentJson ?? {});

    final dynamic classJson = json['classDetail'];
    final Classes classDetail = classJson is String
        ? Classes(
            classID: classJson,
            roomNumber: '',
            shiftNumber: 0,
            startTime: '',
            endTime: '',
            classType: '',
            group: '',
            subGroup: '',
            teacher: Teacher(
                teacherID: '',
                teacherName: '',
                teacherHashedPassword: '',
                teacherEmail: '',
                teacherHashedOTP: '',
                timeToLiveOTP: '',
                accessToken: '',
                refreshToken: '',
                resetToken: '',
                active: true),
            course: Course(
                courseID: '',
                courseName: '',
                totalWeeks: 0,
                requiredWeeks: 0,
                credit: 0))
        : Classes.fromJson(classJson ?? {});
    print(json['totalLate'].runtimeType);
    return StudentClasses(
      studentID: studentDetail,
      classes: classDetail,
      progress: double.tryParse(json['progress'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      totalPresence: json['totalPresence'] ?? 0,
      totalAbsence: json['totalAbsence'] ?? 0,
      totalLate: json['totalLate'] ?? 0,
    );
  }
}
