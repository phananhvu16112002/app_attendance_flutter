import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Course {
  @HiveField(0)
  final String courseID;
  
  @HiveField(1)
  final String courseName;
  
  @HiveField(2)
  final int totalWeeks;
  
  @HiveField(3)
  final int requiredWeeks;
  
  @HiveField(4)
  final int credit;

  Course({
    required this.courseID,
    required this.courseName,
    required this.totalWeeks,
    required this.requiredWeeks,
    required this.credit,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        courseID: json['courseID'] ?? "",
        courseName: json['courseName'] ?? "",
        totalWeeks: int.tryParse(json['totalWeeks'].toString()) ?? 0,
        requiredWeeks: int.tryParse(json['requiredWeeks'].toString()) ?? 0,
        credit: int.tryParse(json['credit'].toString()) ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'courseID': courseID,
      'courseName': courseName,
      'totalWeeks': totalWeeks,
      'requiredWeeks': requiredWeeks,
      'credit': credit,
    };
  }
}
