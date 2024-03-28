import 'package:attendance_system_nodejs/models/AttendanceDetail.dart';
import 'package:flutter/material.dart';

class AttendanceDetailDataProvider with ChangeNotifier {
  List<AttendanceDetail> _attendanceDetailList = [];

  List<AttendanceDetail> get attendanceDetailData => _attendanceDetailList;

  void setAttendanceDetailList(List<AttendanceDetail> attendanceDetailList) {
    _attendanceDetailList = attendanceDetailList;
    notifyListeners();
  }

  AttendanceDetail? getDataFormAndStudent(
      String studentID, String classes, String formID) {
    for (var i = 0; i < _attendanceDetailList.length; i++) {
      if (_attendanceDetailList[i].attendanceForm.formID == formID &&
          _attendanceDetailList[i].studentDetail == studentID &&
          _attendanceDetailList[i].classDetail == classes) {
        var temp = _attendanceDetailList[i];
        return temp;
      }
    }
    return null;
  }
}
