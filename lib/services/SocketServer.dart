import 'dart:convert';

import 'package:attendance_system_nodejs/utils/constraints.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServer {
  final String baseURL = Constrants().baseURlLocalhost;
  late IO.Socket socket;

  connectToSocketServer(data) {
    socket = IO.io('http://$baseURL:9000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'headers': {'Content-Type': 'application/json'},
    });

    socket.connect();
    joinClassRoom(data);
    getAttendanceForm(data);
  }

  void joinClassRoom(data) {
    var jsonData = {'classRoom': data};
    var jsonString = jsonEncode(jsonData);
    print("Sending joinClassRoom event with data: $jsonString");
    socket.emit('joinClassRoom', jsonString);
  }

  void getAttendanceForm(classRoom) {
    socket.on('getAttendanceForm', (data) {
      var temp = jsonDecode(data);
      var temp1 = temp['classes'];
      if (temp1 == classRoom) {
        print('Attendance Form Detail:' + data);
      } else {
        print('Error ClassRoom not feat');
      }
    });
  }

  void disconnectSocketServer() {
    socket.disconnect();
  }
}
