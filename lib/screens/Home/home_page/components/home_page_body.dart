import 'dart:async';
import 'dart:convert';
import 'package:attendance_system_nodejs/common/bases/custom_app_bar.dart';
import 'package:attendance_system_nodejs/common/bases/custom_rich_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text.dart';
import 'package:attendance_system_nodejs/common/bases/custom_text_field.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/data_offline.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/providers/classesStudent_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/detail_page/detail_page.dart';
import 'package:attendance_system_nodejs/screens/DetailHome/detail_page_offline/detail_page_offline.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_offline/attendance_form_page_offline.dart';
import 'package:attendance_system_nodejs/screens/Home/attendance_form_page_QR/attendance_form_page_qr.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/widget/custom_calendar.dart';
import 'package:attendance_system_nodejs/services/api.dart';
import 'package:attendance_system_nodejs/services/get_location/get_location_services.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
// import 'package:attendance_system_nodejs/utils/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
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

  @override
  void initState() {
    print('initSate');
    super.initState();
    getInfor().then((value) {
      setState(() {
        studentName = value[0];
        studentID = value[1];
      });
    });
    studentClassesBox = Hive.box<StudentClasses>('student_classes');
    dataOfflineBox = Hive.box<DataOffline>('DataOfflineBoxes');
    classesStudentBox = Hive.box<ClassesStudent>('classes_student_box');
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (mounted) {
        setState(() {
          isConnected = result != ConnectivityResult.none;
          if (isConnected) {
            sendDataToServer();
          } else {
            print('no internet');
          }
        });
      }
    });
  }

  void sendDataToServer() async {
    DataOffline? dataOffline = dataOfflineBox.get('dataOffline');
    String xFile = await SecureStorage().readSecureData('imageOffline');
    if (xFile.isNotEmpty && xFile != 'No Data Found' && dataOffline != null) {
      String? location = await GetLocation()
          .getAddressFromLatLongWithoutInternet(
              dataOffline.latitude, dataOffline.longitude);
      // print('location: $location');
      bool check = await API(context).takeAttendanceOffline(
          dataOffline.studentID,
          dataOffline.classID,
          dataOffline.formID,
          dataOffline.dateAttendanced,
          location ?? '',
          dataOffline.latitude,
          dataOffline.longitude,
          XFile(xFile));
      if (check) {
        print('Successfully take attendance offline');
        await dataOfflineBox.delete('dataOffline');
        customDialog('Successfully', 'Take attendance offline successfully!');
        if (dataOfflineBox.isEmpty) {
          print('Delete ok');
        } else {
          print('No delele local storage');
        }
      } else {
        customDialog('Failed', 'Take attendance offline failed!');
        print('Failed take attendance offline');
      }
    } else {
      print('Data is not available');
    }
  }

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
                      Navigator.pop(context);
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
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
          if (isConnected) {
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

              //Send request(formid, classID, dateAttendanced, studentID, location, latitude, longitude)
            } else {
              print('Send Request---------');
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

  @override
  Widget build(BuildContext context) {
    final studentDataProvider = Provider.of<StudentDataProvider>(context);
    final classesStudentDataProvider =
        Provider.of<ClassesStudentProvider>(context, listen: false);
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(children: [
          Container(
            height: 310.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: AppColors.colorAppbar,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r))),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 13.w, top: 25.h, right: 13.w),
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
                                  message: 'Hi, ',
                                  fontSize: 24.sp,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person_3_outlined,
                                      size: 11.sp, color: AppColors.thirdText),
                                  CustomText(
                                      message: '$studentID | ',
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.thirdText),
                                  CustomText(
                                      message: 'Student',
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
                CustomCalendar(),
                10.verticalSpace,
                Container(
                    height: 1.h,
                    width: MediaQuery.of(context).size.width,
                    color: const Color.fromARGB(106, 255, 255, 255)),
              ],
            ),
          ),
          Positioned(
            top: 275.h,
            left: 25.w,
            right: 25.w,
            child: searchClass(),
          ),
          //Body 2
          checkQR()
        ]),
        if (!activeQR)
          StreamBuilder(
              stream: Connectivity().onConnectivityChanged,
              builder: (context, snapshot) {
                print(snapshot.toString());
                if (snapshot.hasData) {
                  ConnectivityResult? result = snapshot.data;
                  if (result == ConnectivityResult.wifi ||
                      result == ConnectivityResult.mobile) {
                    print('Have Internet');
                    return callAPI(context, classesStudentDataProvider);
                    // return classInformation(
                    //     10,
                    //     'Intro Programming',
                    //     'Mai Van Manh',
                    //     '5202020',
                    //     'Laboratory',
                    //     '10',
                    //     '5',
                    //     3,
                    //     'A0303',
                    //     2,
                    //     3,
                    //     4,
                    //     0.5);
                    // return customLoading();
                  } else if (result == ConnectivityResult.none ||
                      isConnected == false) {
                    print('No Internet');

                    return noInternetWithHive();
                  }
                }
                print('Check connected: $isConnected');
                return callAPI(context, classesStudentDataProvider);
              })
        else
          scanQR(context),
      ],
    ));
  }

  Container scanQR(BuildContext context) {
    return Container(
      height: 500.h,
      // padding: EdgeInsets.symmetric(vertical: 200),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
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

  Container checkQR() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 340.h),
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
                        color:
                            activeQR ? Colors.white : AppColors.primaryButton,
                        border: Border.all(
                            color: AppColors.secondaryText, width: 1.w),
                        borderRadius: BorderRadius.all(Radius.circular(5.r))),
                    child: Center(
                        child: CustomText(
                            message: 'Take Attendance',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: activeQR
                                ? AppColors.primaryText
                                : Colors.white)),
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
                        color:
                            activeQR ? AppColors.primaryButton : Colors.white,
                        border: Border.all(
                            color: AppColors.secondaryText, width: 1.w),
                        borderRadius: BorderRadius.all(Radius.circular(5.r))),
                    child: Center(
                        child: CustomText(
                            message: 'Scan QR',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: activeQR
                                ? Colors.white
                                : AppColors.primaryText)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container searchClass() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
                color: AppColors.secondaryText,
                blurRadius: 15.r,
                offset: Offset(0.0, 0.0))
          ]),
      //Fix PrefixIcon
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        readOnly: true,
        controller: searchController,
        keyboardType: TextInputType.text,
        style: TextStyle(
            color: AppColors.primaryText,
            fontWeight: FontWeight.normal,
            fontSize: 13.sp),
        obscureText: false,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1.w, color: AppColors.primaryButton),
                borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            suffixIcon: Icon(Icons.search, color: AppColors.secondaryText),
            hintText: 'Search class', // change here hinttext
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
                borderSide:
                    BorderSide(width: 1.w, color: AppColors.secondaryText)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
              borderSide:
                  BorderSide(width: 1.w, color: AppColors.primaryButton),
            )),
      ),
    );
  }

  FutureBuilder<List<ClassesStudent>> callAPI(
      BuildContext context, ClassesStudentProvider classDataProvider) {
    return FutureBuilder(
      future: API(context).getClassesStudent(), //Chinh parameter
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
                      // const SizedBox(
                      //   height: 5,
                      // ),
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
            return SizedBox(
              height: 500.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      padding: EdgeInsets.only(top: 20.h),
                      shrinkWrap: true,
                      itemCount: studentClasses.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data = studentClasses[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 5.w, right: 5.w, bottom: 10.h),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pushNamed(context,'/DetailPage',arguments: {'studentClasses': data});
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      DetailPage(
                                    classesStudent: data,
                                  ),
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                    ),
                    20.verticalSpace,
                  ],
                ),
              ),
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
        width: 200,
        height: 350,
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Opacity(
                opacity: 0.5,
                child: Image.asset('assets/images/nointernet.png'),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Please check your internet!",
                style: TextStyle(
                  fontSize: 12,
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
    if (classesStudentBox.isOpen || classesStudentBox.isNotEmpty) {
      return SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                padding: const EdgeInsets.only(top: 20),
                shrinkWrap: true,
                controller: _controller,
                itemCount: classesStudentBox.values.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = classesStudentBox.getAt(index);
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    DetailPageOffline(
                              classesStudent: data,
                            ),
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                        ),
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
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
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
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            boxShadow: [
              BoxShadow(
                  color: AppColors.secondaryText,
                  blurRadius: 5,
                  offset: Offset(5.0, 4.0))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 10.h),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h, top: 20.h),
                    child: SizedBox(
                      // width: 55.,
                      // height: 80,
                      child: CircularPercentIndicator(
                        radius: 40.r,
                        lineWidth: 6.w,
                        percent: progress, // Thay đổi giá trị tại đây
                        center: Text(
                          "$totalWeeks Weeks",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 11.sp),
                        ),
                        backgroundColor: AppColors.secondaryText,
                        progressColor: AppColors.primaryButton,
                        animation: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Container(
                    // width: 165,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customRichText(
                          title: 'Course: ',
                          message: courseName,
                          fontWeightTitle: FontWeight.bold,
                          fontWeightMessage: FontWeight.w400,
                          colorText: AppColors.primaryText,
                          fontSize: 11.sp,
                        ),
                        5.verticalSpace,
                        customRichText(
                          title: 'Type: ',
                          message: classType,
                          fontWeightTitle: FontWeight.bold,
                          fontWeightMessage: FontWeight.w400,
                          colorText: AppColors.primaryText,
                          fontSize: 11.sp,
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        5.verticalSpace,
                        customRichText(
                          title: 'Lectuer: ',
                          message: teacherName,
                          fontWeightTitle: FontWeight.bold,
                          fontWeightMessage: FontWeight.w400,
                          colorText: AppColors.primaryText,
                          fontSize: 11.sp,
                        ),
                        5.verticalSpace,

                        customRichText(
                          title: 'CourseID: ',
                          message: courseID,
                          fontWeightTitle: FontWeight.bold,
                          fontWeightMessage: FontWeight.w400,
                          colorText: AppColors.primaryText,
                          fontSize: 11.sp,
                        ),
                        5.verticalSpace,

                        Row(
                          children: [
                            customRichText(
                              title: 'Shift: ',
                              message: "$shift",
                              fontWeightTitle: FontWeight.bold,
                              fontWeightMessage: FontWeight.w400,
                              colorText: AppColors.primaryText,
                              fontSize: 11.sp,
                            ),
                            10.verticalSpace,
                            customRichText(
                              title: 'Class: ',
                              message: roomNumber,
                              fontWeightTitle: FontWeight.bold,
                              fontWeightMessage: FontWeight.w400,
                              colorText: AppColors.primaryText,
                              fontSize: 11.sp,
                            ),
                          ],
                        ),
                        5.verticalSpace,

                        Row(
                          children: [
                            customRichText(
                              title: 'Group: ',
                              message: group,
                              fontWeightTitle: FontWeight.bold,
                              fontWeightMessage: FontWeight.w400,
                              colorText: AppColors.primaryText,
                              fontSize: 11.sp,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            customRichText(
                              title: 'SubGroup: ',
                              message: subGroup,
                              fontWeightTitle: FontWeight.bold,
                              fontWeightMessage: FontWeight.w400,
                              colorText: AppColors.primaryText,
                              fontSize: 11.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 25.h),
                      height: 90.h,
                      width: 1.5.w,
                      color: Colors.black),
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
                        customRichText(
                          title: 'Total Presence: ',
                          message: '${totalPresence.ceil()}',
                          fontWeightTitle: FontWeight.bold,
                          fontWeightMessage: FontWeight.w400,
                          colorText: AppColors.primaryText,
                          fontSize: 11.sp,
                        ),
                        5.verticalSpace,
                        customRichText(
                          title: 'Total Late: ',
                          message: '${totalLate}',
                          fontWeightTitle: FontWeight.bold,
                          fontWeightMessage: FontWeight.w400,
                          colorText: AppColors.primaryText,
                          fontSize: 11.sp,
                        ),
                        5.verticalSpace,
                        customRichText(
                          title: 'Total Absent: ',
                          message: '${totalAbsence.ceil()}',
                          fontWeightTitle: FontWeight.bold,
                          fontWeightMessage: FontWeight.w400,
                          colorText: AppColors.primaryText,
                          fontSize: 11.sp,
                        ),
                        15.verticalSpace,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget customLoading() {
    return Container(
        // width: 410,
        // height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color.fromARGB(164, 245, 244, 244),
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
            boxShadow: [
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
