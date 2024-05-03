import 'package:flutter/material.dart';

class FeedBack {
  int? feedbackID;
  String? topicFeedback;
  String? messageFeedback;
  String? confirmStatus;
  String? createdAtFeedBack;
  bool seen;

  FeedBack(
      { this.feedbackID,
       this.topicFeedback,
       this.messageFeedback,
       this.confirmStatus,
       this.createdAtFeedBack,
       this.seen = false
       });

  factory FeedBack.fromJson(Map<String, dynamic> json) {
    return FeedBack(
      feedbackID: json['feedbackID'] ?? 0,
      topicFeedback: json['topic'] ?? '',
      messageFeedback: json['message'] ?? '',
      confirmStatus: json['confirmStatus'] ?? '',
      createdAtFeedBack: json['createdAt'] ?? '',
      seen: json['seen']
    );
  }
}
