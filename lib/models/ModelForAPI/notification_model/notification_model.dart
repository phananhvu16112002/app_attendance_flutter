// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:attendance_system_nodejs/models/ModelForAPI/notification_model/attendance_detail_notification.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/notification_model/feedback_notification_model.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/notification_model/form_notification.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/notification_model/report_notification.dart';

class NotificationModel {
  String? type;
  FeedbackNotification? feedback;
  ReportNotification? report;
  String? formID;
  String? classID;
  String? course;
  String? lecturer;
  String? createdAt;
  bool seen;
  FormNotification? form;
  AttendanceDetailNoti? attendanceDetail;

  NotificationModel({
    this.type,
    this.feedback,
    this.report,
    this.formID,
    this.classID,
    this.course,
    this.lecturer,
    this.createdAt,
    this.seen = false,
    this.form,
    this.attendanceDetail,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        type: json["type"],
        feedback: json["feedback"] != null
            ? FeedbackNotification.fromJson(json["feedback"])
            : null,
        report: json["report"] != null
            ? ReportNotification.fromJson(json["report"])
            : null,
        formID: json["formID"],
        classID: json["classID"],
        course: json["course"],
        lecturer: json["lecturer"],
        createdAt: json["createdAt"],
        seen: json["seen"],
        form: json["form"] != null
            ? FormNotification.fromJson(json["form"])
            : null,
        attendanceDetail: json["attendancedetail"] != null
            ? AttendanceDetailNoti.fromJson(json["attendancedetail"])
            : null,
      );
}
