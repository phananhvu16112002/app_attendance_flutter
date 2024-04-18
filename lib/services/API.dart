import 'dart:convert';
import 'dart:io';
import 'package:attendance_system_nodejs/models/ModelForAPI/api_view_image/student_model.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/notification_model/notification_model.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/report_class/report_class.dart';
import 'package:attendance_system_nodejs/models/attendance_detail.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/attendance_form_data_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/attendance_detail_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelAPI_DetailPage_Version2/report_data_for_detail_page.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/ModelForAPI_ReportPage_Version1/report_model.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/screens/Authentication/welcome_page.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/report_class/report_class.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:attendance_system_nodejs/utils/constraints.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class API {
  BuildContext context;
  API(this.context);
  final String baseURL = Constrants().baseURlLocalhost;

  Future<String> getAccessToken() async {
    SecureStorage secureStorage = SecureStorage();
    var accessToken = await secureStorage.readSecureData('accessToken');
    return accessToken;
  }

  Future<String> refreshAccessToken(String refreshToken) async {
    var url = 'http://$baseURL:8080/api/token/refreshAccessToken'; // $baseURL
    var headers = {'authorization': refreshToken};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        // print('Create New AccessToken is successfully');
        var newAccessToken = jsonDecode(response.body)['accessToken'];
        return newAccessToken;
      } else if (response.statusCode == 401) {
        print('Refresh Token is expired'); // Navigation to welcomePage
        await SecureStorage().deleteSecureData('refreshToken');
        await SecureStorage().deleteSecureData('accessToken');
        // ignore: use_build_context_synchronously
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                // Navigate to WelcomePage when dialog is dismissed

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomePage(),
                  ),
                );
                return true; // Return true to allow pop
              },
              child: AlertDialog(
                backgroundColor: Colors.white,
                elevation: 0.5,
                title: const Text('Unauthorized'),
                content: const Text(
                    'Your session has expired. Please log in again.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        );
        return '';
      } else if (response.statusCode == 498) {
        print('Refresh Token is invalid');
        return '';
      } else {
        print(
            'Failed to refresh accessToken. Status code: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      print('Error234: $e');
      return '';
    }
  }

  Future<List<ClassesStudent>> getClassesStudent() async {
    var URL = 'http://$baseURL:8080/api/student/classes'; //$baseURL

    var accessToken = await getAccessToken();
    var headers = {'authorization': accessToken};
    try {
      final response = await http.get(Uri.parse(URL), headers: headers);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<ClassesStudent> data = [];

        if (responseData is List) {
          for (var temp in responseData) {
            if (temp is Map<String, dynamic>) {
              try {
                data.add(ClassesStudent.fromJson(temp));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Invalid data type: $temp');
            }
          }
        } else if (responseData is Map<String, dynamic>) {
          try {
            data.add(ClassesStudent.fromJson(responseData));
          } catch (e) {
            print('Error parsing data: $e');
          }
        } else {
          print('Unexpected data type: $responseData');
        }
        print('Data $data');
        return data;
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          headers['authorization'] = newAccessToken;
          final retryResponse =
              await http.get(Uri.parse(URL), headers: headers);
          if (retryResponse.statusCode == 200) {
            // print('-- RetryResponse.body ${retryResponse.body}');
            // print('-- Retry JsonDecode:${jsonDecode(retryResponse.body)}');
            dynamic responseData = jsonDecode(retryResponse.body);
            List<ClassesStudent> data = [];

            if (responseData is List) {
              for (var temp in responseData) {
                if (temp is Map<String, dynamic>) {
                  try {
                    data.add(ClassesStudent.fromJson(temp));
                  } catch (e) {
                    print('Error parsing data: $e');
                  }
                } else {
                  print('Invalid data type: $temp');
                }
              }
            } else if (responseData is Map<String, dynamic>) {
              try {
                data.add(ClassesStudent.fromJson(responseData));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Unexpected data type: $responseData');
            }

            // print('Data $data');
            return data;
          } else {
            return [];
          }
        } else {
          print('New Access Token is empty');
          return [];
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<ReportModel>> getReportDataForStudent() async {
    final URL = 'http://$baseURL:8080/api/student/reports'; //$baseURL

    var accessToken = await getAccessToken();
    var headers = {'authorization': accessToken};
    try {
      final response = await http.get(Uri.parse(URL), headers: headers);
      // print('Status: ${response.statusCode}');
      // print('message: ${jsonDecode(response.body)['message']}');
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        // print('data:${response.body}');
        List<ReportModel> data = [];

        if (responseData is List) {
          for (var temp in responseData) {
            if (temp is Map<String, dynamic>) {
              try {
                data.add(ReportModel.fromJson(temp));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Invalid data type: $temp');
            }
          }
        } else if (responseData is Map<String, dynamic>) {
          try {
            data.add(ReportModel.fromJson(responseData));
          } catch (e) {
            print('Error parsing data: $e');
          }
        } else {
          print('Unexpected data type: $responseData');
        }
        print('Data $data');
        return data;
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          headers['authorization'] = newAccessToken;
          final retryResponse =
              await http.get(Uri.parse(URL), headers: headers);
          // print('Status: ${retryResponse.statusCode}');
          if (retryResponse.statusCode == 200) {
            // print('-- RetryResponse.body ${retryResponse.body}');
            // print('-- Retry JsonDecode:${jsonDecode(retryResponse.body)}');
            dynamic responseData = jsonDecode(retryResponse.body);
            List<ReportModel> data = [];

            if (responseData is List) {
              for (var temp in responseData) {
                if (temp is Map<String, dynamic>) {
                  try {
                    data.add(ReportModel.fromJson(temp));
                  } catch (e) {
                    print('Error parsing data: $e');
                  }
                } else {
                  print('Invalid data type: $temp');
                }
              }
            } else if (responseData is Map<String, dynamic>) {
              try {
                data.add(ReportModel.fromJson(responseData));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Unexpected data type: $responseData');
            }

            // print('Data $data');
            return data;
          } else {
            return [];
          }
        } else {
          print('New Access Token is empty');
          return [];
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<ReportModelClass>> getReportInClass(String classID) async {
    final URL =
        'http://$baseURL:8080/api/student/classes/$classID/reports'; //$baseURL

    var accessToken = await getAccessToken();
    var headers = {'authorization': accessToken};
    try {
      final response = await http.get(Uri.parse(URL), headers: headers);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<ReportModelClass> data = [];

        if (responseData is List) {
          for (var temp in responseData) {
            if (temp is Map<String, dynamic>) {
              try {
                data.add(ReportModelClass.fromJson(temp));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Invalid data type: $temp');
            }
          }
        } else if (responseData is Map<String, dynamic>) {
          try {
            data.add(ReportModelClass.fromJson(responseData));
          } catch (e) {
            print('Error parsing data: $e');
          }
        } else {
          print('Unexpected data type: $responseData');
        }
        print('Data $data');
        return data;
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          headers['authorization'] = newAccessToken;
          final retryResponse =
              await http.get(Uri.parse(URL), headers: headers);
          if (retryResponse.statusCode == 200) {
            dynamic responseData = jsonDecode(retryResponse.body);
            List<ReportModelClass> data = [];

            if (responseData is List) {
              for (var temp in responseData) {
                if (temp is Map<String, dynamic>) {
                  try {
                    data.add(ReportModelClass.fromJson(temp));
                  } catch (e) {
                    print('Error parsing data: $e');
                  }
                } else {
                  print('Invalid data type: $temp');
                }
              }
            } else if (responseData is Map<String, dynamic>) {
              try {
                data.add(ReportModelClass.fromJson(responseData));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Unexpected data type: $responseData');
            }
            return data;
          } else {
            return [];
          }
        } else {
          print('New Access Token is empty');
          return [];
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<AttendanceDetailDataForDetailPage>>
      getAttendanceDetailForDetailPage(String classID) async {
    final URL =
        'http://$baseURL:8080/api/student/classes/detail/$classID'; //$baseURL

    var accessToken = await getAccessToken();
    var headers = {'authorization': accessToken};
    try {
      final response = await http.get(Uri.parse(URL), headers: headers);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<AttendanceDetailDataForDetailPage> data = [];

        if (responseData is List) {
          for (var temp in responseData) {
            if (temp is Map<String, dynamic>) {
              try {
                data.add(AttendanceDetailDataForDetailPage.fromJson(temp));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Invalid data type: $temp');
            }
          }
        } else if (responseData is Map<String, dynamic>) {
          try {
            data.add(AttendanceDetailDataForDetailPage.fromJson(responseData));
          } catch (e) {
            print('Error parsing data: $e');
          }
        } else {
          print('Unexpected data type: $responseData');
        }
        print('Data $data');
        return data;
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          headers['authorization'] = newAccessToken;
          final retryResponse =
              await http.get(Uri.parse(URL), headers: headers);
          if (retryResponse.statusCode == 200) {
            // print('-- RetryResponse.body ${retryResponse.body}');
            // print('-- Retry JsonDecode:${jsonDecode(retryResponse.body)}');
            dynamic responseData = jsonDecode(retryResponse.body);
            List<AttendanceDetailDataForDetailPage> data = [];

            if (responseData is List) {
              for (var temp in responseData) {
                if (temp is Map<String, dynamic>) {
                  try {
                    data.add(AttendanceDetailDataForDetailPage.fromJson(temp));
                  } catch (e) {
                    print('Error parsing data: $e');
                  }
                } else {
                  print('Invalid data type: $temp');
                }
              }
            } else if (responseData is Map<String, dynamic>) {
              try {
                data.add(
                    AttendanceDetailDataForDetailPage.fromJson(responseData));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Unexpected data type: $responseData');
            }

            // print('Data $data');
            return data;
          } else {
            return [];
          }
        } else {
          print('New Access Token is empty');
          return [];
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<NotificationModel>> getNotification() async {
    final URL = 'http://$baseURL:8080/api/student/notifications';

    var accessToken = await getAccessToken();
    var headers = {'authorization': accessToken};
    try {
      final response = await http.get(Uri.parse(URL), headers: headers);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        List<NotificationModel> data = [];

        if (responseData is List) {
          for (var temp in responseData) {
            if (temp is Map<String, dynamic>) {
              try {
                data.add(NotificationModel.fromJson(temp));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Invalid data type: $temp');
            }
          }
        } else if (responseData is Map<String, dynamic>) {
          try {
            data.add(NotificationModel.fromJson(responseData));
          } catch (e) {
            print('Error parsing data: $e');
          }
        } else {
          print('Unexpected data type: $responseData');
        }
        print('Data $data');
        return data;
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          headers['authorization'] = newAccessToken;
          final retryResponse =
              await http.get(Uri.parse(URL), headers: headers);
          if (retryResponse.statusCode == 200) {
            dynamic responseData = jsonDecode(retryResponse.body);
            List<NotificationModel> data = [];

            if (responseData is List) {
              for (var temp in responseData) {
                if (temp is Map<String, dynamic>) {
                  try {
                    data.add(NotificationModel.fromJson(temp));
                  } catch (e) {
                    print('Error parsing data: $e');
                  }
                } else {
                  print('Invalid data type: $temp');
                }
              }
            } else if (responseData is Map<String, dynamic>) {
              try {
                data.add(NotificationModel.fromJson(responseData));
              } catch (e) {
                print('Error parsing data: $e');
              }
            } else {
              print('Unexpected data type: $responseData');
            }
            return data;
          } else {
            return [];
          }
        } else {
          print('New Access Token is empty');
          return [];
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<bool> uploadMultipleImage(String studentID, List<XFile> images) async {
    final url = 'http://$baseURL:8080/api/student/sendImages';
    var accessToken = await getAccessToken();

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['studentID'] = studentID;
    request.headers['authorization'] = accessToken;
    for (var image in images) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile('file', stream, length,
          filename: image.path.split('/').last);
      request.files.add(multipartFile);
    }
    var response = await request.send();

    if (response.statusCode == 200) {
      print('Uploaded successfully');
      return true;
    } else if (response.statusCode == 498 || response.statusCode == 401) {
      var refreshToken = await SecureStorage().readSecureData('refreshToken');
      var newAccessToken = await refreshAccessToken(refreshToken);
      if (newAccessToken.isNotEmpty) {
        var retryRequest = http.MultipartRequest('POST', Uri.parse(url));
        retryRequest.fields['studentID'] = studentID;
        retryRequest.headers['authorization'] = newAccessToken;
        for (var image in images) {
          var stream = http.ByteStream(image.openRead());
          var length = await image.length();
          var multipartFile = http.MultipartFile('files', stream, length,
              filename: image.path.split('/').last);
          retryRequest.files.add(multipartFile);
        }
        var retryResponse = await retryRequest.send();
        if (retryResponse.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        print('New access Token is empty');
        return false;
      }
    } else {
      print('Upload failed with status code: ${response.statusCode}');
      return false;
    }
  }

  Future<ReportData?> viewReport(int? reportID) async {
    final URL =
        'http://$baseURL:8080/api/student/reports/detail/$reportID'; //$baseURL

    var accessToken = await getAccessToken();
    var headers = {'authorization': accessToken};
    try {
      final response = await http.get(Uri.parse(URL), headers: headers);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        ReportData data = ReportData.fromJson(responseData);

        print('Data $data');
        return data;
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          headers['authorization'] = newAccessToken;
          final retryResponse =
              await http.get(Uri.parse(URL), headers: headers);
          if (retryResponse.statusCode == 200) {
            dynamic retryResponseData = jsonDecode(retryResponse.body);
            ReportData data = ReportData.fromJson(retryResponseData);

            // print('Data $data');
            return data;
          } else {
            return null;
          }
        } else {
          print('New Access Token is empty');
          return null;
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<String> submitReport(String classID, String formID, String topic,
      String problem, String message, List<XFile?> listXFile) async {
    final URL = 'http://$baseURL:8080/api/student/report/submit'; //$baseURL
    // var imageBytes = await fileImage.readAsBytes();
    // var imageFile =
    //     http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg');
    var accessToken = await getAccessToken();
    try {
      var request = http.MultipartRequest('POST', Uri.parse(URL));
      request.headers['Authorization'] = accessToken;
      request.fields['classID'] = classID;
      request.fields['formID'] = formID;
      request.fields['topic'] = topic;
      request.fields['problem'] = problem;
      request.fields['message'] = message;

      for (var k = 0; k < listXFile.length; k++) {
        if (listXFile[k] != null) {
          // var picture = await http.MultipartFile.fromPath(
          //     'image$k', listXFile[k]!.path,
          //     filename: 'image.jpg');
          var imageBytes = await listXFile[k]!.readAsBytes();
          var picture = http.MultipartFile.fromBytes(
            'file',
            imageBytes,
          );

          request.files.add(picture);
          // request.fields['image$k'];
        }
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        //scueess
        dynamic data = jsonDecode(await response.stream.bytesToString());
        print('Message:${data['message']}');

        print('success submit');
        return data['message'];
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          final retryRequest = http.MultipartRequest('POST', Uri.parse(URL));
          retryRequest.headers['Authorization'] = newAccessToken;
          retryRequest.fields['classID'] = classID;
          retryRequest.fields['formID'] = formID;
          retryRequest.fields['topic'] = topic;
          retryRequest.fields['problem'] = problem;
          retryRequest.fields['message'] = message;
          for (var k = 0; k < listXFile.length; k++) {
            // var picture = await http.MultipartFile.fromPath(
            //     'files', listXFile[k]!.path,
            //     filename: 'image.jpg');
            // retryRequest.files.add(picture);

            var imageBytes = await listXFile[k]!.readAsBytes();
            var picture = http.MultipartFile.fromBytes(
              'file',
              imageBytes,
            );

            retryRequest.files.add(picture);
          }
          var retryResponse = await retryRequest.send();
          if (retryResponse.statusCode == 200) {
            //retry
            dynamic data =
                jsonDecode(await retryResponse.stream.bytesToString());
            print('Message:${data['message']}');
            print('access new submit scuess');
            return '';
          } else {
            dynamic data =
                jsonDecode(await retryResponse.stream.bytesToString());
            print('Message:${data['message']}');
            print('failed in access');
            return data['message'];
          }
        } else {
          dynamic data = jsonDecode(await response.stream.bytesToString());
          print('Message:${data['message']}');
          print('New Access Token is empty');
          return data['message'];
        }
      } else {
        dynamic data = jsonDecode(await response.stream.bytesToString());
        print('Message:${data['message']}');
        print('Failed to load data. Status code: ${response.statusCode}');
        return data['message'];
      }
    } catch (e) {
      print('Error here: $e');
      return '$e';
    }
  }

  Future<String> editReport(int reportID, String topic, String problem,
      String message, List<XFile?> listXFile, List<String> listDelete) async {
    final URL =
        'http://$baseURL:8080/api/student/report/edit/$reportID'; //$baseURL
    // var imageBytes = await fileImage.readAsBytes();
    // var imageFile =
    //     http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg');
    var accessToken = await getAccessToken();
    try {
      var request = http.MultipartRequest('PUT', Uri.parse(URL));
      request.headers['Authorization'] = accessToken;
      request.headers['Content-Type'] =
          'application/json; charset=UTF-8'; // Thêm Content-Type
      request.headers['Accept'] = 'application/json'; // Thêm Accept

      request.fields['topic'] = topic;
      request.fields['problem'] = problem;
      request.fields['message'] = message;
      request.fields['listDelete'] = jsonEncode(listDelete);
      for (int i = 0; i < listDelete.length; i++) {
        print(jsonEncode(listDelete[i]));
      }

      for (var k = 0; k < listXFile.length; k++) {
        if (listXFile[k] != null) {
          // var picture = await http.MultipartFile.fromPath(
          //     'image$k', listXFile[k]!.path,
          //     filename: 'image.jpg');
          var imageBytes = await listXFile[k]!.readAsBytes();
          var picture = http.MultipartFile.fromBytes(
            'file',
            imageBytes,
          );

          request.files.add(picture);
          // request.fields['image$k'];
        }
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        //scueess
        dynamic data = jsonDecode(await response.stream.bytesToString());
        print('Message:${data['message']}');

        print('success submit');
        return data['message'];
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          final retryRequest = http.MultipartRequest('PUT', Uri.parse(URL));
          retryRequest.headers['Authorization'] = newAccessToken;
          retryRequest.fields['topic'] = topic;
          retryRequest.fields['problem'] = problem;
          retryRequest.fields['message'] = message;
          for (var k = 0; k < listXFile.length; k++) {
            // var picture = await http.MultipartFile.fromPath(
            //     'files', listXFile[k]!.path,
            //     filename: 'image.jpg');
            // retryRequest.files.add(picture);

            var imageBytes = await listXFile[k]!.readAsBytes();
            var picture = http.MultipartFile.fromBytes(
              'file',
              imageBytes,
            );

            retryRequest.files.add(picture);
          }
          var retryResponse = await retryRequest.send();
          if (retryResponse.statusCode == 200) {
            //retry
            dynamic data =
                jsonDecode(await retryResponse.stream.bytesToString());
            print('Message:${data['message']}');
            print('access new submit scuess');
            return '';
          } else {
            dynamic data =
                jsonDecode(await retryResponse.stream.bytesToString());
            print('Message:${data['message']}');
            print('failed in access');
            return data['message'];
          }
        } else {
          dynamic data = jsonDecode(await response.stream.bytesToString());
          print('Message:${data['message']}');
          print('New Access Token is empty');
          return data['message'];
        }
      } else {
        dynamic data = jsonDecode(await response.stream.bytesToString());
        print('Message:${data['message']}');
        print('Failed to load data. Status code: ${response.statusCode}');
        return data['message'];
      }
    } catch (e) {
      print('Error here: $e');
      return '$e';
    }
  }

  Future<AttendanceDetail?> takeAttendance(
      String studentID,
      String classID,
      String formID,
      String dateAttendance,
      String location,
      double latitude,
      double longitude,
      XFile fileImage) async {
    var URL = 'http://$baseURL:8080/api/student/takeAttendance';
    var imageBytes = await fileImage.readAsBytes();
    var imageFile =
        http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg');
    // var imageFile = await http.MultipartFile.fromPath('image', fileImage.path);
    var request = http.MultipartRequest('POST', Uri.parse(URL))
      ..fields['studentID'] = studentID
      ..fields['classID'] = classID
      ..fields['formID'] = formID
      ..fields['dateTimeAttendance'] = dateAttendance
      ..fields['location'] = location
      ..fields['latitude'] = latitude.toString()
      ..fields['longitude'] = longitude.toString()
      ..files.add(imageFile);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Take Attendance Successfully');
        Map<String, dynamic> data =
            json.decode(await response.stream.bytesToString());
        AttendanceDetail attendanceDetail = AttendanceDetail.fromJson(data);
        // print('data:$data');
        return attendanceDetail;
      } else if (response.statusCode == 403) {
        Map<String, dynamic> data =
            json.decode(await response.stream.bytesToString());
        String message = data['message'];
        print('data: $data');
        print('message: ${data['message']}');

        print('Failed to take attendance: $message');
        return null;
      } else {
        Map<String, dynamic> data =
            json.decode(await response.stream.bytesToString());
        String message = data['message'];
        print('data: $data');
        print('message: ${data['message']}');
        print('studentID: $studentID');
        print('classID: $classID');
        print('formID: $formID');
        print('Failed to take attendance. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error sending request: $e');
      return null;
    }
  }

  Future<bool> takeAttendanceOffline(
      String studentID,
      String classID,
      String formID,
      String dateAttendance,
      String location,
      double latitude,
      double longitude,
      XFile fileImage) async {
    var URL = 'http://$baseURL:8080/api/student/takeAttendanceOffline';
    var imageBytes = await fileImage.readAsBytes();
    var imageFile =
        http.MultipartFile.fromBytes('file', imageBytes, filename: 'image.jpg');
    // var imageFile = await http.MultipartFile.fromPath('image', fileImage.path);
    var request = http.MultipartRequest('POST', Uri.parse(URL))
      ..fields['studentID'] = studentID
      ..fields['classID'] = classID
      ..fields['formID'] = formID
      ..fields['dateTimeAttendance'] = dateAttendance
      ..fields['location'] = location
      ..fields['latitude'] = latitude.toString()
      ..fields['longitude'] = longitude.toString()
      ..files.add(imageFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Take Attendance Successfully');
        Map<String, dynamic> data =
            json.decode(await response.stream.bytesToString());
        // AttendanceDetail attendanceDetail = AttendanceDetail.fromJson(data);

        return true;
      } else if (response.statusCode == 403) {
        Map<String, dynamic> data =
            json.decode(await response.stream.bytesToString());
        String message = data['message'];
        print('Failed to take attendance: $message');
        return false;
      } else {
        print('Failed to take attendance. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending request: $e');
      return false;
    }
  }

  Future<StudentModel?> getImageFace() async {
    var accessToken = await getAccessToken();
    var url = 'http://$baseURL:8080/api/student/images';
    var headers = {'authorization': accessToken};
    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        dynamic responseData = jsonDecode(response.body);
        StudentModel studentModel = StudentModel.fromJson(responseData);
        print('Data student model: $studentModel');
        return studentModel;
      } else if (response.statusCode == 498 || response.statusCode == 401) {
        var refreshToken = await SecureStorage().readSecureData('refreshToken');
        var newAccessToken = await refreshAccessToken(refreshToken);
        if (newAccessToken.isNotEmpty) {
          headers['authorization'] = newAccessToken;
          final retryResponse =
              await http.get(Uri.parse(url), headers: headers);
          if (retryResponse.statusCode == 200) {
            dynamic retryResponseData = jsonDecode(retryResponse.body);
            StudentModel data = StudentModel.fromJson(retryResponseData);
            return data;
          }
        } else {
          print('Access token is empty');
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('err:$e');
      return null;
    }
    return null;
  }

  Future<bool> testHello() async {
    final url = 'http://$baseURL:8080/test/testHello';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      dynamic resData = jsonDecode(response.body);
      print(resData);
      print('Message:${resData['messsage']}');
      return true;
    }
    return false;
  }
}
