import 'package:attendance_system_nodejs/models/ModelForAPI/api_view_image/student_model_image.dart';

class StudentModel {
  final String? studentName;
  final String? studentEmail;
  final String? timeToLiveImages;
  final List<StudentModelImage>? studentImages;

  StudentModel(
      {this.studentName = '',
      this.studentEmail = '',
      this.timeToLiveImages = '',
      this.studentImages});

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    // print(json['studentImage'].runtimeType);
    // print(json['studentImage']);

    return StudentModel(
      studentName: json['studentName'],
      studentEmail: json['studentEmail'],
      timeToLiveImages: json['timeToLiveImages'],
      studentImages: List<StudentModelImage>.from(json['studentImage']
          .map((imageJson) => StudentModelImage.fromJson(imageJson))),
    );
  }
}
