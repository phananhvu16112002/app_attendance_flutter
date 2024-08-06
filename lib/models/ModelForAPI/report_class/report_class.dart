
import 'package:attendance_system_nodejs/models/ModelForAPI/report_class/feedback_class.dart';

class ReportModelClass {
  int? reportID;
  String? topic;
  String? problem;
  String? message;
  String? status;
  String? createdAt;
  bool? isNew;
  bool? isImportant;
  FeedbackClass? feedback;

  ReportModelClass({
     this.reportID = 0,
     this.topic ='',
     this.problem ='',
     this.message ='',
     this.status = '',
     this.createdAt= '',
     this.isNew =false,
     this.isImportant=false,
     this.feedback,
  });

  factory ReportModelClass.fromJson(Map<String, dynamic> json) {
    return ReportModelClass(
      reportID: json['reportID'],
      topic: json['topic'],
      problem: json['problem'],
      message: json['message'],
      status: json['status'],
      createdAt: json['createdAt'],
      isNew: json['new'],
      isImportant: json['important'],
      feedback:  json['feedback'] != null ? FeedbackClass.fromJson(json['feedback']) : null ,
    );
  }
}
