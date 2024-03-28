import 'package:flutter/material.dart';

class FeedBack {
  int? feedbackID;
  String? topicFeedback;
  String? messageFeedback;
  String? confirmStatus;
  String? createdAtFeedBack;

  FeedBack(
      {required this.feedbackID,
      required this.topicFeedback,
      required this.messageFeedback,
      required this.confirmStatus,
      required this.createdAtFeedBack});

  factory FeedBack.fromJson(Map<String, dynamic> json) {
    return FeedBack(
      feedbackID: json['feedbackID'] ?? 0,
      topicFeedback: json['topic'] ?? '',
      messageFeedback: json['message'] ?? '',
      confirmStatus: json['confirmStatus'] ?? '',
      createdAtFeedBack: json['createdAt'] ?? '',
    );
  }
}
