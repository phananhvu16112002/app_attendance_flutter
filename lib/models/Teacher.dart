import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Teacher {
  @HiveField(0)
  final String teacherID;

  @HiveField(1)
  final String teacherName;

  @HiveField(2)
  final String teacherHashedPassword;

  @HiveField(3)
  final String teacherEmail;

  @HiveField(4)
  final String teacherHashedOTP;

  @HiveField(5)
  final String timeToLiveOTP;

  @HiveField(6)
  final String accessToken;

  @HiveField(7)
  final String refreshToken;

  @HiveField(8)
  final String resetToken;

  @HiveField(9)
  final bool active;

  Teacher({
    required this.teacherID,
    required this.teacherName,
    required this.teacherHashedPassword,
    required this.teacherEmail,
    required this.teacherHashedOTP,
    required this.timeToLiveOTP,
    required this.accessToken,
    required this.refreshToken,
    required this.resetToken,
    required this.active,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
        teacherID: json['teacherID'] ?? '',
        teacherName: json['teacherName'] ?? "",
        teacherHashedPassword: json['teacherHashedPassword'] ?? "",
        teacherEmail: json['teacherEmail'] ?? "",
        teacherHashedOTP: json['teacherHashedOTP'] ?? "",
        timeToLiveOTP: json["timeToLiveOTP"] ?? "",
        accessToken: json['accessToken'] ?? "",
        refreshToken: json['refreshToken'] ?? "",
        resetToken: json['resetToken'] ?? "",
        active: json['active'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'teacherID': teacherID,
      'teacherName': teacherName,
      'teacherHashedPassword': teacherHashedPassword,
      'teacherEmail': teacherEmail,
      'teacherHashedOTP': teacherHashedOTP,
      'timeToLiveOTP': timeToLiveOTP,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'resetToken': resetToken,
      'active': active,
    };
  }
}
