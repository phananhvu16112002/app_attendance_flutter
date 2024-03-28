import 'package:attendance_system_nodejs/models/ModelForAPI/AttendanceFormForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ClassForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/CourseForDetailPage.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/AttendanceFormDataForDetailPage.dart';
import 'package:flutter/material.dart';

class AttendanceFormDataForDetailPageProvider with ChangeNotifier {
  AttendanceFormDataForDetailPage _attendanceFormDataForDetailPage =
      AttendanceFormDataForDetailPage(
          formID: '',
          startTime: '',
          endTime: '',
          status: false,
          dateOpen: '',
          type: 0,
          latitude: 0.0,
          longitude: 0.0,
          radius: 0.0);

  AttendanceFormDataForDetailPage get attendanceFormData =>
      _attendanceFormDataForDetailPage;

  void setAttendanceFormData(AttendanceFormDataForDetailPage attendanceForm) {
    if (attendanceForm.formID == '') {
      print('Update AttendanceForm Provider Failed');
    } else {
      _attendanceFormDataForDetailPage = attendanceForm;
      notifyListeners();
      print('Update successfully');
    }
  }
}
