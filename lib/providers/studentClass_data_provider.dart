import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:flutter/material.dart';

class StudentClassesDataProvider with ChangeNotifier {
  List<StudentClasses> _studentClassesList = [];

  List<StudentClasses> get studentClassesList => _studentClassesList;

  void setStudentClassesList(List<StudentClasses> studentClassesList) {
    _studentClassesList = studentClassesList;
    notifyListeners();
  }

  StudentClasses? getDataForClass(String classID) {
    for (var item in studentClassesList) {
      if (item.classes.classID == classID ||
          item.classes.classID.contains(classID)) {
        var temp = item;
        return temp;
      } else {}
    }
    return null;
  }
}
