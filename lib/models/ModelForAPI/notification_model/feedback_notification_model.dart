class FeedbackNotification {
  int? feedbackID;
  String? topic;
  String? message;
  String? confirmStatus;

  FeedbackNotification({
    this.feedbackID,
    this.topic,
    this.message,
    this.confirmStatus,
  });

  factory FeedbackNotification.fromJson(Map<String, dynamic> json) => FeedbackNotification(
        feedbackID: json["feedbackID"],
        topic: json["topic"],
        message: json["message"],
        confirmStatus: json["confirmStatus"],
      );

  Map<String, dynamic> toJson() => {
        "feedbackID": feedbackID,
        "topic": topic,
        "message": message,
        "confirmStatus": confirmStatus,
      };
}