class ReportNotification {
  int? reportID;
  String? topic;
  String? problem;
  String? message;
  String? status;
  String? createdAt;
  bool? isNew;
  bool? isImportant;

  ReportNotification({
    this.reportID,
    this.topic,
    this.problem,
    this.message,
    this.status,
    this.createdAt,
    this.isNew,
    this.isImportant,
  });

  factory ReportNotification.fromJson(Map<String, dynamic> json) =>
      ReportNotification(
        reportID: json["reportID"],
        topic: json["topic"],
        problem: json["problem"],
        message: json["message"],
        status: json["status"],
        createdAt: json["createdAt"],
        isNew: json["new"],
        isImportant: json["important"],
      );

}
