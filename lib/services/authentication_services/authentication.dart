import 'dart:convert';
import 'package:attendance_system_nodejs/utils/constraints.dart';
import 'package:http/http.dart' as http;
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';

class Authenticate {
  final String baseURl = Constrants().baseURlLocalhost;
  Future<String> registerUser(
      String userName, String email, String password) async {
    var URL = 'http://$baseURl:8080/api/student/register';
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    var request = {'email': email, 'password': password, 'username': userName};
    var body = json.encode(request);
    final response =
        await http.post(Uri.parse(URL), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Registration successful');
      return '';
    } else {
      final Map<String, dynamic> responseData1 = jsonDecode(response.body);
      print('Failed to register. Error: ${response.body}');
      return responseData1['message'];
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    final URL = 'http://${baseURl}:8080/api/student/verifyRegister';
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    var request = {'email': email, 'OTP': otp};
    var body = json.encode(request);
    final response =
        await http.post(Uri.parse(URL), headers: headers, body: body);

    if (response.statusCode == 200) {
      print('Registration successful');
      return true;
    } else {
      print('Failed to register. Error: ${response.body}');
      return false;
    }
  }

  //<String, String> code (200, requireImage) => requireImage = false => chuyen trang Home, requiredImage = true => chuyen trang chup anh
  Future<String> login(String email, String password) async {
    final URL = 'http://${baseURl}:8080/api/student/login';
    var request = {'email': email, 'password': password};
    var body = json.encode(request);
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    final response =
        await http.post(Uri.parse(URL), headers: headers, body: body);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      var accessToken = responseData['accessToken'];
      var refreshToken = responseData['refreshToken'];
      var studentID = responseData['studentID'];
      var studentEmail = responseData['studentEmail'];
      var studentName = responseData['studentName'];

      print('--Response Data: $responseData');

      await SecureStorage().writeSecureData('accessToken', accessToken);
      await SecureStorage().writeSecureData('refreshToken', refreshToken);
      await SecureStorage().writeSecureData('studentID', studentID);
      await SecureStorage().writeSecureData('studentEmail', studentEmail);
      await SecureStorage().writeSecureData('studentName', studentName);
      return '';
    } else {
      // ignore: avoid_print
      final Map<String, dynamic> responseData1 = jsonDecode(response.body);
      print('Message: ${responseData1['message']}');
      return responseData1['message'];
    }
  }

  Future<String> forgotPassword(String email) async {
    final URL = 'http://${baseURl}:8080/api/student/forgotPassword';
    var request = {'email': email};
    var body = jsonEncode(request);
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    final response =
        await http.post(Uri.parse(URL), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Successfully...');
      return '';
    } else {
      print('Failed');
      dynamic data = jsonDecode(response.body);
      String message = data['message'];
      return message;
    }
  }

  Future<bool> verifyForgotPassword(String email, String otp) async {
    final response = await http.post(
        Uri.parse('http://${baseURl}:8080/api/student/verifyForgotPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode(<String, String>{'email': email, 'OTP': otp}));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      var resetToken = responseData['resetToken'];
      await SecureStorage().writeSecureData('resetToken', resetToken);
      return true;
    } else {
      return false;
    }
  }

  Future<String> resetPassword(String email, String newPassword) async {
    final resetToken = await SecureStorage().readSecureData("resetToken");
    final response = await http.post(
        Uri.parse('http://${baseURl}:8080/api/student/resetPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'authorization': resetToken
        },
        body: jsonEncode(
            <String, String>{'email': email, 'newPassword': newPassword}));

    if (response.statusCode == 200) {
      return '';
    } else {
      dynamic data = jsonDecode(response.body);
      String message = data['message'];
      return message;
    }
  }

  Future<bool> resendOTPRegister(String email) async {
    final URL = 'http://${baseURl}:8080/api/student/resendOTPRegister';
    var request = {'email': email};
    var body = jsonEncode(request);
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    final response =
        await http.post(Uri.parse(URL), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Successfully...');
      return true;
    } else {
      print('Failed');
      return false;
    }
  }

  Future<String> resendOTP(String email) async {
    final URL = 'http://${baseURl}:8080/api/student/resendOTP';
    var request = {'email': email};
    var body = jsonEncode(request);
    var headers = {
      'Content-type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    };
    final response =
        await http.post(Uri.parse(URL), headers: headers, body: body);
    if (response.statusCode == 200) {
      print('Successfully...');
      return '';
    } else {
      print('Failed');
      dynamic data = jsonDecode(response.body);
      String message = data['message'];
      return message;
    }
  }
}
