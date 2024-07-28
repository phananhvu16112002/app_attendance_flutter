class ReportModel {
  String classesClassID;
  String classesRoomNumber;
  int classesShiftNumber;
  String classesStartTime;
  String classesEndTime;
  String classesClassType;
  String classesGroup;
  String classesSubGroup;
  String classesCourseID;
  String classesTeacherID;
  String courseCourseID;
  String courseCourseName;
  int? courseTotalWeeks;
  int? courseCredit;
  int? feedbackFeedbackID;
  String? feedbackTopic;
  String? feedbackMessage;
  String? feedbackConfirmStatus;
  String? feedbackCreatedAt;
  int? feedbackReportID;
  int? reportID;
  String topic;
  String problem;
  String message;
  String status;
  String createdAt;
  int isNew;
  int isImportant;
  String studentID;
  String classID;
  String formID;
  String teacherID;
  String teacherEmail;
  String teacherName;

  ReportModel({
    required this.classesClassID,
    required this.classesRoomNumber,
    required this.classesShiftNumber,
    required this.classesStartTime,
    required this.classesEndTime,
    required this.classesClassType,
    required this.classesGroup,
    required this.classesSubGroup,
    required this.classesCourseID,
    required this.classesTeacherID,
    required this.courseCourseID,
    required this.courseCourseName,
    required this.courseTotalWeeks,
    required this.courseCredit,
    required this.feedbackFeedbackID,
    required this.feedbackTopic,
    required this.feedbackMessage,
    required this.feedbackConfirmStatus,
    required this.feedbackCreatedAt,
    required this.feedbackReportID,
    required this.reportID,
    required this.topic,
    required this.problem,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.isNew,
    required this.isImportant,
    required this.studentID,
    required this.classID,
    required this.formID,
    required this.teacherID,
    required this.teacherEmail,
    required this.teacherName,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      classesClassID: json['classes_classID'],
      classesRoomNumber: json['roomNumber'],
      classesShiftNumber: json['shiftNumber'],
      classesStartTime: json['classes_startDate'],
      classesEndTime: json['classes_endDate'],
      classesClassType: json['classes_classType'],
      classesGroup: json['classes_group'],
      classesSubGroup: json['classes_subGroup'],
      classesCourseID: json['classes_courseID'],
      classesTeacherID: json['classes_teacherID'],
      courseCourseID: json['course_courseID'],
      courseCourseName: json['course_courseName'],
      courseTotalWeeks: int.parse(json['totalWeeks'].toString()),
      courseCredit: int.parse(json['course_credit'].toString()),
      feedbackFeedbackID: json['feedback_feedbackID'] ?? 0,
      feedbackTopic: json['feedback_topic'] ?? '',
      feedbackMessage: json['feedback_message'] ?? '',
      feedbackConfirmStatus: json['feedback_confirmStatus'] ?? '',
      feedbackCreatedAt: json['feedback_createdAt'] ?? '',
      feedbackReportID: json['feedback_reportID'] ?? 0,
      reportID: json['reportID'] ?? 0,
      topic: json['topic'] ?? '',
      problem: json['problem'],
      message: json['message'],
      status: json['status'],
      createdAt: json['createdAt'] ?? '',
      isNew: json['new'],
      isImportant: json['important'],
      studentID: json['studentID'],
      classID: json['classID'],
      formID: json['formID'],
      teacherID: json['teacherID'],
      teacherEmail: json['teacherEmail'],
      teacherName: json['teacherName'],
    );
  }
}
