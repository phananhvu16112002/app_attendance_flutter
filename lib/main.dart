import 'package:attendance_system_nodejs/adapter/attendance_form_adapter.dart';
import 'package:attendance_system_nodejs/adapter/class_student_adapter.dart';
import 'package:attendance_system_nodejs/adapter/course_adapter.dart';
import 'package:attendance_system_nodejs/adapter/data_offline_adapter.dart';
import 'package:attendance_system_nodejs/adapter/student_adapter.dart';
import 'package:attendance_system_nodejs/adapter/student_classes_adapter.dart';
import 'package:attendance_system_nodejs/adapter/teacher_adapter.dart';
import 'package:attendance_system_nodejs/adapter/class_adapter.dart';
import 'package:attendance_system_nodejs/models/attendance_form.dart';
import 'package:attendance_system_nodejs/models/class_student.dart';
import 'package:attendance_system_nodejs/models/data_offline.dart';
import 'package:attendance_system_nodejs/models/student_classes.dart';
import 'package:attendance_system_nodejs/providers/attendanceDetail_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceFormForDetailPage_data_provider.dart';
import 'package:attendance_system_nodejs/providers/attendanceForm_data_provider.dart';
import 'package:attendance_system_nodejs/providers/classesStudent_data_provider.dart';
import 'package:attendance_system_nodejs/providers/socketServer_data_provider.dart';
import 'package:attendance_system_nodejs/providers/studentClass_data_provider.dart';
import 'package:attendance_system_nodejs/providers/student_data_provider.dart';
import 'package:attendance_system_nodejs/screens/Authentication/create_new_password.dart';
import 'package:attendance_system_nodejs/screens/Authentication/flash_screen.dart';
import 'package:attendance_system_nodejs/screens/Authentication/forgot_password.dart';
import 'package:attendance_system_nodejs/screens/Authentication/forgot_password_otp_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/otp_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/register_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/sign_in_page.dart';
import 'package:attendance_system_nodejs/screens/Authentication/welcome_page.dart';
import 'package:attendance_system_nodejs/common/colors/colors.dart';
import 'package:attendance_system_nodejs/screens/Home/home_page/home_page.dart';
import 'package:attendance_system_nodejs/screens/Home/profile_page/profile.dart';
import 'package:attendance_system_nodejs/utils/sercure_storage.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  SecureStorage secureStorage = SecureStorage();
  WidgetsFlutterBinding.ensureInitialized();
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
  final token = await messaging.getToken();
  await secureStorage.writeSecureData('tokenFirebase', token!);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FaceCamera.initialize(); //Add this
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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.backgroundColor),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/Welcome': (context) => const WelcomePage(),
        '/Login': (context) => const SignInPage(),
        '/Register': (context) => const RegisterPage(),
        '/ForgotPassword': (context) => const ForgotPassword(),
        '/ForgotPasswordOTP': (context) => const ForgotPasswordOTPPage(),
        '/CreateNewPassword': (context) => const CreateNewPassword(),
        '/OTP': (context) => const OTPPage(),
        '/HomePage': (context) => const HomePage(),
        '/ProfilePage': (context) => const ProfilePage(),
        // '/DetailReport': (context) => const DetailReport(),
      },
      home: const FlashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// AfterAttendance(
//         attendanceDetail: AttendanceDetail(
//             studentDetail: 'studentDetail',
//             classDetail: 'classDetail',
//             attendanceForm: AttendanceForm(
//                 formID: 'formID',
//                 classes: 'classes',
//                 startTime: '',
//                 endTime: '',
//                 dateOpen: '',
//                 status: false,
//                 typeAttendance: 0,
//                 location: 'location',
//                 latitude: 0.0,
//                 longtitude: 0.0,
//                 radius: 0.0),
//             result: 1,
//             dateAttendanced: '',
//             location: 'location',
//             note: 'note',
//             latitude: 0.0,
//             longitude: 0.0,
//             url: ''),
//         classesStudent: ClassesStudent(
//             studentID: 'studentID',
//             classID: 'classID',
//             total: 10,
//             totalPresence: 10,
//             totalAbsence: 10,
//             totalLate: 10,
//             roomNumber: 'A0505',
//             shiftNumber: 5,
//             startTime: '',
//             endTime: '',
//             classType: 'classType',
//             group: 'group',
//             subGroup: 'subGroup',
//             courseID: 'courseID',
//             teacherID: 'teacherID',
//             courseName: 'courseName',
//             totalWeeks: 10,
//             requiredWeeks: 2,
//             credit: 2,
//             teacherEmail: 'teacherEmail',
//             teacherName: 'teacherName',
//             progress: 0.5),
//       ),

// AttendanceFormPage(
//         classesStudent: ClassesStudent(
//             studentID: 'studentID',
//             classID: 'classID',
//             total: 10,
//             totalPresence: 10,
//             totalAbsence: 10,
//             totalLate: 10,
//             roomNumber: 'A0505',
//             shiftNumber: 5,
//             startTime: '',
//             endTime: '',
//             classType: 'classType',
//             group: 'group',
//             subGroup: 'subGroup',
//             courseID: 'courseID',
//             teacherID: 'teacherID',
//             courseName: 'courseName',
//             totalWeeks: 10,
//             requiredWeeks: 2,
//             credit: 2,
//             teacherEmail: 'teacherEmail',
//             teacherName: 'teacherName',
//             progress: 0.5),
//       ),

// EditReportPage(
//         classesStudent: ClassesStudent(
//             studentID: 'studentID',
//             classID: 'classID',
//             total: 10,
//             totalPresence: 10,
//             totalAbsence: 10,/
//             totalLate: 10,
//             roomNumber: 'roomNumber',
//             shiftNumber: 5,
//             startTime: 'startTime',
//             endTime: 'endTime',
//             classType: 'classType',
//             group: 'group',
//             subGroup: 'subGroup',
//             courseID: 'courseID',
//             teacherID: 'teacherID',
//             courseName: 'courseName',
//             totalWeeks: 10,
//             requiredWeeks: 2,
//             credit: 2,
//             teacherEmail: 'teacherEmail',
//             teacherName: 'teacherName',
//             progress: 0.5),
//         reportData: ReportData(
//             reportID: 1,
//             topic: 'topic',
//             problem: 'problem',
//             message: 'message',
//             status: 'Pending',
//             createdAt: 'createdAt',
//             checkNew: false,
//             important: false,
//             reportImage: [ReportImage(imageID: 'imageID', imageURL: '')],
//             feedBack: FeedBack(
//                 feedbackID: 1,
//                 topicFeedback: 'topicFeedback',
//                 messageFeedback: 'messageFeedback',
//                 confirmStatus: 'Pending',
//                 createdAtFeedBack: '')),
//       ),


// ReportAttendance(
//         classesStudent: ClassesStudent(
//             studentID: 'studentID',
//             classID: 'classID',
//             total: 10,
//             totalPresence: 10,
//             totalAbsence: 10,
//             totalLate: 10,
//             roomNumber: 'roomNumber',
//             shiftNumber: 5,
//             startTime: 'startTime',
//             endTime: 'endTime',
//             classType: 'classType',
//             group: 'group',
//             subGroup: 'subGroup',
//             courseID: 'courseID',
//             teacherID: 'teacherID',
//             courseName: 'courseName',
//             totalWeeks: 10,
//             requiredWeeks: 2,
//             credit: 2,
//             teacherEmail: 'teacherEmail',
//             teacherName: 'teacherName',
//             progress: 0.5),
//         attendanceFormDataForDetailPage: AttendanceFormDataForDetailPage(
//             formID: '1',
//             startTime: '',
//             endTime: '',
//             status: false,
//             dateOpen: '',
//             type: 0,
//             latitude: 0.0,
//             longitude: 0.0,
//             radius: 0.0),
//       ),


// DetailPage(
//         classesStudent: ClassesStudent(
//             studentID: 'studentID',
//             classID: 'classID',
//             total: 10,
//             totalPresence: 10,
//             totalAbsence: 10,
//             totalLate: 10,
//             roomNumber: 'roomNumber',
//             shiftNumber: 5,
//             startTime: 'startTime',
//             endTime: 'endTime',
//             classType: 'classType',
//             group: 'group',
//             subGroup: 'subGroup',
//             courseID: 'courseID',
//             teacherID: 'teacherID',
//             courseName: 'courseName',
//             totalWeeks: 10,
//             requiredWeeks: 2,
//             credit: 2,
//             teacherEmail: 'teacherEmail',
//             teacherName: 'teacherName',
//             progress: 0.5),
//       ),
