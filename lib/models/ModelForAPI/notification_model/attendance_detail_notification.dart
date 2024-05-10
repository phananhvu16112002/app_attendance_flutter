class AttendanceDetailNoti {
  String? studentDetail;
  String? classDetail;
  String? attendanceForm;
  double? result;

  AttendanceDetailNoti({
    this.studentDetail,
    this.classDetail,
    this.attendanceForm,
    this.result,
  });

  factory AttendanceDetailNoti.fromJson(Map<String, dynamic> json) =>
      AttendanceDetailNoti(
        studentDetail: json["studentDetail"],
        classDetail: json["classDetail"],
        attendanceForm: json["attendanceForm"],
        result: double.parse(json["result"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "studentDetail": studentDetail,
        "classDetail": classDetail,
        "attendanceForm": attendanceForm,
        "result": result,
      };
}
