import 'package:attendance_system_nodejs/models/Student.dart';
import 'package:attendance_system_nodejs/services/GetLocation.dart';
import 'package:flutter/material.dart';

class StudentDataProvider with ChangeNotifier {
  Student _student = Student(
      studentID: '',
      studentName: '',
      studentEmail: '',
      password: '',
      hashedOTP: '',
      accessToken: '',
      refreshToken: '',
      active: false,
      latitude: 0,
      longtitude: 0,
      location: '');

  Student get userData => _student;

  void setStudent(Student student) {
    _student = student;
    notifyListeners();
  }

  void setStudentName(String userName) {
    _student.studentName = userName;
    notifyListeners();
  }

  void setStudentID(String studentID) {
    _student.studentID = studentID;
    notifyListeners();
  }

  void setStudentEmail(String studentEmail) {
    _student.studentEmail = studentEmail;
    notifyListeners();
  }

  void setPassword(String password) {
    _student.password = password;
    notifyListeners();
  }

  void setHashedOTP(String hashedOTP) {
    _student.hashedOTP = hashedOTP;
    notifyListeners();
  }

  void setAccessToken(String accessToken) {
    _student.accessToken = accessToken;
    notifyListeners();
  }

  void setRefreshToken(String refreshToken) {
    _student.refreshToken = refreshToken;
    notifyListeners();
  }

  void setActive(bool active) {
    _student.active = active;
    notifyListeners();
  }

  void setLatitude(double latitude) {
    _student.latitude = latitude;
    notifyListeners();
  }

  void setLongtitude(double longtitude) {
    _student.longtitude = longtitude;
    notifyListeners();
  }

  void setLocation(String location) {
    _student.location = location;
    notifyListeners();
  }

  void setUserData(Student data) {
    _student = data;
    notifyListeners();
  }

  void updateLocationData(double latitude, double longitude, String location) {
    if (latitude == 0.0 && longitude == 0.0) {
      GetLocation().updateLocation(this);
    } else {
      setLatitude(latitude);
      setLongtitude(longitude);
      setLocation(location);
    }
  }
}
