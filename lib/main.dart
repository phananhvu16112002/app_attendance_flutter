import 'dart:io';
import 'dart:math';

import 'package:attendance_system_nodejs/TestApp/Test.dart';
import 'package:attendance_system_nodejs/TestApp/TestFace.dart';
import 'package:attendance_system_nodejs/adapter/attendance_form_adapter.dart';
import 'package:attendance_system_nodejs/adapter/class_student_adapter.dart';
import 'package:attendance_system_nodejs/adapter/course_adapter.dart';
import 'package:attendance_system_nodejs/adapter/data_offline_adapter.dart';
import 'package:attendance_system_nodejs/adapter/student_adapter.dart';
import 'package:attendance_system_nodejs/adapter/student_classes_adapter.dart';
import 'package:attendance_system_nodejs/adapter/teacher_adapter.dart';
import 'package:attendance_system_nodejs/adapter/class_adapter.dart';
import 'package:attendance_system_nodejs/kbyAI/facedetectionview.dart';
import 'package:attendance_system_nodejs/kbyAI/home_face.dart';
import 'package:attendance_system_nodejs/kbyAI/person.dart';
import 'package:attendance_system_nodejs/kbyAI/settings.dart';
import 'package:attendance_system_nodejs/l10n/l10n.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/data_offline.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/providers/attendanceDetail_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceForm_data_provider.dart';
import 'package:attendance_system_nodejs/providers/classesStudent_data_provider.dart';
import 'package:attendance_system_nodejs/providers/language_provider.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/create_new_password.dart';
import 'package:attendance_system_nodejs/screens/Authentication/flash_screen.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void _firebaseMessagingForegroundHandler(RemoteMessage message) {
  print("Handling a foreground message: ${message.messageId}");
}

bool isInternetConnected = false;
bool isEngland = true;
void main() async {
  SecureStorage secureStorage = SecureStorage();
  WidgetsFlutterBinding.ensureInitialized();
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      isInternetConnected = true;
    } else {
      isInternetConnected = false;
    }
  });

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true);
  if (Platform.isAndroid) {
    print('I am Android');
    final token = await messaging.getToken();
    print('Token: $token');
    await secureStorage.writeSecureData('tokenFirebase', token!);
    final id = await FirebaseInstallations.instance.getId();
    print('ID: $id');
  }
  if (Platform.isIOS) {
    print('I am IOS');
    final tokenIOS = await messaging.getAPNSToken();
    await secureStorage.writeSecureData('tokenFirebase', tokenIOS!);
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);
  await FaceCamera.initialize();
  await Hive.initFlutter();
  Hive.registerAdapter(ClassAdapter());
  Hive.registerAdapter(TeacherAdapter());
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(StudentClassesAdapter());
  Hive.registerAdapter(StudentAdapter());
  Hive.registerAdapter(AttendanceFormAdapter());
  Hive.registerAdapter(DataOfflineAdatper());
  Hive.registerAdapter(ClassesStudentAdapter());
  await Hive.openBox<StudentClasses>('student_classes');
  await Hive.openBox<DataOffline>('DataOfflineBoxes');
  await Hive.openBox<AttendanceForm>('AttendanceFormBoxes');
  await Hive.openBox<ClassesStudent>('classes_student_box');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StudentDataProvider()),
        ChangeNotifierProvider(create: (_) => StudentClassesDataProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceDetailDataProvider()),
        ChangeNotifierProvider(create: (_) => SocketServerProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceFormDataProvider()),
        ChangeNotifierProvider(create: (_) => ClassesStudentProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
            create: (_) => AttendanceFormDataForDetailPageProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            bool isEnglish = languageProvider.isEnglish;
            Locale locale = isEnglish ? Locale('en') : Locale('vi');
            return MaterialApp(
              supportedLocales: L10n.all,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              title: 'Attendance TDTU',
              theme: ThemeData(
                colorScheme:
                    ColorScheme.fromSeed(seedColor: AppColors.backgroundColor),
                useMaterial3: false,
              ),
              home:FlashScreen(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}

// AttendanceFormPageOffline(
//                 attendanceForm: AttendanceForm(
//                     formID: 'asd',
//                     classes: '1',
//                     startTime: '2024-03-03T10:57:55.000Z',
//                     endTime: '2024-03-03T10:57:55.000Z',
//                     dateOpen: '2024-03-03T10:57:55.000Z',
//                     status: false,
//                     typeAttendance: 0,
//                     location: 'location',
//                     latitude: 0,
//                     longtitude: 0,
//                     radius: 0),
//               ),


// AttendanceFormPageOffline(
//                 attendanceForm: AttendanceForm(
//                     formID: 'asd',
//                     classes: '1',
//                     startTime: 'startTime',
//                     endTime: 'endTime',
//                     dateOpen: 'dateOpen',
//                     status: false,
//                     typeAttendance: 0,
//                     location: 'location',
//                     latitude: 0,
//                     longtitude: 0,
//                     radius: 0),
//               ),


// DetailPageOffline(
//                 classesStudent: ClassesStudent(
//                     studentID: 'studentID',
//                     classID: 'classID',
//                     total: 10,
//                     totalPresence: 10,
//                     totalAbsence: 10,
//                     totalLate: 10,
//                     roomNumber: 'roomNumber',
//                     shiftNumber: 3,
//                     startTime: '2024-03-03T10:57:55.000Z',
//                     endTime: '2024-03-03T10:57:55.000Z',
//                     classType: 'classType',
//                     group: 'group',
//                     subGroup: 'subGroup',
//                     courseID: 'courseID',
//                     teacherID: 'teacherID',
//                     courseName: 'courseName',
//                     totalWeeks: 9,
//                     requiredWeeks: 9,
//                     credit: 9,
//                     teacherEmail: 'teacherEmail',
//                     teacherName: 'teacherName',
//                     progress: 0.5),
//               ),


// DetailPageOffline(
//                 classesStudent: ClassesStudent(
//                     studentID: 'studentID',
//                     classID: 'classID',
//                     total: 10,
//                     totalPresence: 10,
//                     totalAbsence: 10,
//                     totalLate: 10,
//                     roomNumber: 'roomNumber',
//                     shiftNumber: 3,
//                     startTime: '2024-03-03T10:57:55.000Z',
//                     endTime: '2024-03-03T10:57:55.000Z',
//                     classType: 'classType',
//                     group: 'group',
//                     subGroup: 'subGroup',
//                     courseID: 'courseID',
//                     teacherID: 'teacherID',
//                     courseName: 'courseName',
//                     totalWeeks: 9,
//                     requiredWeeks: 9,
//                     credit: 9,
//                     teacherEmail: 'teacherEmail',
//                     teacherName: 'teacherName',
//                     progress: 0.5),
//               ),




//  AttendanceFormPage( classesStudent: ClassesStudent(
//               studentID: 'studentID',
//               classID: 'classID',
//               total: 10,
//               totalPresence: 10,
//               totalAbsence: 10,
//               totalLate: 10,
//               roomNumber: 'roomNumber',
//               shiftNumber: 3,
//               startTime: '2024-03-03T10:57:55.000Z',
//               endTime: '2024-03-03T10:57:55.000Z',
//               classType: 'classType',
//               group: 'group',
//               subGroup: 'subGroup',
//               courseID: 'courseID',
//               teacherID: 'teacherID',
//               courseName: 'courseName',
//               totalWeeks: 9,
//               requiredWeeks: 9,
//               credit: 9,
//               teacherEmail: 'teacherEmail',
//               teacherName: 'teacherName',
//               progress: 0.5),)









// AttendanceFormPageQR(
//          attendanceForm: AttendanceForm(formID: 'formID', classes: 'classes', startTime: '2024-03-03T10:57:55.000Z', endTime: 'endTime', dateOpen: 'dateOpen', status: false, typeAttendance: 0 , location: 'location', latitude: 0.0, longtitude: 0.0, radius: 0.0),
//         )


// AfterAttendance(
//             attendanceDetail: AttendanceDetail(
//                 studentDetail: 'studentDetail',
//                 classDetail: 'classDetail',
//                 attendanceForm: AttendanceForm(
//                     formID: 'formID',
//                     classes: 'classes',
//                     startTime: '2024-03-03T10:57:55.000Z',
//                     endTime: 'endTime',
//                     dateOpen: 'dateOpen',
//                     status: false,
//                     typeAttendance: 0,
//                     location: 'location',
//                     latitude: 0.0,
//                     longtitude: 0.0,
//                     radius: 0.0),
//                 result: 0,
//                 dateAttendanced: 'dateAttendanced',
//                 location: 'location',
//                 note: 'note',
//                 latitude: 0,
//                 longitude: 0,
//                 url: 'url'),
//             classesStudent: ClassesStudent(
//                 studentID: 'studentID',
//                 classID: 'classID',
//                 total: 10,
//                 totalPresence: 10,
//                 totalAbsence: 10,
//                 totalLate: 10,
//                 roomNumber: 'roomNumber',
//                 shiftNumber: 3,
//                 startTime: '2024-03-03T10:57:55.000Z',
//                 endTime: '2024-03-03T10:57:55.000Z',
//                 classType: 'classType',
//                 group: 'group',
//                 subGroup: 'subGroup',
//                 courseID: 'courseID',
//                 teacherID: 'teacherID',
//                 courseName: 'courseName',
//                 totalWeeks: 9,
//                 requiredWeeks: 9,
//                 credit: 9,
//                 teacherEmail: 'teacherEmail',
//                 teacherName: 'teacherName',
//                 progress: 0.5))



