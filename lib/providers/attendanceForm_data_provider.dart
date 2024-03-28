import 'package:attendance_system_nodejs/models/AttendanceForm.dart';
import 'package:flutter/material.dart';

class AttendanceFormDataProvider with ChangeNotifier {
  AttendanceForm _attendanceFormData = AttendanceForm(
      formID: '',
      classes: '',
      startTime: '',
      endTime: '',
      dateOpen: '',
      status: false,
      typeAttendance: 0,
      location: '',
      latitude: 0.0,
      longtitude: 0.0,
      radius: 0.0);

  AttendanceForm get attendanceFormData => _attendanceFormData;
  

  void setAttendanceFormData(AttendanceForm attendanceForm) {
    if (attendanceForm.formID == '') {
      print('Update AttendanceForm Provider Failed');
    } else {
      _attendanceFormData = attendanceForm;
      notifyListeners();
      print('Update successfully');
    }
  }
}
