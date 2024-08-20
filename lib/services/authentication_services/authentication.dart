import 'dart:convert';
import 'package:attendance_system_nodejs/utils/constraints.dart';
import 'package:http/http.dart' as http;
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate {
  final String baseURl = Constrants().baseURlLocalhost;
  Future<String> registerUser(
      String userName, String email, String password) async {
    var URL = '$baseURl/api/student/register';
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
    final URL = '${baseURl}/api/student/verifyRegister';
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
    final deviceToken = await SecureStorage().readSecureData('tokenFirebase');
    final URL = '${baseURl}/api/student/login';
    var request = {'email': email, 'password': password, 'deviceToken': deviceToken};
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
      var requiredImage = responseData['requiredImage'];

      print('--Response Data: $responseData');
      print('Required: ${requiredImage.toString()}');

      await SecureStorage().writeSecureData('accessToken', accessToken);
      await SecureStorage().writeSecureData('refreshToken', refreshToken);
      await SecureStorage().writeSecureData('studentID', studentID);
      await SecureStorage().writeSecureData('studentEmail', studentEmail);
      await SecureStorage().writeSecureData('studentName', studentName);
      await SecureStorage().writeSecureData('requiredImage', requiredImage.toString());
      // await sharedPreferences.setString('studentName', studentName);
      // await sharedPreferences.setBool('requiredImage', requiredImage);
      return '';
    } else {
      // ignore: avoid_print
      final Map<String, dynamic> responseData1 = jsonDecode(response.body);
      print('Message: ${responseData1['message']}');
      return responseData1['message'];
    }
  }

  Future<String> forgotPassword(String email) async {
    final URL = '${baseURl}/api/student/forgotPassword';
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
        Uri.parse('${baseURl}/api/student/verifyForgotPassword'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'OTP': otp}));

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
        Uri.parse('${baseURl}/api/student/resetPassword'),
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
    final URL = '${baseURl}/api/student/resendOTPRegister';
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
    final URL = '${baseURl}/api/student/resendOTP';
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
