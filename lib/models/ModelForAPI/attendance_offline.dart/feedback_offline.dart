class FeedbackOffline {
  int? feedbackID;
  String? topic;
  String? message;
  String? confirmStatus;
  String? createdAt;
  bool? seen;

  FeedbackOffline({
    this.feedbackID,
    this.topic,
    this.message,
    this.confirmStatus,
    this.createdAt,
    this.seen,
  });

  factory FeedbackOffline.fromJson(Map<String, dynamic> json) {
    return FeedbackOffline(
      feedbackID: json['feedbackID'],
      topic: json['topic'],
      message: json['message'],
      confirmStatus: json['confirmStatus'],
      createdAt: (json['createdAt']),
      seen: json['seen'],
    );
  }
}
