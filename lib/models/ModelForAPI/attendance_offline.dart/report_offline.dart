class ReportOffline {
  int? reportID;
  String? topic;
  String? problem;
  String? message;
  String? status;
  String? createdAt;
  bool? newReportOffline;
  bool? important;

  ReportOffline({
    this.reportID,
    this.topic,
    this.problem,
    this.message,
    this.status,
    this.createdAt,
    this.newReportOffline,
    this.important,
  });

  factory ReportOffline.fromJson(Map<String, dynamic> json) {
    return ReportOffline(
      reportID: json['reportID'],
      topic: json['topic'],
      problem: json['problem'],
      message: json['message'],
      status: json['status'],
      createdAt: (json['createdAt']),
      newReportOffline: json['new'],
      important: json['important'],
    );
  }
}
