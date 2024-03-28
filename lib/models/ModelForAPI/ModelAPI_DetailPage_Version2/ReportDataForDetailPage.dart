import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/Feedback.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ReportImage.dart';

class ReportData {
  int reportID;
  String topic;
  String problem;
  String message;
  String status;
  String createdAt;
  bool checkNew;
  bool important;
  List<ReportImage?> reportImage;
  FeedBack? feedBack;

  ReportData(
      {required this.reportID,
      required this.topic,
      required this.problem,
      required this.message,
      required this.status,
      required this.createdAt,
      required this.checkNew,
      required this.important,
      required this.reportImage,
      required this.feedBack});

  factory ReportData.fromJson(Map<String, dynamic> json) {
    // print('ReportImage: ${json['reportImage']}');
    List<dynamic> imagesJson = json['reportImage'] ?? [];
    List<ReportImage?> reportImages = imagesJson
        .map((imageJson) =>
            imageJson != null ? ReportImage.fromJson(imageJson) : null)
        .toList();

    return ReportData(
        reportID: json['reportID'],
        topic: json['topic'],
        problem: json['problem'],
        message: json['message'],
        status: json['status'],
        createdAt: json['createdAt'] ?? '',
        checkNew: json['new'],
        important: json['important'],
        reportImage: reportImages,
        feedBack: json['feedback'] != null
            ? FeedBack.fromJson(json['feedback'])
            : null);
  }
}
