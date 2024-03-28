import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class Student {
  @HiveField(0)
  String studentID;

  @HiveField(0)
  String studentName;

  @HiveField(0)
  String studentEmail;

  @HiveField(0)
  String password;

  @HiveField(0)
  String hashedOTP;

  @HiveField(0)
  String accessToken;

  @HiveField(0)
  String refreshToken;

  @HiveField(0)
  bool active;

  @HiveField(0)
  double latitude;

  @HiveField(0)
  double longtitude;
  
  @HiveField(0)
  String location;

  Student(
      {required this.studentID,
      required this.studentName,
      required this.studentEmail,
      required this.password,
      required this.hashedOTP,
      required this.accessToken,
      required this.refreshToken,
      required this.active,
      required this.latitude,
      required this.longtitude,
      required this.location});
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        studentID: json['studentID'] ?? '',
        studentName: json['studentName'] ?? '',
        studentEmail: json['studentEmail'] ?? '',
        password: json['password'] ?? '',
        hashedOTP: json['hasedOTP'] ?? '',
        accessToken: json['accessToken'] ?? '',
        refreshToken: json['refreshToken'] ?? '',
        active: json['active'] ?? false,
        latitude: json['latitude'] ?? 0.0,
        longtitude: json['longitude'] ?? 0.0,
        location: json['location'] ?? '');
  }
}
