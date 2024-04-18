// ignore_for_file: public_member_api_docs, sort_constructors_first
class NotificationModel {
  String? type;
  int? reportID;
  String? formID;
  String? course;
  String? lecturer;
  String? createdAt;
  NotificationModel({
    this.type = '',
    this.reportID = 0,
    this.formID = '',
    this.course = '',
    this.lecturer = '',
    this.createdAt = '',
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        type: json['type'],
        reportID: json['reportID'],
        formID: json['formID'],
        course: json['course'],
        lecturer: json['lecturer'],
        createdAt: json['createdAt']);
  }
}
