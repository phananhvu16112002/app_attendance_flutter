class FeedbackClass {
   int? feedbackID;
   String? topic;
   String? message;
   String? confirmStatus;
   String? createdAt;

  FeedbackClass({
     this.feedbackID = 0,
     this.topic = '',
     this.message = '',
     this.confirmStatus = '',
     this.createdAt = '',
  });

  factory FeedbackClass.fromJson(Map<String, dynamic> json) {
    return FeedbackClass(
      feedbackID: json['feedbackID'],
      topic: json['topic'],
      message: json['message'],
      confirmStatus: json['confirmStatus'],
      createdAt: json['createdAt'],
    );
  }
}
