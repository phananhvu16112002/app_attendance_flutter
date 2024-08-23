import 'dart:convert';

import 'package:attendance_system_nodejs/models/attendance_detail.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/attendance_form_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_form_for_detail_page.dart';
import 'package:attendance_system_nodejs/utils/constraints.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketServerProvider with ChangeNotifier {
  late IO.Socket _socket;
  bool _isConnected = false;
  final String baseURL = Constrants().urlSocket;

  IO.Socket get socket => _socket;
  bool get isConnected => _isConnected;

  final StreamController<AttendanceFormDataForDetailPage> _attendanceFormController =
      StreamController<AttendanceFormDataForDetailPage>.broadcast();

  Stream<AttendanceFormDataForDetailPage> get attendanceFormStream =>
      _attendanceFormController.stream.asBroadcastStream();

  @override
  void dispose() {
    // TODO: implement dispose
    _attendanceFormController.close();
    print('socket dispose');
    super.dispose();
  }

  void connectToSocketServer(data) {
    _socket = IO.io('$baseURL', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'headers': {'Content-Type': 'application/json'},
    });

    _socket.connect();
    _isConnected = true;
    joinClassRoom(data);
    getAttendanceForm(data);
    notifyListeners();
  }

  void joinClassRoom(data) {
    var jsonData = {'classRoom': data};
    var jsonString = jsonEncode(jsonData);
    print("Sending joinClassRoom event with data: $jsonString");
    _socket.emit('joinClassRoom', jsonString);
  }

  AttendanceFormDataForDetailPage? getAttendanceForm(classRoom) {
    _socket.on('getAttendanceForm', (data) {
      var temp = jsonDecode(data);
      var temp1 = temp['classes'];
      if (temp1 == classRoom) {
        print('Attendance Form Detail:' + data);
        _attendanceFormController.add(AttendanceFormDataForDetailPage.fromJson(temp));
        AttendanceFormDataForDetailPage attendanceForm = AttendanceFormDataForDetailPage.fromJson(temp);
        return attendanceForm;
      } else {
        print('Error ClassRoom not feat');
        return null;
      }
    });
    return null;
  }

  void takeAttendance(studentID, classID, formID, dateTimeAttendance, location,
      latitude, longitude, result, image) {
    var jsonData = {
      'studentDetail': studentID,
      'classDetail': classID,
      'formID': formID,
      'dateTimeAttendance': dateTimeAttendance,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'result': result,
      'image': image
    };

    var jsonString = jsonEncode(jsonData);
    print('Student $studentID Sending Attendance Form $formID to $classID');
    _socket.emit('takeAttendance', jsonString);
  }

  void disconnectSocketServer() {
    _socket.disconnect();
    _isConnected = false;
    print('Disconnect socket');
    notifyListeners();
  }
}
