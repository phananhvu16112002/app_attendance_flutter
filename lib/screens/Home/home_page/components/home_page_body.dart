import 'dart:async';
import 'dart:convert';
import 'package:attendance_system_nodejs/common/bases/custom_app_bar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_rich_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/main.dart';
import 'package:attendance_system_nodejs/models/ModelForAPI/semester.dart';
import 'package:attendance_system_nodejs/models/attendance_detail.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/data_offline.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/providers/check_location_provider.dart';
import 'package:attendance_system_nodejs/providers/classesStudent_data_provider.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/detail_page/detail_page.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/detail_page_offline/detail_page_offline.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_offline/attendance_form_page_offline.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_QR/attendance_form_page_qr.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/components/search_page.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/widget/custom_calendar.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:attendance_system_nodejs/services/get_location/get_location_services.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'secure_storage'

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  String studentName = '';
  String studentID = '';
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  TextEditingController searchController = TextEditingController();
  bool activeQR = false;
  bool activeForm = false;
  Barcode? result;
  String? address;
  // final SecureStorage secureStorage = SecureStorage();
  final SecureStorage secureStorage = SecureStorage();
  late Box<DataOffline> dataOfflineBox;
  late Box<StudentClasses> studentClassesBox;
  late Box<ClassesStudent> classesStudentBox;
  bool scanningQR = false;
  bool isConnected = false;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final ScrollController _controller = ScrollController();
  late ProgressDialog _progressDialog;
  late LocationCheckProvider locationCheckProvider;
  late StudentDataProvider studentDataProvider;
  bool check = false;
  String dropdownvalue = '';
  int? selectedSemesterID;
  List<Semester> semesters = [];
  late Future<List<Semester>> _fetchSemester;

  @override
  void initState() {
    print('initSate');
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      checkLocationAndShowSnackbar();
    });
    getInfor().then((value) {
      setState(() {
        studentName = value[0];
        studentID = value[1];
      });
    });
    _progressDialog = _customLoading();
    studentClassesBox = Hive.box<StudentClasses>('student_classes');
    dataOfflineBox = Hive.box<DataOffline>('DataOfflineBoxes');
    classesStudentBox = Hive.box<ClassesStudent>('classes_student_box');
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          isConnected = result != ConnectivityResult.none;
          if (isConnected ||
              result != ConnectivityResult.none ||
              isInternetConnected) {
            sendDataToServer();
          } else {
            print('no internet');
          }
        });
      }
    });
    fetchSemester();

    locationCheckProvider =
        Provider.of<LocationCheckProvider>(context, listen: false);
    studentDataProvider =
        Provider.of<StudentDataProvider>(context, listen: false);
  }

  void fetchSemester() async {
    _fetchSemester = API(context).getSemester();
    _fetchSemester.then((value) {
      setState(() {
        semesters = value;
        dropdownvalue = semesters.first.semesterName ?? '';
        selectedSemesterID = semesters.first.semesterID;
      });
    });
  }

  ProgressDialog _customLoading() {
    return ProgressDialog(context,
        isDismissible: false,
        customBody: Container(
          width: double.infinity,
          height: 150.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.r)),
              color: Colors.white),
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: AppColors.primaryButton,
              ),
              5.verticalSpace,
              Text(
                'Loading',
                style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )),
        ));
  }

  void sendDataToServer() async {
    DataOffline? dataOffline = dataOfflineBox.getAt(0);
    String xFile = await SecureStorage().readSecureData('imageOffline');
    if (xFile.isNotEmpty && xFile != 'No Data Found' && dataOffline != null) {
      _progressDialog.show();
      String? location = await GetLocation()
          .getAddressFromLatLongWithoutInternet(
              dataOffline.latitude ?? 0.0, dataOffline.longitude ?? 0.0);
      // print('location: $location');
      bool check = await API(context).takeAttendanceOffline(
          dataOffline.studentID ?? '',
          dataOffline.classID ?? '',
          dataOffline.formID ?? '',
          dataOffline.dateAttendanced ?? '',
          location ?? '',
          dataOffline.latitude ?? 0.0,
          dataOffline.longitude ?? 0.0,
          XFile(xFile));
      if (check) {
        print('Successfully take attendance offline');
        await dataOfflineBox.delete('dataOffline');
        await _progressDialog.hide();
        customDialog('Successfully', 'Take attendance offline successfully!');
        if (dataOfflineBox.isEmpty) {
          print('Delete ok');
        } else {
          print('No delele local storage');
        }
      } else {
        await _progressDialog.hide();

        customDialog('Failed', 'Take attendance offline failed!');
        print('Failed take attendance offline');
      }
    } else {
      print('Data is not available');
    }
  }

  // void sendDataToServer() async {
  //   // DataOffline? dataOffline = dataOfflineBox.getAt(0);
  //   String xFile = await SecureStorage().readSecureData('imageOffline');
  //   String studentID = await SecureStorage().readSecureData('studentID');
  //   String latitude = await SecureStorage().readSecureData('latitude');
  //   String longitude = await SecureStorage().readSecureData('longitude');
  //   String classesOff = await SecureStorage().readSecureData('classes');
  //   String formID = await SecureStorage().readSecureData('formID');
  //   String time = await SecureStorage().readSecureData('time');

  //   if (xFile != 'No Data Found' || formID != 'No Data Found') {
  //     String? location = await GetLocation()
  //         .getAddressFromLatLongWithoutInternet(
  //             double.parse(latitude.toString()),
  //             double.parse(longitude.toString()));
  //     // print('location: $location');
  //     _progressDialog.show();
  //     bool check = await API(context).takeAttendanceOffline(
  //         studentID,
  //         classesOff,
  //         formID,
  //         time,
  //         location ?? '',
  //         double.parse(latitude.toString()),
  //         double.parse(longitude.toString()),
  //         XFile(xFile));
  //     if (check) {
  //       await _progressDialog.hide();
  //       await SecureStorage().deleteSecureData('imageOffline');
  //       print('Successfully take attendance offline');
  //       // await dataOfflineBox.delete('dataOffline');
  //       customDialog('Successfully', 'Take attendance offline successfully!');
  //     } else {
  //       await _progressDialog.hide();
  //       customDialog('Failed', 'Take attendance offline failed!');
  //       print('Failed take attendance offline');
  //     }
  //   } else {
  //     print('Data is not available');
  //   }
  // }

  Future<dynamic> customDialog(String title, String content) {
    return showDialog(
        context: context,
        builder: (builder) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        activeQR = false;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (mounted) {
        setState(() {
          result = scanData;
        });
        if (result != null &&
            result!.code != null &&
            result!.code!.isNotEmpty) {
          print('-------------Result:${result!.code}');
          print(
              'JSON: ${jsonDecode(result!.code.toString())}'); // modify and get value here.
          var temp = jsonDecode(result!.code.toString());
          if (isInternetConnected) {
            if (temp['typeAttendanced'] == 0 || temp['typeAttendanced'] == 1) {
              controller.pauseCamera();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AttendanceFormPageQR(
                          attendanceForm: AttendanceForm(
                              formID: temp['formID'],
                              classes: temp['classID'],
                              startTime: temp['startTime'],
                              endTime: temp['endTime'],
                              dateOpen: temp['dateOpen'],
                              status: false,
                              typeAttendance: temp['typeAttendanced'],
                              location: '',
                              latitude: 0.0,
                              longtitude: 0.0,
                              radius: 0.0),
                        )),
              );
            } else if (temp['typeAttendanced'] == 2) {
              var socketServerDataProvider =
                  Provider.of<SocketServerProvider>(context, listen: false);
              socketServerDataProvider.connectToSocketServer(temp['classID']);
              final studentProvider =
                  Provider.of<StudentDataProvider>(context, listen: false);
              double latitude = studentProvider.userData.latitude;
              double longitude = studentProvider.userData.longtitude;
              controller.pauseCamera();
              _progressDialog.show();
              String? location = await GetLocation()
                  .getAddressFromLatLongWithoutInternet(latitude, longitude);

              AttendanceDetail? attendanceDetail = await API(context)
                  .takeAttendance(
                      studentID,
                      temp['classID'],
                      temp['formID'],
                      DateTime.now().toString(),
                      location ?? '',
                      latitude,
                      longitude,
                      XFile(''),
                      int.parse(temp['typeAttendanced'].toString()));

              if (attendanceDetail != null) {
                controller.pauseCamera();
                socketServerDataProvider.takeAttendance(
                    attendanceDetail.studentDetail,
                    attendanceDetail.classDetail,
                    attendanceDetail.attendanceForm.formID,
                    attendanceDetail.dateAttendanced,
                    attendanceDetail.location,
                    attendanceDetail.latitude,
                    attendanceDetail.longitude,
                    attendanceDetail.result,
                    attendanceDetail.url);
                await _progressDialog.hide();
                await customDialog('Successfully Take Attendance',
                    'Please check your attendance in class!');
              } else {
                controller.pauseCamera();
                await _progressDialog.hide();
                await customDialog(
                    'Failed Attendance', 'Please take attendance again!');
              }
            } else {
              customDialog(
                  'Failed Attendance', 'Please check type attendance again!');
            }
          } else {
            controller.pauseCamera();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AttendanceFormPageOffline(
                        attendanceForm: AttendanceForm(
                            formID: temp['formID'],
                            classes: temp['classID'],
                            startTime: temp['startTime'],
                            endTime: temp['endTime'],
                            dateOpen: temp['dateOpen'],
                            status: false,
                            typeAttendance:
                                0, //0 vì không có mạng mặc định là quét mặt
                            location: '',
                            latitude: 0.0,
                            longtitude: 0.0,
                            radius: 0.0),
                      )),
            );
          }
        } else {
          print('Data is not available');
        }
      }
    });
  }

  Future<List> getInfor() async {
    var temp1 = await SecureStorage().readSecureData('studentName');
    var temp2 = await SecureStorage().readSecureData('studentID');
    var tempArray = [];
    tempArray.add(temp1);
    tempArray.add(temp2);
    return tempArray;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void saveListClassesStudent(List<ClassesStudent> listData) async {
    if (classesStudentBox.isOpen) {
      for (var temp in listData) {
        if (checkClassExist(temp.classID) == false) {
          await classesStudentBox.put(temp.classID, temp);
        }
      }
      print('Successfully Save List ClassesStudent');
    } else {
      print('Box is not open');
    }
  }

  bool checkClassExist(String classID) {
    if (classesStudentBox.isOpen) {
      var temp = classesStudentBox.get(classID);
      if (temp != null) {
        return true;
      }
    }
    return false;
  }

  void checkLocationAndShowSnackbar() {
    final studentDataProvider =
        Provider.of<StudentDataProvider>(context, listen: false);
    locationCheckProvider.updateIsInsideLocation(LatLng(
      studentDataProvider.userData.latitude,
      studentDataProvider.userData.longtitude,
    ));

    if (!locationCheckProvider.isInsideLocation &&
        !locationCheckProvider.showSnackBar) {
      locationCheckProvider.setShowSnackBar(true);
      _showContinuousSnackbar();
    }
  }

  void _showContinuousSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)?.no_inside_tdtu ??
            'You are not in TDTUs area'),
        duration: Duration(days: 365),
        action: SnackBarAction(
          label: AppLocalizations.of(context)?.btn_hide ?? 'Ẩn',
          onPressed: () {
            locationCheckProvider.setShowSnackBar(false);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentDataProvider = Provider.of<StudentDataProvider>(context);
    final classesStudentDataProvider =
        Provider.of<ClassesStudentProvider>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(const Duration(seconds: 3), () {
          setState(() {});
        });
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                // height: 310.h,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColors.colorAppbar,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r))),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(left: 13.w, top: 25.h, right: 13.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CustomText(
                                      message: AppLocalizations.of(context)
                                              ?.title_hi ??
                                          'Hi',
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.thirdText),
                                  CustomText(
                                      message: studentName,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ],
                              ),
                              5.verticalSpace,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person_3_outlined,
                                          size: 11.sp,
                                          color: AppColors.thirdText),
                                      CustomText(
                                          message: '$studentID | ',
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.thirdText),
                                      CustomText(
                                          message: AppLocalizations.of(context)
                                                  ?.title_student ??
                                              'Student',
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.thirdText),
                                    ],
                                  ),
                                ],
                              ),
                              10.verticalSpace,
                              Container(
                                width: 290.w,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        size: 11.sp, color: Colors.white),
                                    Expanded(
                                      child: Text(
                                        studentDataProvider.userData.location,
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              20.verticalSpace,
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 10.h, right: 0.w, bottom: 10.h),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25.r),
                                child: Image.asset(
                                  'assets/images/avatar.png',
                                  height: 55.h,
                                  width: 55.w,
                                  fit: BoxFit.cover,
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                        height: 1.h,
                        width: MediaQuery.of(context).size.width,
                        color: const Color.fromARGB(106, 255, 255, 255)),
                    5.verticalSpace,
                    const CustomCalendar(),
                    10.verticalSpace,
                    Container(
                        height: 1.h,
                        width: MediaQuery.of(context).size.width,
                        color: const Color.fromARGB(106, 255, 255, 255)),
                  ],
                ),
              ),
              Positioned(
                top: 285.h,
                left: 25.w,
                right: 25.w,
                child: semesterValue(),
              ),
              //Body 2
              checkQR()
            ]),
            if (!activeQR)
              isInternetConnected
                  ? callAPI(context, classesStudentDataProvider,selectedSemesterID)
                  : noInternetWithHive()
            else
              scanQR(context),
            20.verticalSpace
          ],
        ),
      ),
    );
  }

  Container scanQR(BuildContext context) {
    return Container(
      // height: 500.h,
      // padding: EdgeInsets.symmetric(vertical: 200),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          20.verticalSpace,
          CustomText(
              message: 'SCAN QR CODE',
              fontSize: 23.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryText),
          CustomText(
              message: 'Scanning will be started automatically',
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryText),
          // const SizedBox(
          //   height: 5,
          // ),
          5.verticalSpace,
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              height: 400.h,
              width: 500.w,
              child: QRView(
                  overlay: QrScannerOverlayShape(
                    borderLength: 30.h,
                    borderColor: AppColors.primaryButton,
                    borderWidth: 10.w,
                    borderRadius: 10.r,
                  ),
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated),
            ),
            Positioned(
              bottom: 30.h,
              // left: 150,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(5.r)),
                child: Center(
                  child: Text(
                    maxLines: 1,
                    result != null ? '${result!.code}' : 'Scan QR Code',
                    style: TextStyle(fontSize: 10.sp, color: Colors.white),
                  ),
                ),
              ),
            )
          ]),
          30.verticalSpace,
        ],
      ),
    );
  }

  Widget checkQR() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 345.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeQR = false;
                  });
                },
                child: Container(
                  width: 138.w,
                  height: 30.h,
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: activeQR ? Colors.white : AppColors.primaryButton,
                      border: Border.all(
                          color: AppColors.secondaryText, width: 1.w),
                      borderRadius: BorderRadius.all(Radius.circular(5.r))),
                  child: Center(
                      child: CustomText(
                          message: AppLocalizations.of(context)
                                  ?.btn_take_attendance ??
                              'Take Attendance',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              activeQR ? AppColors.primaryText : Colors.white)),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    activeQR = true;
                  });
                },
                child: Container(
                  width: 138.w,
                  height: 30.h,
                  margin: EdgeInsets.only(top: 10.h),
                  decoration: BoxDecoration(
                      color: activeQR ? AppColors.primaryButton : Colors.white,
                      border: Border.all(
                          color: AppColors.secondaryText, width: 1.w),
                      borderRadius: BorderRadius.all(Radius.circular(5.r))),
                  child: Center(
                      child: CustomText(
                          message: AppLocalizations.of(context)?.btn_scan_qr ??
                              'Scan QR',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              activeQR ? Colors.white : AppColors.primaryText)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  // Container searchClass() {
  //   return Container(
  //       padding: EdgeInsets.symmetric(vertical: 18.h),
  //       decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(15.r),
  //           boxShadow: [
  //             BoxShadow(
  //                 color: AppColors.secondaryText,
  //                 blurRadius: 5.r,
  //                 offset: const Offset(0.0, 0.0))
  //           ]),
  //       //Fix PrefixIcon
  //       child: Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 20.w),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             CustomText(
  //                 message: AppLocalizations.of(context)?.search_class ??
  //                     'Search Class',
  //                 fontSize: 12.sp,
  //                 fontWeight: FontWeight.w500,
  //                 color: AppColors.primaryText.withOpacity(0.5)),
  //             Icon(
  //               Icons.search,
  //               color: AppColors.primaryText.withOpacity(0.5),
  //               size: 15.sp,
  //             )
  //           ],
  //         ),
  //       ));
  // }

  Widget semesterValue() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondaryText,
            blurRadius: 5.r,
            offset: const Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButton<String>(
                menuMaxHeight: 150.h,
                borderRadius: BorderRadius.circular(10.r),
                value: dropdownvalue,
                icon: Icon(
                  Icons.arrow_downward,
                  color: Colors.transparent,
                  size: 15.sp,
                ),
                iconSize: 24.sp,
                elevation: 16,
                style: TextStyle(
                  color: AppColors.primaryText.withOpacity(0.5),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.transparent,
                ),
                onChanged: (newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                  selectedSemesterID = semesters
                      .firstWhere(
                          (semester) => semester.semesterName == newValue)
                      .semesterID;
                },
                items:
                    semesters.map<DropdownMenuItem<String>>((Semester value) {
                  return DropdownMenuItem<String>(
                    value: value.semesterName,
                    child: Text(value.semesterName ?? ''),
                  );
                }).toList(),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: AppColors.primaryText.withOpacity(0.5),
              size: 15.sp,
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<List<ClassesStudent>> callAPI(
      BuildContext context, ClassesStudentProvider classDataProvider,int? semesterID) {
    return FutureBuilder(
      future: API(context).getClassesStudent(semesterID), //Chinh parameter
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
              padding: EdgeInsets.only(
                  left: 5.w, right: 5.w, bottom: 10.h, top: 10.h),
              child: Column(
                children: [
                  customLoading(),
                  10.verticalSpace,
                  customLoading(),
                  10.verticalSpace,
                  customLoading(),
                ],
              ));
        } else if (snapshot.hasError) {
          print('Error');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          if (snapshot.data == [] ||
              snapshot.data!.isEmpty ||
              snapshot.data == null) {
            return Center(
              child: Container(
                width: 200.w,
                height: 350.h,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      100.verticalSpace,
                      Opacity(
                        opacity: 0.3,
                        child: Image.asset('assets/images/nodata.png'),
                      ),
                      5.verticalSpace,
                      CustomText(
                          message: "You haven't joint any classes yet!",
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryText.withOpacity(0.5)),
                      30.verticalSpace
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.data != null || snapshot.data != []) {
            // print('snapshot is null or []: ${snapshot.data}');
            List<ClassesStudent> studentClasses = snapshot.data!;
            saveListClassesStudent(studentClasses);
            Future.delayed(Duration.zero, () {
              classDataProvider.setClassesStudentList(studentClasses);
            });
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 20.h),
              shrinkWrap: true,
              itemCount: studentClasses.length,
              itemBuilder: (BuildContext context, int index) {
                var data = studentClasses[index];
                return Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 10.h),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context,'/DetailPage',arguments: {'studentClasses': data});
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  DetailPage(
                            classesStudent: data,
                          ),
                          transitionDuration: const Duration(milliseconds: 200),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 5.w,
                        right: 5.w,
                      ),
                      child: classInformation(
                        data.totalWeeks,
                        data.courseName,
                        data.teacherName,
                        data.courseID,
                        data.classType,
                        data.group,
                        data.subGroup,
                        data.shiftNumber,
                        data.roomNumber,
                        data.totalPresence,
                        data.totalAbsence,
                        data.totalLate,
                        data.progress,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        }
        return const Text('null');
      },
    );
  }

  Widget noInternet() {
    return Center(
      child: Container(
        width: 200.w,
        height: 350.h,
        child: Center(
          child: Column(
            children: [
              100.verticalSpace,
              Opacity(
                opacity: 0.5,
                child: Image.asset('assets/images/nointernet.png'),
              ),
              5.verticalSpace,
              Text(
                "Please check your internet!",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noInternetWithHive() {
    print('No internet with hive');
    if (classesStudentBox.isOpen || classesStudentBox.isNotEmpty) {
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 20.h),
        shrinkWrap: true,
        controller: _controller,
        itemCount: classesStudentBox.values.length,
        itemBuilder: (BuildContext context, int index) {
          var data = classesStudentBox.getAt(index);
          return Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 10.h),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        DetailPageOffline(
                      classesStudent: data,
                    ),
                    transitionDuration: const Duration(milliseconds: 200),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: classInformation(
                  data!.totalWeeks,
                  data.courseName,
                  data.teacherName,
                  data.courseID,
                  data.classType,
                  data.group,
                  data.subGroup,
                  data.shiftNumber,
                  data.roomNumber,
                  data.totalPresence,
                  data.totalAbsence,
                  data.totalLate,
                  double.parse(data.progress.toString()),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return noInternet();
    }
  }

  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(AppColors.primaryButton),
      ),
    );
  }

  Widget classInformation(
    int totalWeeks,
    String courseName,
    String teacherName,
    String courseID,
    String classType,
    String group,
    String subGroup,
    int shift,
    String roomNumber,
    int totalPresence,
    int totalAbsence,
    int totalLate,
    double progress,
  ) {
    return Container(
      width: double.infinity,
      // height: MediaQuery.of(context).size.height * 0.18,
      padding: EdgeInsets.symmetric(vertical: 13.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        boxShadow: [
          const BoxShadow(
            color: AppColors.secondaryText,
            blurRadius: 2,
            offset: Offset(3.0, 2.0),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                          child: SizedBox(
                            child: CircularPercentIndicator(
                              radius: 40.r,
                              lineWidth: 5.w,
                              percent: progress,
                              center: Text(
                                "$totalWeeks ${AppLocalizations.of(context)?.weeks ?? 'Weeks'}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              backgroundColor:
                                  AppColors.secondaryText.withOpacity(0.3),
                              progressColor: AppColors.primaryButton,
                              animation: true,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customRichText(
                                title:
                                    '${AppLocalizations.of(context)?.field_course ?? 'Course'}: ',
                                message: courseName,
                                fontWeightTitle: FontWeight.bold,
                                fontWeightMessage: FontWeight.w400,
                                colorText: AppColors.primaryText,
                                fontSize: 12.sp,
                              ),
                              5.verticalSpace,
                              customRichText(
                                title:
                                    '${AppLocalizations.of(context)?.field_course_type ?? 'Method'}: ',
                                message: classType,
                                fontWeightTitle: FontWeight.bold,
                                fontWeightMessage: FontWeight.w400,
                                colorText: AppColors.primaryText,
                                fontSize: 12.sp,
                              ),
                              5.verticalSpace,
                              customRichText(
                                title:
                                    '${AppLocalizations.of(context)?.field_lecturer ?? 'Lectuer'}: ',
                                message: teacherName,
                                fontWeightTitle: FontWeight.bold,
                                fontWeightMessage: FontWeight.w400,
                                colorText: AppColors.primaryText,
                                fontSize: 12.sp,
                              ),
                              5.verticalSpace,
                              customRichText(
                                title:
                                    '${AppLocalizations.of(context)?.field_course_id ?? 'Course ID'}: ',
                                message: courseID,
                                fontWeightTitle: FontWeight.bold,
                                fontWeightMessage: FontWeight.w400,
                                colorText: AppColors.primaryText,
                                fontSize: 12.sp,
                              ),
                              5.verticalSpace,
                              Row(
                                children: [
                                  customRichText(
                                    title:
                                        '${AppLocalizations.of(context)?.field_course_shift ?? 'Shift'}: ',
                                    message: "$shift",
                                    fontWeightTitle: FontWeight.bold,
                                    fontWeightMessage: FontWeight.w400,
                                    colorText: AppColors.primaryText,
                                    fontSize: 12.sp,
                                  ),
                                  // SizedBox(width: 5.w),
                                  customRichText(
                                    title:
                                        ' ${AppLocalizations.of(context)?.field_course_room ?? 'Room'}: ',
                                    message: roomNumber,
                                    fontWeightTitle: FontWeight.bold,
                                    fontWeightMessage: FontWeight.w400,
                                    colorText: AppColors.primaryText,
                                    fontSize: 11.5.sp,
                                  ),
                                ],
                              ),
                              5.verticalSpace,
                              Row(
                                children: [
                                  customRichText(
                                    title:
                                        '${AppLocalizations.of(context)?.field_course_group ?? 'Group'}: ',
                                    message: group,
                                    fontWeightTitle: FontWeight.bold,
                                    fontWeightMessage: FontWeight.w400,
                                    colorText: AppColors.primaryText,
                                    fontSize: 12.sp,
                                  ),
                                  SizedBox(width: 5.w),
                                  customRichText(
                                    title:
                                        '${AppLocalizations.of(context)?.field_course_subGroup ?? 'SubGroup'}: ',
                                    message: subGroup,
                                    fontWeightTitle: FontWeight.bold,
                                    fontWeightMessage: FontWeight.w400,
                                    colorText: AppColors.primaryText,
                                    fontSize: 12.sp,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 55.h),
                            width: 1.5.w,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customRichText(
                              title:
                                  '${AppLocalizations.of(context)?.stats_total_presence ?? 'Total Presence'}: ',
                              message: '${totalPresence.ceil()}',
                              fontWeightTitle: FontWeight.bold,
                              fontWeightMessage: FontWeight.w400,
                              colorText: AppColors.primaryText,
                              fontSize: 13.sp,
                            ),
                            5.verticalSpace,
                            customRichText(
                              title:
                                  '${AppLocalizations.of(context)?.stats_total_late ?? 'Total Late'}: ',
                              message: '$totalLate',
                              fontWeightTitle: FontWeight.bold,
                              fontWeightMessage: FontWeight.w400,
                              colorText: AppColors.primaryText,
                              fontSize: 13.sp,
                            ),
                            5.verticalSpace,
                            customRichText(
                              title:
                                  '${AppLocalizations.of(context)?.stats_total_absence ?? 'Total Absence'}: ',
                              message: '${totalAbsence.ceil()}',
                              fontWeightTitle: FontWeight.bold,
                              fontWeightMessage: FontWeight.w400,
                              colorText: AppColors.primaryText,
                              fontSize: 13.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customLoading() {
    return Container(
        // width: 410,
        // height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromARGB(164, 245, 244, 244),
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.secondaryText,
                  blurRadius: 5.0,
                  offset: Offset(3.0, 2.0))
            ]),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 15.h),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                child: Shimmer.fromColors(
                  baseColor: const Color.fromARGB(78, 158, 158, 158),
                  highlightColor: const Color.fromARGB(146, 255, 255, 255),
                  child: Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(78, 158, 158, 158),
                        highlightColor:
                            const Color.fromARGB(146, 255, 255, 255),
                        child: Container(
                            width: 200.w, height: 15.h, color: Colors.white)),
                    10.verticalSpace,
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(78, 158, 158, 158),
                        highlightColor: const Color.fromARGB(36, 255, 255, 255),
                        child: Container(
                            width: 200.w, height: 15.h, color: Colors.white)),
                    10.verticalSpace,
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(78, 158, 158, 158),
                        highlightColor:
                            const Color.fromARGB(146, 255, 255, 255),
                        child: Container(
                            width: 200.w, height: 15.h, color: Colors.white)),
                    10.verticalSpace,
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(78, 158, 158, 158),
                        highlightColor:
                            const Color.fromARGB(146, 255, 255, 255),
                        child: Container(
                            width: 200, height: 15, color: Colors.white)),
                    10.verticalSpace,
                    Row(
                      children: [
                        Shimmer.fromColors(
                            baseColor: const Color.fromARGB(78, 158, 158, 158),
                            highlightColor:
                                const Color.fromARGB(146, 255, 255, 255),
                            child: Container(
                                width: 50.w, height: 5.h, color: Colors.white)),
                        SizedBox(
                          width: 10.w,
                        ),
                        Shimmer.fromColors(
                            baseColor: const Color.fromARGB(78, 158, 158, 158),
                            highlightColor:
                                const Color.fromARGB(146, 255, 255, 255),
                            child: Container(
                                width: 50.w, height: 5.h, color: Colors.white)),
                      ],
                    ),
                    5.verticalSpace,
                  ],
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Shimmer.fromColors(
                  baseColor: const Color.fromARGB(78, 158, 158, 158),
                  highlightColor: const Color.fromARGB(146, 255, 255, 255),
                  child:
                      Container(width: 2.w, height: 90.h, color: Colors.white)),
              SizedBox(
                width: 5.w,
              ),
              Padding(
                padding: !activeForm
                    ? EdgeInsets.only(top: 20.h, bottom: 20.h)
                    : EdgeInsets.only(top: 20.h, bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(78, 158, 158, 158),
                        highlightColor:
                            const Color.fromARGB(146, 255, 255, 255),
                        child: Container(
                            width: 100.w, height: 15.h, color: Colors.white)),
                    10.verticalSpace,
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(78, 158, 158, 158),
                        highlightColor:
                            const Color.fromARGB(146, 255, 255, 255),
                        child: Container(
                            width: 100.w, height: 15.h, color: Colors.white)),
                    10.verticalSpace,
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(78, 158, 158, 158),
                        highlightColor:
                            const Color.fromARGB(146, 255, 255, 255),
                        child: Container(
                            width: 100.w, height: 15.h, color: Colors.white)),
                    10.verticalSpace,
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
