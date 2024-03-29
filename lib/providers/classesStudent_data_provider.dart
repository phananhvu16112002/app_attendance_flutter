import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:flutter/material.dart';

class ClassesStudentProvider with ChangeNotifier {
  List<ClassesStudent> _classesStudentList = [];

  List<ClassesStudent> get ClassesStudentList => _classesStudentList;

  void setClassesStudentList(List<ClassesStudent> ClassesStudentList) {
    _classesStudentList = ClassesStudentList;
    notifyListeners();
  }
  
}
